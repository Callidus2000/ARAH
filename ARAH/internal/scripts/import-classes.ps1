# Import all internal classes
foreach ($class in (Get-ChildItem "$ModuleRoot\internal\classes" -Filter "*.ps1" -Recurse -ErrorAction Ignore)){
    . Import-ModuleFile -Path $class.FullName
}
