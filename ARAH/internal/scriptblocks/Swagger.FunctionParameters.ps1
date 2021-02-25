Set-PSFScriptblock -Name 'ARAH.Swagger.FunctionParameters' -Scriptblock {
    $paramBlock = @()
    foreach ($param in $swaggerInfo.functionParameters) {
        # Build the Parameter-Settings
        $paramLineArray = @()
        $paramLineArray += "        [parameter(mandatory = "
        if ($param.mandatory) { $paramLineArray += '$true' } else { $paramLineArray += '$false' }
        $paramLineArray += ", ParameterSetName = 'default')]"

        # $true
        # ', ParameterSetName = "uri")]'
        $paramLine = $paramLineArray -join ''
        $paramBlock += $paramLine

        # Build the Parameter-Line [type]$ParamName,
        $paramLineArray = @()
        $paramLineArray += '        ['
        $paramLineArray += $param.type
        $paramLineArray += ']$'
        # $paramLineArray += $TextInfo.ToTitleCase($param.name)
        # $capitalizedName = ($param.name).substring(0, 1).toupper() + ($param.name).substring(1)
        $paramLineArray += $param.capitalizedName
        $paramLineArray += ','
        # $TextInfo.ToTitleCase($param.name)
        $paramLine = $paramLineArray -join ''
        $paramBlock += $paramLine
    }
    ($paramBlock -join "`r`n")
}