function Get-ARAHSwaggerEndpoint {
    <#
    .SYNOPSIS
    Query available Endpoints from a Swagger definition.

    .DESCRIPTION
    Helper Function for Swagger Function Generation.
    Query available Endpoints from a Swagger definition.

    .PARAMETER SwaggerObject
    The PSCustomObject which is based on the Swagger Information.
    Can be generated with Get-ARAHSwaggerSpec

    .PARAMETER ChooseSingle
    If used the user can choose with an Out-GridView.

    .EXAMPLE
    Get-ARAHSwaggerEndpoint -SwaggerObject (Get-ARAHSwaggerSpec -Uri "https://dracoon.team/api/spec_v4/")

    Returns the available CustomObjects like:

    Method API-Path                  Summary
    ------ --------                  -------
    post   /v4/auth/login            Authenticate user
    get    /v4/auth/openid/login     Initiate OpenID Connect authentication
    post   /v4/auth/openid/login     Complete OpenID Connect authentication
    get    /v4/auth/openid/resources Get OpenID Connect authentication resources
    ...

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([Object[]])]
    param (
        $SwaggerObject,
        [switch]$ChooseSingle
    )
    Write-PSFMessage "SwaggerObj=$($SwaggerObject|Out-String)"
    $possibleEndpoints = @()
    $allPathes = $SwaggerObject.paths.psobject.properties.name
    foreach ($path in $allPathes) {
        foreach ($method in $SwaggerObject.paths.$path.psobject.properties.name) {
            $possibleEndpoints += [PSCustomObject]@{
                Method     = $method
                "API-Path" = $path
                Summary    = $SwaggerObject.paths.$path.$method.summary
            }
        }
    }
    if ($ChooseSingle) {
        $possibleEndpoints | Out-GridView -Title "Choose API Endpoint" -OutputMode Single
    }else {
        $possibleEndpoints
    }
}