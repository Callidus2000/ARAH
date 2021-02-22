﻿function Connect-ARAH
{
<#
	.SYNOPSIS
		Configures the connection to the ARAH Azure Function.
	
	.DESCRIPTION
		Configures the connection to the ARAH Azure Function.
	
	.PARAMETER Uri
		Url to connect to the ARAH Azure function.
	
	.PARAMETER UnprotectedToken
		The unencrypted access token to the ARAH Azure function. ONLY use this from secure locations or non-sensitive functions!
	
	.PARAMETER ProtectedToken
		An encrypted access token to the ARAH Azure function. Use this to persist an access token in a way only the current user on the current system can access.
	
	.PARAMETER Register
		Using this command, the module will remember the connection settings persistently across PowerShell sessions.
		CAUTION: When using unencrypted token data (such as specified through the -UnprotectedToken parameter), the authenticating token will be stored in clear-text!
	
	.EXAMPLE
		PS C:\> Connect-ARAH -Uri 'https://demofunctionapp.azurewebsites.net/api/'
	
		Establishes a connection to ARAH
#>
	[CmdletBinding()]
	param (
		[string]
		$Uri,
		
		[string]
		$UnprotectedToken,
		
		[System.Management.Automation.PSCredential]
		$ProtectedToken,
		
		[switch]
		$Register
	)
	
	process
	{
		if (Test-PSFParameterBinding -ParameterName UnprotectedToken)
		{
			Set-PSFConfig -Module 'ARAH' -Name 'Client.UnprotectedToken' -Value $UnprotectedToken
			if ($Register) { Register-PSFConfig -Module 'ARAH' -Name 'Client.UnprotectedToken' }
		}
		if (Test-PSFParameterBinding -ParameterName Uri)
		{
			Set-PSFConfig -Module 'ARAH' -Name 'Client.Uri' -Value $Uri
			if ($Register) { Register-PSFConfig -Module 'ARAH' -Name 'Client.Uri' }
		}
		if (Test-PSFParameterBinding -ParameterName ProtectedToken)
		{
			Set-PSFConfig -Module 'ARAH' -Name 'Client.ProtectedToken' -Value $ProtectedToken
			if ($Register) { Register-PSFConfig -Module 'ARAH' -Name 'Client.ProtectedToken' }
		}
		
	}
}