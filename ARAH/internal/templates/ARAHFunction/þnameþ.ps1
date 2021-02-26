function þnameþ {
    <#
    .SYNOPSIS
þsummaryþ

    .DESCRIPTION
þdescriptionþ

þ{ (Get-PSFScriptblock -name 'ARAH.Swagger.FunctionParameters.Help').Invoke() }þ
    .PARAMETER Connection
    Object of Class ARAHConnection, stores the authentication Token and the API Base-URL

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    ToBeFilledOut

    Including Remarks

    .NOTES
    General notes
    #>
    param (
        [parameter(Mandatory)]
        $Connection,
þ{ (Get-PSFScriptblock -name 'ARAH.Swagger.FunctionParameters').Invoke() }þ
        $EnableException = $true
    )
    begin {
    }
    process {
    }
    end {
        $apiCallParameter = @{
            Connection = $Connection
            method     = "þmethodþ"
            Path       = "þapiPathþ"
            ContentType = "þcontentTypeþ"
            þbodyþ
        }

        $result = Invoke-DracoonAPI @apiCallParameter
        if ($result) {
            Invoke-PSFProtectedCommand -Action "þloggingSummaryþ" -Target $FileName -ScriptBlock {
                þinvokeCommandþ @apiCallParameter
            } -PSCmdlet $PSCmdlet -EnableException $EnableException -RetryCount 4 -RetryWait 5
        }
    }
}