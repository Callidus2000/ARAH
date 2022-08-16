function Write-ARAHCallMessage {
    <#
    .SYNOPSIS
    Writes information about an API invocation to the PFS Logging.

    .DESCRIPTION
    Writes information about an API invocation to the PFS Logging.

    .PARAMETER APICallParameter
    HashTable with all parameters forwarded from Invoke-ARAH to Invoke-RestMethod

    .EXAMPLE
    Write-ARAHCallMessage $restAPIParameter

    Logs the given parameter to the PSFLogging with Tag "APICALL"

    .EXAMPLE
    Get-PSFMessage -Tag "APICALL" |Select-Object -Last 1 -Property TargetObject,Message|Format-List

    Retrieves the last API call.

    .NOTES
    Logs are compressed by default. For troubleshooting set it to uncrompressed with
    Set-PSFConfig -Module 'ARAH' -Name 'logging.compressRequests' -Value $false
    #>
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        $APICallParameter
    )
    try {
        $compress=Get-PSFConfigValue -FullName 'ARAH.logging.compressRequests' -Fallback $true
        $jsonDepth = Get-PSFConfigValue -FullName 'ARAH.logging.jsonDepth' -Fallback 7
        $modifiedAPICallParameter = $APICallParameter.Clone()
        if (($modifiedAPICallParameter.Body -is [String]) -and ($modifiedAPICallParameter.ContentType -like '*json*')) {
            $modifiedAPICallParameter.Body = $modifiedAPICallParameter.Body | ConvertFrom-Json
        }
        $modifiedAPICallParameter.Method = "$($modifiedAPICallParameter.Method)".ToUpper()
        $callStack = (Get-PSCallStack | Select-Object -SkipLast 1 -ExpandProperty Command | Select-Object -Skip 1  )
        [Array]::Reverse($callStack)
        $callStackString = $callStack -join ">"
        Write-PSFMessage  -Level Debug "CallStack: $callStackString"
        $apiLogString = ($modifiedAPICallParameter | ConvertTo-Json -Depth $jsonDepth -Compress:$compress)
        # Remove confidental data
        $apiLogString = $apiLogString -replace '"Bearer (\w{5})\w*"', '"Bearer $1******************"'
        $apiLogString = $apiLogString -replace '("password":\s*").*"', '$1***********"'
        $apiLogString = $apiLogString -replace '("refresh_token":\s*").*"', '$1***********"'
        $apiLogString = $apiLogString -replace '("code":\s*").*"', '$1***********"'
        $apiLogString = $apiLogString -replace '("X-Sds-Auth-Token":\s*").*"', '$1***********"'
        $apiLogString = $apiLogString -replace '("Authorization":\s*"Basic ).*"', '$1[BASE64_ENCODED [CLIENT_ID]:[CLIENT_SECRET]]"'
        Write-PSFMessage -Level Debug "$apiLogString" -Tag "APICALL" -Target "$callStackString"
    }
    catch {
        Write-PSFMessage -Level Critical "Could not log API Call $_"
    }
}