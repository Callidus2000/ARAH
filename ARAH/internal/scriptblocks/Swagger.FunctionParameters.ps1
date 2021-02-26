Set-PSFScriptblock -Name 'ARAH.Swagger.FunctionParameters' -Scriptblock {
    $paramBlock = @()
    foreach ($param in $swaggerInfo.functionParameters) {
        # Build the Parameter-Settings
        if ($param.mandatory) {
            $paramBlock += '[parameter(Mandatory = $true, ParameterSetName = "default")]'
        }else {
            $paramBlock += '[parameter(Mandatory = $false, ParameterSetName = "default")]'
        }
        # Build the Parameter-Line [type]$ParamName,
        $paramBlock += "[$($param.type)]`$$($param.capitalizedName),"
    }
    ($paramBlock -join "`r`n") | Add-ARAHStringIntend -Intend 8
}