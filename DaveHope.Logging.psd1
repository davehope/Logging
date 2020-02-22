@{
    RootModule = 'DaveHope.Logging.psm1'
    ModuleVersion = '1.1.2'
    GUID = 'e2817eb3-69a0-45b0-83a6-f12f3853c480'
    Author = 'Dave Hope'
    Copyright = '(c) 2020 Dave Hope. All Rights Reserved.'
    Description = 'PowerShell module to write log messages with a single call'
    PowerShellVersion = '4.0'
    RequiredModules = @()
    FunctionsToExport = 'Write-LogMessage'
    PrivateData = @{
        PSData = @{
            Tags = @('Logging')
            ProjectUri = 'https://github.com/davehope/Logging'
        }
    }
}