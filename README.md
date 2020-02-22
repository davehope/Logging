# DaveHope.Logging
A Powershell module to quickly create log files without needing to do any setup
other than importing this module. Targets PowerShell 4.0 and later (supporting
 Windows Server 2012R2 and later).


## Usage

Import the module
```
Import-Module DaveHope.Logging or require it explicitly:
#Requires -Module @{ ModuleName="DaveHope.Logging"; ModuleVersion="1.1.1" }
```

Write your log messages:
```
Write-LogMessage "hello world"
```

If you use Write-LogMessage in a script and run it on
"2020-01-01 at 03:00", All messages will be written to a file relative to the
script of "Logs\ScriptName\2020.01.01-0300.txt"

Each message written has the current date/time added to the start of the line in
"[yyyy.MM.dd-HHmm]" format.

By default, messages are just written to the file and not to screen. This can be
overridden with the -quiet parameter.

Should your code handle an exception, you can optionally pass the -exception
parameter and have Write-LogMessage add that to the log file.
