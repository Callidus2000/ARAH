function Get-ARAHSwaggerSpec {
    <#
    .SYNOPSIS
    Retrieves the original Swagger Definition from a file or uri.

    .DESCRIPTION
    Helper Function for Swagger Function Generation.
    Retrieves the original Swagger Definition from a file or uri.

    .PARAMETER Uri
    The URI of the Swagger-Spec.

    .PARAMETER Path
    The Filepath to a pre-downloaded Swagger-Spec.

    .EXAMPLE
    (Get-ARAHSwaggerSpec -Uri "https://dracoon.team/api/spec_v4/")

    Returns the JSON Spec as a PSCustomObject.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ParameterSetName = "uri")]
        $Uri,
        [parameter(mandatory = $true, ParameterSetName = "file")]
        $Path
    )
    Write-PSFMessage "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
    if ($PSCmdlet.ParameterSetName -eq 'uri'){
        $Path="$($env:temp)\swagger.json"
        Write-PSFMessage "Downloading $uri to $Path"
        Invoke-WebRequest -Uri $Uri -OutFile $Path
    }
    Get-Content $Path | ConvertFrom-Json
}