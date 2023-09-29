function Invoke-ARAHRequest {
    <#
    .SYNOPSIS
    Generic API Call to a REST API.

    .DESCRIPTION
    Generic API Call to the ARAH API. This function is a wrapper for the usage of Invoke-WebRequest. It handles some annoying repetitive tasks which occur in most use cases. This includes (list may be uncompleted)
    - Connecting to a server with authentication
    - Parsing API parameter
    - Handling $null parameter
    - Paging for API endpoints which do only provide limited amounts of datasets

    .PARAMETER Connection
    Object of Class [ARAHConnection], stores the authentication Token and the API Base-URL. Can be obtained with Connect-ARAH.

    .PARAMETER Path
    API Path to the REST function, starting *after* the configured Connection.WebServiceRoot.
    Example: "/v4/users"

    .PARAMETER Body
    Parameter for the API call; The hashtable is Converted to the POST body by using ConvertTo-Json

    .PARAMETER URLParameter
    Parameter for the API call; Converted to the GET URL parameter set.
    Example:
    {
        id=4
        name=Jon Doe
    }
    will result in "?id=4&name=Jon%20Doe" being added to the URL Path

    .PARAMETER Method
    HTTP Method, Get/Post/Delete/Put/...

    .PARAMETER ContentType
    HTTP-ContentType, defaults to "application/json;charset=UTF-8" and is provided by an
    attribute of the Connection.
    See Publish-ARAHFile for usage.

    .PARAMETER InFile
    File which should be transferred during the Request.
    See Publish-ARAHFile for usage.

    .PARAMETER SkipCheck
    Array of checks which should be skipped while using Invoke-WebRequest.
    Possible Values 'CertificateCheck', 'HttpErrorCheck', 'HeaderValidation'.
    If neccessary by default for the connection set $connection.SkipCheck

    .PARAMETER EnablePaging
    If the API makes use of paging (therefor of limit/offset URLParameter) setting EnablePaging to $true will not return the raw data but a combination of all data sets.

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .PARAMETER RequestModifier
    Name of a registered PSFScriptBlock which should be processed prior to the real WebRequest.

    .PARAMETER PagingHandler
    Name of a registered PSFScriptBlock which should process the automatic paging of data.

    .PARAMETER ConvertJsonAsHashtable
    If set the json result will be converted as a HashTable

    .EXAMPLE
    $result = Invoke-ARAH -connection $this -path "/v4/auth/login" -method POST -body @{login = $credentials.UserName; password = $credentials.GetNetworkCredential().Password; language = "1"; authType = "sql" } -hideparameters $true

    Login to the service

    .NOTES
    If the -Debug switch is used, Request and Response are saved for inspection in
    $global:invokeARAHrestAPIParameter
    $global:invokeARAHresponse
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
    param (
        [parameter(Mandatory)]
        [ARAHConnection]$Connection,
        [parameter(Mandatory)]
        [Microsoft.Powershell.Commands.WebRequestMethod]$Method,
        [parameter(Mandatory)]
        [string]$Path,
        $Body,
        [Hashtable] $URLParameter,
        [string]$InFile,
        [string]$OutFile,
        [string]$ContentType,
        [bool]$EnableException = $true,
        [ValidateSet('CertificateCheck', 'HttpErrorCheck', 'HeaderValidation')]
        [String[]]$SkipCheck = @(),
        [string]$RequestModifier,
        [string]$PagingHandler,
        [switch]$ConvertJsonAsHashtable,
        [switch]$EnablePaging
    )
    $uri = $connection.webServiceRoot + $path
    if ($ContentType) {
        $effectiveContentType = $ContentType
        Write-PSFMessage "Using contentType from Parameter: $effectiveContentType"
    }
    else {
        $effectiveContentType = $connection.ContentType
        Write-PSFMessage "Using contentType from Connection: $effectiveContentType"
    }
    $SkipCheckAndValidation = ($SkipCheck + $Connection.SkipCheck) | Select-Object -Unique
    if ($URLParameter) {
        Write-PSFMessage "Converting UrlParameter to a Request-String and add it to the path" -Level Debug
        Write-PSFMessage "$($UrlParameter| ConvertTo-Json -WarningAction SilentlyContinue)" -Level Debug
        $parameterString = (Get-ARAHEncodedParameterString($URLParameter))
        $uri = $uri + '?' + $parameterString.trim("?")
    }
    $restAPIParameter = @{
        Uri         = $Uri
        method      = $Method
        Headers     = $connection.headers
        ContentType = $effectiveContentType
        WebSession  = $connection.WebSession
        Credential  = $connection.Credential
    }
    if ($SkipCheckAndValidation.Count -gt 0) {
        Write-PSFMessage "Skipping the following checks during http request: $($SkipCheckAndValidation|Join-String ',')"
        $SkipCheckAndValidation | ForEach-Object { $restAPIParameter."Skip$_" = $true }
    }
    If ($Body) {
        switch ($Body.GetType().name) {
            'Hashtable' {
                switch -Regex ($effectiveContentType) {
                    'json' {
                        Write-PSFMessage "Converting HashTable body param to json-string"
                        $restAPIParameter.body = ($Body | Remove-ARAHNullFromHashtable -Json)
                    }
                    default {
                        Write-PSFMessage "No special handling for HashTable type body param, passing HashTable directly to Invoke-WebRequest -Body"
                        $restAPIParameter.body = $Body
                    }
                }
            }
            'String' { $restAPIParameter.body = $Body }
            Default { Write-PSFMessage -Level Warning "Unknown Body-Type: $($Body.GetType().name)" }
        }
    }
    If ($InFile) {
        $restAPIParameter.InFile = $InFile
    }
    If ($OutFile) {
        $restAPIParameter.OutFile = $OutFile
    }

    try {
        If ($RequestModifier) {
            [PSFScriptBlock]$reqModifierScript = Get-PSFScriptBlock -Name $RequestModifier
            $reqModifierScript.InvokeEx($false, $true, $true)
        }
        Write-ARAHCallMessage $restAPIParameter
        $response = Invoke-WebRequest @restAPIParameter
        if($OutFile){return}
        if ($PSBoundParameters.Debug) {
            $global:invokeARAHrestAPIParameter = $restAPIParameter
            Write-PSFMessage "Saving restAPIParameter to `$global:invokeARAHrestAPIParameter" -level Debug
            $global:invokeARAHresponse = $response
            Write-PSFMessage "Saving response to `$global:invokeARAHresponse" -level Debug
        }
        # $global:rap = $restAPIParameter
        # $global:rapRes = $response
        $result = $response.Content
        if ($result -is [byte[]]) {
            Write-PSFMessage "Converting Byte[] into String, using charset $($connection.Charset.EncodingName)"
            $result = $connection.Charset.GetString($result)
        }
        if ($connection.OverrideResultEncoding) {
            Write-PSFMessage "Response is handled as $([System.Text.Encoding]::GetEncoding(28591).EncodingName), but is in reality $($connection.Charset.EncodingName); Recoding started"
            $result = $connection.Charset.GetString([System.Text.Encoding]::GetEncoding(28591).getBytes($result))
        }
        if ($effectiveContentType -like '*json*') {
            if ($ConvertJsonAsHashtable){
                $result = $result | ConvertFrom-Json -AsHashtable
            }else{
                $result = $result | ConvertFrom-Json
            }
        }
        Write-PSFMessage "Response-Header: $($response.Headers|Format-Table|Out-String)" -Level Debug
        Write-PSFMessage -Level Debug "result= $($result| ConvertTo-Json -WarningAction SilentlyContinue -Depth 5)"
        if ($EnablePaging -and $PagingHandler) {
            Write-PSFMessage "MurkSiPu '$($response.Gettype())'"
            [PSFScriptBlock]$pagingHandlerScript = Get-PSFScriptBlock -Name $PagingHandler
            $result = $pagingHandlerScript.InvokeEx($false, $true, $false)
        }
    }
    catch {
        $result = $_.errordetails
        Write-PSFMessage "$result" -Level Critical
        If ($EnableException) {
            throw $_#$result.Message
        }
        else {
            return
        }
    }
    return $result
}