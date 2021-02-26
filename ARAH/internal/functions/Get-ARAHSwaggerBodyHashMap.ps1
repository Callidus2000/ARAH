function Get-ARAHSwaggerBodyHashMap {
    <#
    .SYNOPSIS
    Gets the body of the API call as a HashTable.

    .DESCRIPTION
    Internal Helper Function for Swagger Function Generation.

    .PARAMETER SwaggerObject
    The full Swagger Spec as a PSCustomObject.

    .PARAMETER CurrentObject
    The current focused part of the Spec, representing a single API-

    .PARAMETER SwaggerParams
    A HashTable with the already found parameters.

    .PARAMETER OriginalRef
    The reference Name.

    .EXAMPLE
    An example will be missing.

    As the function is only used internally.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param (
        $SwaggerObject,
        $CurrentObject,
        $SwaggerParams,
        $OriginalRef
    )
    $body = @{}
    if ($OriginalRef) {
        Write-PSFMessage "DeReference $OriginalRef"
        $CurrentObject = $SwaggerObject.definitions.$OriginalRef
    }
    Write-PSFMessage "CurrentObject=$($CurrentObject|ConvertTo-Json -depth 10)" -Level Debug
    switch ($CurrentObject.type) {
        'object' {
            $propertyNames = $CurrentObject.properties.psobject.properties.name
            foreach ($propName in $propertyNames) {
                Add-ARAHSwaggerPropertyToCollection -PropertyName $propName -PropertyObject $CurrentObject.properties.$propName -SwaggerObject $SwaggerObject -SwaggerParams $SwaggerParams -TargetHashMap $body -RequiredPoperties $CurrentObject.required
            }
        }
        Default {
            Write-PSFMessage "Unknown Type: $($CurrentObject.type)" -Level Warning
        }
    }
    $body
}