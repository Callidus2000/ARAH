function Add-ARAHStringIntend {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]$Text,
        [Parameter(Mandatory=$true)]
        [int]$Intend
    )

    begin {
        $returnStrings=@()
    }

    process {
        $newText = $Text -replace '(?m)^', (' ' * $Intend)
        Write-PSFMessage "Text=$Text"
        Write-PSFMessage "newText=$newText"
        # $returnStrings += $newText # -replace '(?m)^', (' ' * $Intend)
        $returnStrings += $Text # -replace '(?m)^', (' ' * $Intend)
    }

    end {
        # Write-PSFMessage "returnStrings=$returnStrings"
        # $returnStrings #-replace '(?m)^', (' ' * $Intend)
        $returnStrings -replace '(?m)^', (' ' * $Intend)
    }
}