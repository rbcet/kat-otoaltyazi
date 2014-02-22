@echo OFF
:SETUP
	set watchsettings="C:\Program Files\FileBot\OtoAltyazi\takip_ayari.txt"
GOTO DetermineJobType

:DetermineJobType
	:: determine if adding or removing a task

	set var1=%1
	set var1=%var1:"=%

	set var2=%2
	set var2=%var2:"=%

	set var3=%var1:\=-%
	set var3=%var3::=%

	if "%var2%"=="setnonmatch" (
		goto ScheduleNonMatch
	) ELSE ( 
		if "%var2%"=="setmatch" (
			goto ScheduleMatch
		) ELSE (
			GOTO ERR1
			)
		)
	)

GOTO ERR1

:ScheduleMatch
	set currentParameter=%1
	
	set /p match=<%watchsettings%
	call set match=%%match:PATH_HERE=%var1%%%
	call set match=%match:~0,-1%

	powershell %match%; 
	if exist "%1\*.srt" (
	msg * %1 icin altyazi bulundu!
	) else (
	goto FINISH
	)

	exit

	if not errorlevel 0 GOTO ERR1

GOTO FINISH


:ERR1
	echo **** Warning: Something Didn't Work. Please Confirm Settings ****
	pause>nul
GOTO FINISH


:FINISH
EXIT /B