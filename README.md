<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPLv3 License][license-shield]][license-url]


<br />
<p align="center">
<!-- PROJECT LOGO
  <a href="https://github.com/Callidus2000/ARAH">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
-->

  <h3 align="center">ARAH: Advanced REST API Helper</h3>

  <p align="center">
    This Powershell Module is a generic wrapper/helper for REST APIs.
    <br />
    <a href="https://github.com/Callidus2000/ARAH"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Callidus2000/ARAH/issues">Report Bug</a>
    ·
    <a href="https://github.com/Callidus2000/ARAH/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This Powershell Module is a generic wrapper/helper for REST APIs. The code has started in my <a href="https://github.com/Callidus2000/Dracoon">Dracoon project</a>. To use the power of the created helper functions within other API centric modules I've created ARAH.


### Built With

* [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment)
* [psframework](https://github.com/PowershellFrameworkCollective/psframework)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

All prerequisites will be installed automatically.

### Installation

The releases are published in the Powershell Gallery, therefor it is quite simple:
  ```powershell
  Install-Module ARAH -Force -AllowClobber
  ```
The `AllowClobber` option is currently necessary because of an issue in the current PowerShellGet module. Hopefully it will not be needed in the future any more.

<!-- USAGE EXAMPLES -->
## Usage

The module is a wrapper for the REST API. If you want to learn how it works take a look at my [Gitea Wrapper](https://github.com/Callidus2000/PSGitea) or [Dracoon](https://github.com/Callidus2000/Dracoon). If you want to use it for creating your own API wrapper here is the quick roundup of the necessary steps, with links to the corresponding Gitea scripts as this is the simpler module.

### Create your Connection function
Every API Call needs information for authentication and maybe additional headers. All this is stored in an `[ARAHConnection]` object. Create this base-object and add the necessary information to it:
```powershell
$connection = Get-ARAHConnection -Url $Url -APISubPath "/api"
$connection.ContentType = "application/json;charset=UTF-8"
```
##### Example Source [Connect-Gitea.ps1](https://github.com/Callidus2000/PSGitea/blob/master/Gitea/functions/Connect-Gitea.ps1)
This object should be passed to every API function you specify.

### Create your API Functions
This module provides the `Invoke-ARAHRequest` function for invoking API endpoints on a parameter base. All you have to do to access an API function is to tell it where what information is needed. For example accessing the [Gitea API](https://try.gitea.io/api/swagger) for "Get All Organizations"
```powershell
$apiCallParameter = @{
    Connection   = $Connection
    method       = "Get"
    Path         = "/v1/orgs"
}

Invoke-ARAHRequest @apiCallParameter
```
##### Example Source [Get-GiteaOrganisation.ps1](https://github.com/Callidus2000/PSGitea/blob/master/Gitea/functions/Get-GiteaOrganisation.ps1)
This takes away all the clobber of checking parameters for `$null` values and furthermore.
### Important: AutoCreation available!
Since v1.1.0 it is possible to create API functions based on an existing Swagger Spec. Until documented in detail take a look a the integrated help:
```powershell
Get-Help New-ARAHSwaggerFunction
```

### Optional Step: Create your own Invoke-* Proxy
If you have got the need to extend the functionality of `Invoke-ARAHRequest` (e.g. modifying the request before it is sent) you can create your own proxy function with defined endpoints. For example the [Invoke-GiteaAPI](https://github.com/Callidus2000/PSGitea/blob/master/Gitea/functions/Invoke-GiteaAPI.ps1) uses the same base technique as Invoke-ARAHRequest but enables Paging of provided data with the help of a predefined ScriptBlock.
```powershell
function Invoke-GiteaAPI {
    param (
        [parameter(Mandatory)]
        $Connection,
        #.... example shortened
    )
    return Invoke-ARAHRequest @PSBoundParameters -PagingHandler 'Gitea.PagingHandler'
}
```
##### Example Source [Invoke-GiteaAPI](https://github.com/Callidus2000/PSGitea/blob/master/Gitea/functions/Invoke-GiteaAPI.ps1)
The code for the PagingHandler is defined in `\Gitea\internal\scriptblocks\Gitea-PagingHandler.ps1` and performs all the nasty `page/limit` work. As a result every `Invoke-GiteaAPI` call can return all results not regarding how large the default limit is set.

<!-- ROADMAP -->
## Roadmap
New features will be added if any of my scripts need it ;-)

See the [open issues](https://github.com/Callidus2000/ARAH/issues) for a list of proposed features (and known issues).

If you need a special function feel free to contribute to the project.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**. For more details please take a look at the [CONTRIBUTE](docs/CONTRIBUTING.md#Contributing-to-this-repository) document

Short stop:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the GNU GENERAL PUBLIC LICENSE version 3. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact


Project Link: [https://github.com/Callidus2000/ARAH](https://github.com/Callidus2000/ARAH)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [Friedrich Weinmann](https://github.com/FriedrichWeinmann) for his marvelous [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and [psframework](https://github.com/PowershellFrameworkCollective/psframework)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Callidus2000/ARAH.svg?style=for-the-badge
[contributors-url]: https://github.com/Callidus2000/ARAH/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Callidus2000/ARAH.svg?style=for-the-badge
[forks-url]: https://github.com/Callidus2000/ARAH/network/members
[stars-shield]: https://img.shields.io/github/stars/Callidus2000/ARAH.svg?style=for-the-badge
[stars-url]: https://github.com/Callidus2000/ARAH/stargazers
[issues-shield]: https://img.shields.io/github/issues/Callidus2000/ARAH.svg?style=for-the-badge
[issues-url]: https://github.com/Callidus2000/ARAH/issues
[license-shield]: https://img.shields.io/github/license/Callidus2000/ARAH.svg?style=for-the-badge
[license-url]: https://github.com/Callidus2000/ARAH/blob/master/LICENSE

