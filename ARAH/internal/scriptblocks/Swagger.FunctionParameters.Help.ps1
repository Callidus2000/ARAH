Set-PSFScriptblock -Name 'ARAH.Swagger.FunctionParameters.Help' -Scriptblock {
    $paramBlock = @()
    foreach ($param in $swaggerInfo.functionParameters) {
        # Build the Parameter-Settings
        $paramBlock += "    .PARAMETER $($param.capitalizedName)"
        $paramBlock += "    $($param.description)"
        $paramBlock += ""
    }
    ($paramBlock -join "`r`n")
}