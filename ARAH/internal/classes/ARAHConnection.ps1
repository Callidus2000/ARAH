class ARAHConnection {

    # properties
    hidden[System.Collections.Hashtable]$Headers
    [String]$ServerRoot
    [String]$WebServiceRoot
    [String]$AuthenticatedUser
    hidden[PSCredential]$Credential
    hidden[String]$ContentType
    hidden[Microsoft.PowerShell.Commands.WebRequestSession]$WebSession

    # constructors
    ARAHConnection () {
        $this.Headers = @{}
        $this.WebSession=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
    }
    ARAHConnection ([String]$Url,[String]$APISubPath) {
        $this.Headers = @{}
        $this.WebSession=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
        Write-PSFMessage "Getting ARAH Server-Root for $Url, APISubPath=$APISubPath" -ModuleName ARAH -FunctionName "ARAHConnection[xx,xx]"
        if (!$APISubPath){
            $APISubPath=""
        }
        # Strip prefix /
        $APISubPath = $APISubPath.TrimStart("/")
        # Strip leading /
        $this.ServerRoot = $Url.Trim("/")
        # Strip Prefix protocoll
        $this.ServerRoot = $this.ServerRoot -replace "^.*:\/\/"
        $this.ServerRoot = "https://$($this.ServerRoot)"
        Write-PSFMessage "Result: $this.ServerRoot" -ModuleName ARAH -FunctionName "ARAHConnection[xx,xx]"

        $this.WebServiceRoot = ("$($this.ServerRoot)/$($APISubPath)").Trim("/")
    }

}
Export-PSFModuleClass -ClassType ([ARAHConnection])