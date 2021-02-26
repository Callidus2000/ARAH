function New-ARAHSwaggerFunction {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ParameterSetName = "uri")]
        $SwaggerUri,
        [parameter(mandatory = $true, ParameterSetName = "file")]
        $SwaggerPath,
        [parameter(mandatory = $true)]
        $OutPath,
        [parameter(mandatory = $false)]
        $InvokeCommand = "Invoke-ARAHRequest",
        [switch]$Force
    )
    if ($PSCmdlet.ParameterSetName -eq 'uri') {
        $swaggerObj = Get-ARAHSwaggerSpec -Uri $SwaggerUri
    }
    else {
        $swaggerObj = Get-ARAHSwaggerSpec -Path $SwaggerPath
    }

    $targetAPI = Get-ARAHSwaggerEndpoint -SwaggerObject $swaggerObj -chooseSingle
    if ($targetAPI) {
        $swaggerInfo = Get-ARAHCleanSwaggerInfo -SwaggerObject $swaggerObj -path $targetAPI."API-Path" -Method $targetAPI.Method
        # Write-PSFMessage -Level Host "$($cleanInfo|convertto-json -Depth 10)"
        # New-PSMDTemplate -TemplateName ARAHFunction -OutStore MyStore -FilePath $PSScriptRoot\þnameþ.ps1 -Force
        $global:hubba = $swaggerInfo
        $templateParameter = @{
            name    = $swaggerInfo.operationId
            method  = $swaggerInfo.method
            apiPath = $swaggerInfo.path
            body    = ""
            contentType    = $swaggerInfo.produces[0]
            summary = ($swaggerInfo.summary | Add-ARAHStringIntend -Intend 4)
            loggingSummary = $swaggerInfo.summary
            description = ($swaggerInfo.description | Add-ARAHStringIntend -Intend 4)
            invokeCommand  = $InvokeCommand
        }
        if ($swaggerInfo.body) {
            $bodyDefinition = $swaggerInfo.body | ConvertTo-Json -Depth 15
            $bodyDefinition = ($bodyDefinition -replace ': ', "= ")
            $bodyDefinition = ($bodyDefinition -ireplace ',')
            $bodyDefinition = ($bodyDefinition -replace '{', "@{")
            $bodyDefinition = ($bodyDefinition -replace '\[', "@(") -replace '\]', ')'
            $bodyDefinition = ($bodyDefinition -replace 'true', '$true') -replace 'false', '$false'
            $bodyDefinition = ($bodyDefinition -replace '"(\w*)"=  "(\w*)"', '$1=  "$$$1"')
            $bodyDefinition = ($bodyDefinition | Add-ARAHStringIntend -Intend 12).Trim(' ')
            $bodyDefinition = "Body=$bodyDefinition"
            $templateParameter.body = $bodyDefinition
        }
        Invoke-PSMDTemplate -TemplateName ARAHFunction -OutPath $OutPath -Parameters $templateParameter -Force:$Force
    }
}