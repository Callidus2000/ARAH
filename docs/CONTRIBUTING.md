# Contributing to this repository

No need for duplicating basic KnowHow about contributing, I think that everything is [well documented by github ;-)](https://github.com/github/docs/blob/main/CONTRIBUTING.md).

A big welcome and thank you for considering contributing to this repository! Besides the named basics getting an overview of the internal logic is quite helpful if you want to contribute. Let's get started..

## Missing a functionality?

If you are missing a function in this module:
* Take a look at [Working with the layout](#working-with-the-layout)
* Add a new public function under `\ARAH\functions`
  * One function per file
  * Filename relates to the function name
  * Add the function to `\ARAH\ARAH.psd1` under `FunctionsToExport`
* Make use of [API Proxy Invoke-ARAHRequest](#api-proxy-Invoke-ARAHRequest) to access the API - it takes the stress out of coping with default problem
* Add new [Pester tests](#pester-tests) for the new function

### Working with the layout
This module was created with the help of [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and follows the default folder layout. Therefor the default rules apply:
- Don't touch the psm1 file
- Place functions you export in `functions/` (can have subfolders)
- Place private/internal functions invisible to the user in `internal/functions` (can have subfolders)
- Don't add code directly to the `postimport.ps1` or `preimport.ps1`.
  Those files are designed to import other files only.
- When adding files & folders, make sure they are covered by either `postimport.ps1` or `preimport.ps1`.
  This adds them to both the import and the build sequence.

## API Proxy Invoke-ARAHRequest

If you take a look at (most) public functions you will recognize the use of `Invoke-ARAHRequest`. This is a generic access function for any Gitea API.

### Why not use Invoke-RestMethod/Invoke-WebRequest?

Of course it would be possible to use the native Invoke-RestMethod or Invoke-WebRequest, and this is done. But only within `Invoke-ARAHRequest` as it is a wrapper for `Invoke-RestMethod`.

Every API call basically performs at least the following steps:
* Build the URI to access, including necessary URI parameters
* Build the headers (e.g. for authentication)
* Build the JSON body
* `Invoke-RestMethod`
* handle exceptions
* Return the response

That's the quick and easy way for getting started. But for robust code there is more:
* Filter `$null` values from the parameters
* Exception handling
  * Does the API throw an exception? Get the details to the logging and rethrow it or not, depending on the current workflow
* Paging (to be implemented based on the actual API)
  * Many APIs work with `limit` and `page` parameters to request only partial information.
  * This is good for performance in user driven apps like the webUI
  * In scripts you perform mass operations in most cases
  * `Invoke-RestMethod` can get all data pages and return all of the data

Just take a look at existing functions, it's hopefully self explaining. Otherwise raise an issue for asking about details.

## Pester tests
The module does use pester for general and functional tests. The general tests are provided by [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and perform checks like *"is the help well written and complete"*.

If you create a new function please provide a corresponding pester test within the `\ARAH\tests\functions` directory. A pester tests should
* Setup the test environment in a clean state, e.g.
  * Create a new pester Organization
* Teardown/remove the test environment as a last step, e.g.
  * Delete created Organization

If you have only created a Getter function without the corresponding Create/Remove counterparts you will not be able to perform this clean testing. If this happens please either provide the additional functions or [create an issue](https://github.com/Callidus2000/ARAH/issues) at the GitHub project page.


## Limitations
* Not everything is being tested with [Pester tests](#pester-tests) - Feel free to add them for existing functions
