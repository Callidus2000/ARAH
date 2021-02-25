function Get-ARAHSwaggerEndpoint {
    [CmdletBinding()]
    param (
        $SwaggerObject,
        [switch]$ChooseSingle
    )
    $possibleEndpoints = @()
    $allPathes = $swaggerObj.paths.psobject.properties.name
    foreach ($path in $allPathes) {
        foreach ($method in $swaggerObj.paths.$path.psobject.properties.name) {
            $possibleEndpoints += [PSCustomObject]@{
                Method     = $method
                "API-Path" = $path
                Summary    = $swaggerObj.paths.$path.$method.summary
            }
        }
    }
    if ($ChooseSingle) {
        $possibleEndpoints | Out-GridView -Title "Choose API Endpoint" -OutputMode Single
    }else {
        $possibleEndpoints
    }
}