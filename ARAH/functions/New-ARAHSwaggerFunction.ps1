function New-ARAHSwaggerFunction {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ParameterSetName = "uri")]
        $SwaggerUri,
        [parameter(mandatory = $true, ParameterSetName = "file")]
        $SwaggerPath,
        [parameter(mandatory = $true)]
        $OutPath,
        [switch]$Force
    )
    Write-PSFMessage "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
    $swaggerFile = "C:\DEV\odin.git\PSPlayground\Swagger\Gitea-swagger.v1.json"
    $swaggerFile = "C:\DEV\odin.git\PSPlayground\Swagger\Dracoon.json"
    if ($PSCmdlet.ParameterSetName -eq 'uri') {
        $swaggerObj = Get-ARAHSwaggerSpec -Uri $swaggerFile
    }
    else {
        $swaggerObj = Get-ARAHSwaggerSpec -Path $swaggerFile
    }

    $targetAPI = Get-ARAHSwaggerEndpoint -SwaggerObject $swaggerObj -chooseSingle
    if ($targetAPI) {
        $swaggerInfo = Get-ARAHCleanSwaggerInfo -SwaggerObject $swaggerObj -path $targetAPI."API-Path" -Method $targetAPI.Method
        # Write-PSFMessage -Level Host "$($cleanInfo|convertto-json -Depth 10)"
        # New-PSMDTemplate -TemplateName ARAHFunction -OutStore MyStore -FilePath $PSScriptRoot\þnameþ.ps1 -Force
        Invoke-PSMDTemplate -TemplateName ARAHFunction -OutPath $OutPath -Parameters @{name = $swaggerInfo.operationId } -Force:$Force
    }
}