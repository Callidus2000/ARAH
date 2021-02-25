function Get-ARAHSwaggerSpec {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ParameterSetName = "uri")]
        $Uri,
        [parameter(mandatory = $true, ParameterSetName = "file")]
        $Path
    )
    if ($PSCmdlet.ParameterSetName -eq 'uri'){
        $Path="$($env:temp)\swagger.json"
        Invoke-WebRequest -Uri $Uri -OutFile $Path
    }
    Get-Content $Path | ConvertFrom-Json
}