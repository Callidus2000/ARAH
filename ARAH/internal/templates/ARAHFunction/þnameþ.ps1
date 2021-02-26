﻿function þnameþ {
    <#
    .SYNOPSIS
þ{$swaggerInfo.summary | Add-ARAHStringIntend -Intend 4}þ

    .DESCRIPTION
þ{$swaggerInfo.description | Add-ARAHStringIntend -Intend 4}þ

þ{
    $paramBlock = @()
    foreach ($param in $swaggerInfo.functionParameters) {
        # Build the Parameter-Settings
        $paramBlock += ".PARAMETER $($param.capitalizedName)"
        $paramBlock += "$($param.description)"
        $paramBlock += ""
    }
    ($paramBlock -join "`r`n") | Add-ARAHStringIntend -Intend 4
}þ

þ{ #(Get-PSFScriptblock -name 'ARAH.Swagger.FunctionParameters.Help').Invoke() }þ
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
        $EnableException = $false
    )
    begin {
    }
    process {
    }
    end {
        Write-PSFMessage "Download ID: $($idArray -join ",")"
        $apiCallParameter = @{
            Connection = $Connection
            method     = "Post"
            Path       = "/v4/nodes/zip"
            Body       = @{
                nodeIds = $idArray
            }
        }

        $result = Invoke-DracoonAPI @apiCallParameter
        if ($result) {
            Invoke-PSFProtectedCommand -Action "Downloading" -Target $FileName -ScriptBlock {
                Invoke-WebRequest -Uri $result.downloadUrl -OutFile $FileName -ErrorAction Stop
            } -PSCmdlet $PSCmdlet -EnableException $EnableException -RetryCount 4 -RetryWait 5
        }
    }
}