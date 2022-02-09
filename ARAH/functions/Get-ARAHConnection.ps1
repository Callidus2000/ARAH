function Get-ARAHConnection {
    <#
    .SYNOPSIS
    Returns an ARAHConnectionObject which is initialized with the serverRoot and WebServiceRoot attributes.

    .DESCRIPTION
    Returns an ARAHConnectionObject which is initialized with the serverRoot and WebServiceRoot attributes.

    .PARAMETER Url
    The url/domain-name of the web-server

    .PARAMETER APISubPath
    The subpath for the API entry points

    .EXAMPLE
    Get-ARAHConnection -Url "my.server.de/" -APISubPath "/api/v4"

    Returns an object with .WebServiceRoot -eq "https://my.server.de/api/v4"

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([ARAHConnection])]
    param (
        [String]$Url,
        [String]$APISubPath
    )
    [ARAHConnection]::new($Url, $APISubPath)
}