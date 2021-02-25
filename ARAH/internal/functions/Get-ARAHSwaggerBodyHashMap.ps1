function Get-ARAHSwaggerBodyHashMap {
    [CmdletBinding()]
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
                Add-ARAHSwaggerPropertyToCollections -PropertyName $propName -PropertyObject $CurrentObject.properties.$propName -SwaggerObject $SwaggerObject -SwaggerParams $SwaggerParams -TargetHashMap $body -RequiredPoperties $CurrentObject.required
            }
        }
        Default {
            Write-PSFMessage "Unknown Type: $($CurrentObject.type)" -Level Warning
        }
    }
    $body
}