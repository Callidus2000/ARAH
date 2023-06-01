function Get-ARAHCleanSwaggerInfo {
    <#
    .SYNOPSIS
    Generates a HashMap with clean meta-information from a Swagger-definition.

    .DESCRIPTION
    Helper Function for Swagger Function Generation.
    Generates a HashMap with clean meta-information from a Swagger-definition.

    .PARAMETER SwaggerObject
    The PSCustomObject which is based on the Swagger Information.
    Can be generated with Get-ARAHSwaggerSpec

    .PARAMETER Path
    The API Path whose information is needed.

    .PARAMETER Method
    The api method.

    .EXAMPLE
    Get-ARAHCleanSwaggerInfo -SwaggerObject (Get-ARAHSwaggerSpec -Uri "https://dracoon.team/api/spec_v4/") -Path "/v4/config/info/defaults" -Method "get"

    Returns the definition like:

    Name                           Value
    ----                           -----
    functionParameters             {}
    summary                        Ping
    path                           /v4/auth/ping
    method                         get
    consumes
    operationId                    ping
    description                    ### Functional Description:...
    headerParameter                {}
    body
    produces                       {text/plain}

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    [OutputType([HashTable])]
    param (
        $SwaggerObject,
        $Path,
        $Method
    )
    $currentObject = $SwaggerObject.paths.$Path.$Method
    $swaggerParams = @{
        headerParameter    = @()
        functionParameters = @()
    }
    Write-PSFMessage "currentObject=$($currentObject| ConvertTo-Json -WarningAction SilentlyContinue -Depth 20)"
    foreach ($param in $currentObject.parameters) {
        switch ($param.in) {
            'header' {
                $swaggerParams.headerParameter += $param
            }
            'path' {
                # Write-PSFMessage "param=$($param| ConvertTo-Json -WarningAction SilentlyContinue -Depth 20)" -Level Warning
                $newParam = [PSCustomObject]@{
                    name            = $param.name
                    capitalizedName = ($param.name).substring(0, 1).toupper() + ($param.name).substring(1)
                    type            = $param.type
                    description     = $param.description
                    enum            = $param.enum
                    mandatory       = ($param.required -eq 'true')
                }
                Write-PSFMessage "newParam=$($newParam| ConvertTo-Json -WarningAction SilentlyContinue)" -Level Debug
                $SwaggerParams.FunctionParameters += $newParam
            }
            'body' {
                Write-PSFMessage "Verarbeite Body-Parameter"
                Write-PSFMessage "param=$($param| ConvertTo-Json -WarningAction SilentlyContinue -Depth 20)" -Level Debug
                $originalRef = $param.schema.'$ref' -replace '#\/(\w*)\/(\w*)', '$2'
                $body = Get-ARAHSwaggerBodyHashMap -SwaggerParams $swaggerParams -SwaggerObject $swaggerObj -OriginalRef $originalRef
            }
            Default {
                Write-PSFMessage "param=$($param| ConvertTo-Json -WarningAction SilentlyContinue -Depth 20)" -Level Warning
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
    # Write-PSFMessage "cleanInfo=$($cleanInfo| ConvertTo-Json -WarningAction SilentlyContinue -depth 10)"
    $cleanInfo
}