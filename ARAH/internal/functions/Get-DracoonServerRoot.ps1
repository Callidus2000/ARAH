function Get-ARAHServerRoot {
<#
.SYNOPSIS
Cleans a given URL to be used as a server-root.

.DESCRIPTION
Cleans a given URL to be used as a server-root.

.PARAMETER Url
A FQDN/URL or the server

.EXAMPLE
Get-ARAHServerRoot "my.server.de"
Get-ARAHServerRoot "my.server.de/"
Get-ARAHServerRoot "http://my.server.de"
Get-ARAHServerRoot "http://my.server.de/"
All versions return "https://my.server.de"

.NOTES
General notes
#>
    param (
        [parameter(mandatory = $true, Position=0)]
        [string]$Url
    )
    Write-PSFMessage "Getting ARAH Server-Root for $Url"
    # Strip leading /
    $serverRoot = $Url.Trim("/")
    # Strip Prefix protocoll
    $serverRoot = $serverRoot -replace "^.*:\/\/"
    $serverRoot="https://$serverRoot"
    Write-PSFMessage "Result: $serverRoot"
    $serverRoot
}