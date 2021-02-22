Describe  "Base-Object-Initialisation" {
    Context "ARAH-Only" {
        It "Check with APISubPath" {
            (Get-ARAHConnection -Url "my.server.de" -APISubPath "/api/v4").WebServiceRoot | Should -Be "https://my.server.de/api/v4"
            (Get-ARAHConnection -Url "http://my.server.de" -APISubPath "/api/v4").WebServiceRoot | Should -Be "https://my.server.de/api/v4"
            (Get-ARAHConnection -Url "http://my.server.de/" -APISubPath "/api/v4").WebServiceRoot | Should -Be "https://my.server.de/api/v4"
            (Get-ARAHConnection -Url "my.server.de/" -APISubPath "/api/v4").WebServiceRoot | Should -Be "https://my.server.de/api/v4"

            (Get-ARAHConnection -Url "my.server.de/" -APISubPath "api/v4").WebServiceRoot | Should -Be "https://my.server.de/api/v4"
            (Get-ARAHConnection -Url "my.server.de/" -APISubPath "api/v4/").WebServiceRoot | Should -Be "https://my.server.de/api/v4"
            (Get-ARAHConnection -Url "my.server.de/" -APISubPath "/api/v4/").WebServiceRoot | Should -Be "https://my.server.de/api/v4"
        }
        It "Check without APISubPath" {
            (Get-ARAHConnection -Url "my.server.de/" -APISubPath "/").WebServiceRoot | Should -Be "https://my.server.de"
            (Get-ARAHConnection -Url "my.server.de/" -APISubPath $null).WebServiceRoot | Should -Be "https://my.server.de"
            (Get-ARAHConnection -Url "my.server.de/" -APISubPath "").WebServiceRoot | Should -Be "https://my.server.de"
            (Get-ARAHConnection -Url "my.server.de/" ).WebServiceRoot | Should -Be "https://my.server.de"
        }
    }
}