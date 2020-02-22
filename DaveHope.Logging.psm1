Function Get-LoggingPath
{
	[cmdletbinding()]
	<#
	.SYNOPSIS
	Gets the path to the file at the top of the call stack and uses it to build
	a full path to the directory in which logs should be stored.
	#>
	$CallStack = @(Get-PSCallStack) | Select-Object -Property *
	if($null -ne $CallStack[-1].ScriptName)
	{
		$logBaseDir = Split-Path ($CallStack[-1].ScriptName) -Parent
		$logChildDir = [system.io.path]::GetFilenameWithoutExtension((Split-Path ($CallStack[-1].ScriptName) -Leaf))
	}
	else
	{
		$scriptPath = ($CallStack |Where-Object{$null -ne $_.ScriptName} | Select-Object -Last 1)[0].ScriptName
		$logBaseDir = Split-Path $scriptPath -Parent
		$logChildDir = [system.io.path]::GetFilenameWithoutExtension($scriptPath)
	}

	$res = $logBaseDir + [IO.Path]::DirectorySeparatorChar `
		+ "Logs" + [IO.Path]::DirectorySeparatorChar `
		+ $logChildDir + [IO.Path]::DirectorySeparatorChar

	Write-Verbose "Logging will write to $res"
	$res
}


Function Write-LogMessage
{
	<#
	.SYNOPSIS
	Appends a line to a log file, creates the directory structure required if it
	does not already exist.

	.PARAMETER msg
	The message to be written to the log file

	.PARAMETER Directory
	The directory in which to place log files. Messages will be written to a file
	based on the date/time of the first log message for this execution. If not
	set, this will be determined automatically based on the location of the
	calling script

	.PARAMETER exception
	If an exception is passed, in addition to the message passed a friendly
	representation of the exception will be included in the log message.

	.PARAMETER quiet
	If the quiet parameter is used, the message will be echoed as verbose rather
	than as normal output.
	#>
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$true,Position=0)][string]$msg,
		[Parameter()][string]$Directory,
		[Parameter()][System.Exception]$exception,
		[Parameter()][bool]$quiet=$true
	)

	$dateTime = [string] (get-date -format yyyy.MM.dd-HHmm)

	# Establish the path we will log to. If a global variable exists this will
	# be used so that subsequent calls during execution don't go to a different
	# file.
	if($null -eq $script:DaveHopeLoggingPath)
	{
		if(-not $Directory)
		{
			$Directory = Get-LoggingPath
		}
		else
		{
			if(-not $Directory.EndsWith([IO.Path]::DirectorySeparatorChar))
			{
				$Directory += [IO.Path]::DirectorySeparatorChar
			}
		}
		$logPath = $Directory + "$($dateTime).txt"
		$script:DaveHopeLoggingPath = $logPath
	}
	else
	{
		$logPath = $script:DaveHopeLoggingPath
	}

	# Check that our log path exists, including all sub-directories.
	$dir = Split-Path $logPath
	if(-not (Test-Path $dir))
	{
		New-item $dir -ItemType Directory | Out-Null
	}
	if(-not (Test-Path $logPath))
	{
		New-item $logPath -ItemType File | Out-Null
	}

	$logMsg = "[$dateTime] $msg"
	# If an exception has been given, dump that too.
	if($null -ne $exception)
	{
		$logMsg += "`r`n" +
			"`tCaught an exception:`r`n" +
			"`tException Type: $($exception.GetType().FullName)`r`n" +
			"`tException Message: $($exception.Message)"
	}

	# Actually write the log entry.
	Add-Content $logPath $logMsg
	if($quiet)
	{
		Write-Verbose $logMsg
	}
	else
	{
		Write-Output $logMsg
	}
}