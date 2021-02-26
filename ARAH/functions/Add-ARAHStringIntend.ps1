function Add-ARAHStringIntend {
    <#
    .SYNOPSIS
    Intend a provided text with spaces.

    .DESCRIPTION
    Helper Function for Swagger Function Generation.
    Intend a provided text with spaces.

    .PARAMETER Text
    The original text.

    .PARAMETER Intend
    How many spaces should be used for intendation?

    .EXAMPLE
    "An example" | Add-ARAHStringIntend -Intend 4

    Returns "    An example"

    .NOTES
    General notes
    #>
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
        $returnStrings += $Text
    }

    end {
        $returnStrings -replace '(?m)^', (' ' * $Intend)
    }
}