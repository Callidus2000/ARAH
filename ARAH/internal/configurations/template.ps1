﻿Set-PSFConfig -Module 'PSModuleDevelopment' -Name 'Template.Store.ARAH' -Value "$script:ModuleRoot/internal/templates/store" -Initialize -Validation "string" -Description "Path to the templates shipped in ARAH"