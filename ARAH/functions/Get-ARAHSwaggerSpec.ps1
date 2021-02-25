function Get-ARAHSwaggerSpec {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true, ParameterSetName = "uri")]
        $Uri,
        [parameter(mandatory = $true, ParameterSetName = "file")]
        $Path
    )
    Write-PSFMessage "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
    if ($PSCmdlet.ParameterSetName -eq 'uri'){
        $Path="$($env:temp)\swagger.json"
        Write-PSFMessage "Downloading $uri to $Path"
        Invoke-WebRequest -Uri $Uri -OutFile $Path
    }
    Get-Content $Path | ConvertFrom-Json
}