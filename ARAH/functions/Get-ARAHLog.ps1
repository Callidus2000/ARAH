﻿function Get-ARAHLog {
    <#
    .SYNOPSIS
    Retrieves the log entries from Write-ARAHCallMessage.

    .DESCRIPTION
    Retrieves the log entries from Write-ARAHCallMessage.

    .PARAMETER Raw
    If set then the raw PSFMessages are returned.

    .PARAMETER Last
    If set only the Last entries are returned.

    .EXAMPLE
    Get-ARAHLog -Last 5

    Retrieves the last 5 logs.

    .NOTES
    General notes
    #>
    param (
        [switch]$Raw,
        [int]$Last = 0
    )
    $selectParam = @{    }
    if ($Last -gt 0){
        $selectParam.Last=$Last
    }
    if (!$Raw){
        $selectParam.Property = @("TargetObject", "Message")
    }
    $messages = Get-PSFMessage -Tag "APICALL" | Select-Object @selectParam
    if ($Raw) {
        $messages
    }else
    {
        $messages | Format-List
    }
}