function Get-ARAHCleanSwaggerInfo {
    [CmdletBinding()]
    param (
        $SwaggerObject,
        $Path,
        $Method
    )
    $parameterArray = @()
    $currentObject = $SwaggerObject.paths.$Path.$Method
    $swaggerParams = @{
        headerParameter    = @()
        functionParameters = @()
    }
    Write-PSFMessage "currentObject=$($currentObject|ConvertTo-Json -Depth 20)"
    foreach ($param in $currentObject.parameters) {
        switch ($param.in) {
            'header' {
                $swaggerParams.headerParameter += $param
            }
            'path' {
                # Write-PSFMessage "param=$($param|ConvertTo-Json -Depth 20)" -Level Warning
                $newParam = [PSCustomObject]@{
                    name        = $param.name
                    type        = $param.type
                    description = $param.description
                    enum        = $param.enum
                }
                Write-PSFMessage "newParam=$($newParam|ConvertTo-Json)" -Level Debug
                $SwaggerParams.FunctionParameters += $newParam
            }
            'body' {
                Write-PSFMessage "Verarbeite Body-Parameter"
                Write-PSFMessage "param=$($param|ConvertTo-Json -Depth 20)" -Level Debug
                $originalRef = $param.schema.'$ref' -replace '#\/(\w*)\/(\w*)', '$2'
                $body = Get-ARAHSwaggerBodyHashMap -SwaggerParams $swaggerParams -SwaggerObject $swaggerObj -OriginalRef $originalRef
            }
            Default {
                Write-PSFMessage "param=$($param|ConvertTo-Json -Depth 20)" -Level Warning
            }
        }
    }
    $cleanInfo = @{
        path               = $path
        method             = $Method
        summary            = $currentObject.summary
        description        = $currentObject.description
        operationId        = $currentObject.operationId
        consumes           = $currentObject.consumes
        produces           = $currentObject.produces
        headerParameter    = $SwaggerParams.headerParameter
        functionParameters = $SwaggerParams.functionParameters
        body               = $body
    }
    # Write-PSFMessage "cleanInfo=$($cleanInfo|ConvertTo-Json -depth 10)"
    $cleanInfo
}