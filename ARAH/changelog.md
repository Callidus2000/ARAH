# Changelog

## 1.5.1 (2025-04-29)
- Fixed HTTP version from `1.1.0` to `1.1` as PowerShell 7.5 complains otherwise.
- Headers are now cloned.

## 1.5.0 (2025-04-29)
- Changed RequestModifier execution.
- Added ability to add headers to a request.
- Support for newer HTTP versions added.

## 1.3.8 (2023-09-08)
- Depth parameter added to `ConvertTo-Json`.
- Added parameter help for `OutFile`.
- If the result is JSON, you can enable converting it to a HashTable with the `Invoke-ARAHRequest -ConvertJsonAsHashtable` switch. This is needed in case of the error `Cannot convert the JSON string because it contains keys with different casing. Please use the -AsHashTable switch instead.`
- File downloads can now be handled.

## 1.3.6 (2023-03-03)
- If using a HashTable object for the `Invoke-ARAHRequest -Body` parameter, it is only converted to JSON if the content type matches `json`.

## 1.3.5 (2023-01-18)
- Added `SkipCheck` parameter/property to the `ARAHConnection` class and `Invoke-ARAHRequest`. This allows skipping SSL checks while performing HTTP requests.

## 1.3.4
- Added configurable depth for `ConvertTo-Json` calls.
- Added `-WarningAction SilentlyContinue` to all `ConvertTo-Json` calls.

## 1.1.0 (2021-02-26)
- New: Automatic generation of functions based on Swagger specs.

## 1.0.0 (2021-02-22)
- Initial release of the module.