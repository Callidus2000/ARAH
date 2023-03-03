# Changelog
## 1.3.6 (2023-03-03)
 - If using a HashTable object for the `Invoke-ARAHRequest -Body` parameter it is only converted to json if the content type matches `json`.
## 1.3.5 (2023-01-18)
 - Added Parameter/Property SkipCheck to the ARAHConnection class and to Invoke-ARAHRequest  
   Allows e.g. to skip SSL checks while performing the HTTP requests
## 1.1.0 (2021-02-26)
 - New: automatic generation of functions based on swagger specs
## 1.0.0 (2021-02-22)
 - New: Module