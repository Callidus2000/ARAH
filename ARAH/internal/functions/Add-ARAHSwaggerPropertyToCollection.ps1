function Add-ARAHSwaggerPropertyToCollection {
    <#
    .SYNOPSIS
    Adds a new Swagger Properties to the existing collections.

    .DESCRIPTION
    Internal Helper Function for Swagger Function Generation.
    Adds new Swagger Properties to the existing collections.

    .PARAMETER PropertyObject
    The Swagger Property.

    .PARAMETER PropertyName
    The Name of the property

    .PARAMETER SwaggerObject
    The full Swagger Spec as a PSCustomObject.

    .PARAMETER SwaggerParams
    A HashTable with the already found parameters.

    .PARAMETER RequiredPoperties
    An array of the property names of all mandatory properties.

    .PARAMETER TargetHashMap
    The target HashMap for the property, most times a HashTable which represents the body parameter.

    .EXAMPLE
    An example will be missing.

    As the function is only used internally.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        $PropertyObject,
        $PropertyName,
        $SwaggerObject,
        $SwaggerParams,
        $RequiredPoperties,
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
        $mandatory = ($PropertyName -in $RequiredPoperties)
        switch -regex ($PropertyObject.type) {
            '(string)|(boolean)' {
                Write-PSFMessage "Simple Property Type: $($PropertyObject.type)" -Level Debug
                $TargetHashMap.$PropertyName = $PropertyObject.type
                $newParam = [PSCustomObject]@{
                    name            = $PropertyName
                    capitalizedName = ($PropertyName).substring(0, 1).toupper() + ($PropertyName).substring(1)
                    type            = $PropertyObject.type
                    description     = $PropertyObject.description
                    example         = $PropertyObject.example
                    enum            = $PropertyObject.enum
                    mandatory       = $mandatory
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