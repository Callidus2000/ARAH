function Add-ARAHSwaggerPropertyToCollections {
    [CmdletBinding()]
    param (
        $PropertyObject,
        $PropertyName,
        $SwaggerObject,
        $SwaggerParams,
        $TargetHashMap
    )
    $isReference = [bool]($PropertyObject.originalRef)
    if ($isReference) {
        Write-PSFMessage "$PropertyName=$($PropertyObject|ConvertTo-Json -depth 5)"
        Write-PSFMessage "isReference"
        $hash = Get-ARAHSwaggerBodyHashMap -SwaggerObject $SwaggerObject -SwaggerParams $SwaggerParams -OriginalRef ($PropertyObject.originalRef)
        Write-PSFMessage "hash=$($hash|ConvertTo-Json)"
        $TargetHashMap.add($PropertyName, $hash)
    }
    else {
        switch -regex ($PropertyObject.type) {
            '(string)|(boolean)' {
                Write-PSFMessage "Simple Property Type: $($PropertyObject.type)" -Level Debug
                $TargetHashMap.$PropertyName = $PropertyObject.type
                $newParam = [PSCustomObject]@{
                    name        = $PropertyName
                    type        = $PropertyObject.type
                    description = $PropertyObject.description
                    example     = $PropertyObject.example
                    enum        = $PropertyObject.enum
                }
                Write-PSFMessage "newParam=$($newParam|ConvertTo-Json)" -Level Debug
                $SwaggerParams.FunctionParameters += $newParam
            }
            'array' {
                Write-PSFMessage "$PropertyName is an array"
                Write-PSFMessage "$PropertyName=$($PropertyObject|ConvertTo-Json -depth 5)"
                Write-PSFMessage "isReference"
                $itemDefinition = Get-ARAHSwaggerBodyHashMap -SwaggerObject $SwaggerObject -SwaggerParams $SwaggerParams -OriginalRef ($PropertyObject.items.originalRef)
                Write-PSFMessage "itemDefinition=$($itemDefinition|ConvertTo-Json)"
                $TargetHashMap.add($PropertyName, @($itemDefinition))
            }
            Default {
                Write-PSFMessage "Unknown Property Type: $($PropertyObject.type)" -Level Warning
                Write-PSFMessage "PropertyObject=$($PropertyObject|ConvertTo-Json -depth 5)" -Level Warning
            }
        }
    }
}