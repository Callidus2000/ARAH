class ARAHConnection {

    # properties
    hidden[System.Collections.Hashtable]$Headers
    [String]$ServerRoot
    [String]$WebServiceRoot
    [String]$AuthenticatedUser
    [version]$HttpVersion="1.1"
    hidden[PSCredential]$Credential
    hidden[String]$ContentType
    hidden[Microsoft.PowerShell.Commands.WebRequestSession]$WebSession

    # attribute which, if $true, causes the response which does not specify a charset, even though one is
    # is used, will be converted with the charset.
    [Bool]$OverrideResultEncoding=$false
    [System.Text.Encoding]$Charset = [System.Text.Encoding]::UTF8

    # Should Invoke-WebRequest Skip some checks?
    [ValidateSet('CertificateCheck', 'HttpErrorCheck', 'HeaderValidation')]
    [String[]]$SkipCheck=@()

    # constructors
    ARAHConnection () {
        $this.Headers = @{}
        $this.WebSession=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
        $this.ContentType = "application/json;charset=UTF-8"
    }
    ARAHConnection ([String]$Url,[String]$APISubPath) {
        $this.Headers = @{}
        $this.WebSession=[Microsoft.PowerShell.Commands.WebRequestSession]::new()
        $this.ContentType = "application/json;charset=UTF-8"
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