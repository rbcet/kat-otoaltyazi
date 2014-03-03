@echo OFF
color 73

:ADMIN-CHECK

	:: BatchGotAdmin
	:-------------------------------------
	REM  --> Check for permissions
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

	REM --> If error flag set, we do not have admin.
	if '%errorlevel%' NEQ '0' (
	    echo Requesting administrative privileges...
	    GOTO DirCheck1
	) else ( GOTO gotAdmin )

	:DirCheck1

		copy /Y NUL "%~dp0\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%~dp0\.writable"
			GOTO UACPrompt1
		 ) else (
			echo Checking profile instead...
			GOTO DirCheck2
		)

	:DirCheck2

		copy /Y NUL "%USERPROFILE%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%USERPROFILE%\.writable"
			GOTO UACPrompt2
		 ) else (
			echo Checking temp instead...
			GOTO DirCheck3
		)

	:DirCheck3

		copy /Y NUL "%tmp%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%tmp%\.writable"
			GOTO UACPrompt3
		 ) else (
			GOTO UACFailed
		)

	:UACPrompt1

		echo Set UAC = CreateObject^("Shell.Application"^) > "%~dp0\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%~dp0\getadmin.vbs"

		"%~dp0\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%~dp0\getadmin.vbs"
			GOTO DirCheck2
		) else ( GOTO UACPrompt1Complete )

		:UACPrompt1Complete
			del "%~dp0\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt2

		echo Set UAC = CreateObject^("Shell.Application"^) > "%USERPROFILE%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%USERPROFILE%\getadmin.vbs"

		"%USERPROFILE%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%USERPROFILE%\getadmin.vbs"
			GOTO DirCheck3
		) else ( GOTO UACPrompt2Complete )

		:UACPrompt2Complete
			del "%USERPROFILE%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt3

		echo Set UAC = CreateObject^("Shell.Application"^) > "%tmp%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%tmp%\getadmin.vbs"

		"%tmp%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%tmp%\getadmin.vbs"
			GOTO UACFailed
		) else ( GOTO UACPrompt3Complete )

		:UACPrompt3Complete
			del "%tmp%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACFailed
		echo Upgrading to admin privliages failed.
		echo Please right click the file and run as administrator.
		echo PAUSE
		GOTO FINISH

	:gotAdmin
		pushd "%CD%"
		CD /D "%~dp0"
	:--------------------------------------

GOTO language

:language
set /p choice=Select Installation Language en or tr==
if '%choice%'=='tr' echo turkish > %TEMP%\tr.nn
if '%choice%'=='en' echo english > %TEMP%\en.nn

if exist "%TEMP%\tr.nn" (
set ilksatir=KURMAK icin 1, CIKMAK icin 2 tuslayin, FILEBOT GUNCELLEMEK icin 3 tuslayin
set yoluyaz=Dizilerinizin bulundugu ana klasoru secin
set kackontrol=Kac dakikada bir kontrol edilecegini yazin
set hangidil=Hangi dil altyazi indirilecegi tr en es it seklinde
set infoilk=# FILEBOT DESTEKLI OTOMATIK ALTYAZI INDIRME SCRIPTI ########
set infoiki=# KATATES PIZARTMASI TARAFINDAN HAZIRLANMISTIR #############
set infouc=# Filebotun en guncel surumunu yuklemeniz sarttir ##########
set infodort=# C:\Program Files\Filebot konumunda kurulu olmalidir ######
set infobes=# Script her X dakikada bir belirlenen klasorde eksik alt ##
set infoalti=# yazi olup olmadigni kontrol eder ve eksik XX altyazilari #
set infoyedi=# Opensubtitles sitesinden filebot yardimiyla indirir ######
set bulunamadi=FileBot bulunamadi,indirilecek? DEVAM ET icin 1, IPTAL icin 2 tuslayin.
set gecerlisecim= gecerli bir secim degil.
set infoscripti=Filebot otomatik altyazi indirme scripti
set subatayi=Subat
set sagindir=Altyazý indir
set sagindirler=Altyazýlarý indir
set simdiindir=Filebot simdi indirilecek...
set indibasla=Indirildi. Kurulum baslatilacak...
set bittiyse=Kurulum tamamlaninca enterlayin
set kurbekle=Kurulumun tamamlanmasi bekleniyor.
set basariyla=Kurulum basariyla tamamlandi
set burayaz=Buraya yazin
set guncelleniyor=Filebot Jar Dosyasi Guncelleniyor.
set jariniyor=Filebot.jar bu konumdan indiriliyor.
set tarih=Tarih
set indibas=Indirme basarili
set silin=siliniyor
set bulamadijar=dosyasi bulunamadi
set dosyax=dosyasi
set adlandiriyo=oldu
set yeni=Yeni
set yukll=yukleniyor
set jartamam=FileBot Guncellemesi tamamlandi
set zatenkuru=Script zaten halihazirda kurulu!
set kaldiracaksan=Kaldirmak istiyorsaniz, 3 tuslayin.
set kaldiriyo= Script kaldiriliyor
set kaldirdik= Script basariyla kaldirildi.
set sagtakip=Klasör takibi
set sagtakipet=Klasörü takip et
set sagtakipbirak=Klasörün takibini býrak
set yenieklemevar=Diziler klasorunuze yeni bir altyazi eklendi!
set eklendibaslik=Klasöre git?
set he=Eklenen altyazýlar;
del %TEMP%\tr.nn
goto :kontrol
) else (
set ilksatir=for INSTALL 1, for EXIT 2, for UPDATING FILEBOT press 3.
set yoluyaz=Choose the folder of your TV Series
set kackontrol=Interval time of checking missing subtitles(min)
set hangidil=Which language would you like to have? (Answer Format en tr es it)
set infoilk=# FULLY AUTOMATED SUBTITLE DOWNLOAD SCRIPT (via FILEBOT) ###
set infoiki=# BROUGHT TO YOU BY KATATES PIZARTMASI #####################
set infouc=# YOU need to have FileBot installed. ######################
set infodort=# Installation folder must be C:\Program Files\Filebot #####
set infobes=# Script checks every X minutes the folder you desired #####
set infoalti=# for missing subtitles and downloads them from ############
set infoyedi=# Opensubtitles via Filebot ################################
set bulunamadi=Filebot is not installed.I will install it.for CONTINUE 1, for CANCEL press 2.
set gecerlisecim= is not a valid choice.
set infoscripti=Fully automated subtitle downloader
set subatayi=February
set sagindir=Download the subtitle
set sagindirler=Download subtitles
set simdiindir=Filebot will be downloaded...
set indibasla= Downloaded. Opening the setup...
set bittiyse= If setup is completed, hit ENTER.
set kurbekle=Waiting for the completion of the setup.
set basariyla=Script installed successfully.
set burayaz=Write here
set guncelleniyor=Updating FileBot.Jar file.
set jariniyor=Filebot.jar is downloading from
set tarih=Date
set indibas=Successfully downloaded.
set silin=is being deleted.
set bulamadijar=could not found.
set dosyax=file
set adlandiriyo=became
set yukll=is being installed
set yeni=New
set jartamam=FileBot update is completed
set zatenkuru=Script is already installed.
set kaldiracaksan=If you want to uninstall,press 3.
set kaldiriyo= Script is being uninstalled
set kaldirdik= Script uninstalled.
set sagtakip=Folder Watch
set sagtakipet=Watch the folder
set sagtakipbirak=Remove the folder watch
set yenieklemevar=New subtitle has added to your TV Series Folder!
set eklendibaslik=Go to Folder?
set he=Added subtitles;
set yok=No, Close the window
del %TEMP%\en.nn
goto :kontrol
)


:kontrol
if exist "C:\Program Files\FileBot\filebot.jar" (
goto :kontrol2
) else (
goto :YOK
)

:kontrol2
if exist "C:\Program Files\FileBot\filebot.platform.launcher.exe" (
goto :kontrol3
) else (
goto :YOK
)

:kontrol3
if exist "C:\Program Files\FileBot\filebot.launcher.exe" (
goto :kontrol4
) else (
goto :YOK
)

:kontrol4
if exist "C:\Program Files\FileBot\OtoAltyazi\sub.vbs" (
goto :YOK2
) else (
goto :start
)

:start
echo (
echo (
echo ############################################################
echo ############################################################
echo %infoilk%
echo %infoiki%
echo ############################################################
echo ############################################################
echo %infouc%
echo %infodort%
echo %infobes%
echo %infoalti%
echo %infoyedi%
echo ############################################################
echo ############################################################
echo (
echo (
ECHO %ilksatir%
set /p choice=%burayaz%==
if '%choice%'=='' ECHO "%choice%" %gecerlisecim%
if '%choice%'=='1' goto EVET
if '%choice%'=='2' goto exit
if '%choice%'=='3' goto GUNCELLE
if '%choice%'=='uninstall' goto KALDIR
ECHO.
goto start


	:klasorsec
    set pathName=
    set vbs="%temp%\_.vbs"
    set cmd="%temp%\_.cmd"
    for %%f in (%vbs% %cmd%) do if exist %%f del %%f
    for %%g in ("vbs cmd") do if defined %%g set %%g=
    >%vbs% echo set WshShell=WScript.CreateObject("WScript.Shell") 
    >>%vbs% echo set shell=WScript.CreateObject("Shell.Application") 
    >>%vbs% echo set f=shell.BrowseForFolder(0,%1,0,%2) 
    >>%vbs% echo if typename(f)="Nothing" Then  
    >>%vbs% echo wscript.echo "exit" 
    >>%vbs% echo WScript.Quit(1)
    >>%vbs% echo end if 
    >>%vbs% echo set fs=f.Items():set fi=fs.Item() 
    >>%vbs% echo p=fi.Path:wscript.echo "set pathName=" ^& p
    cscript //nologo %vbs% > %cmd%
    for /f "delims=" %%a in (%cmd%) do %%a
    for %%f in (%vbs% %cmd%) do if exist %%f del %%f
    for %%g in ("vbs cmd") do if defined %%g set %%g=
    goto :eof

	
:EVET
Call :klasorsec "%yoluyaz%" "C:\diziler\klasorunu\secin"
set /p dakiKa=%kackontrol%:%=%
set /p altdil=%hangidil%:%=%
set yuzde=%%

echo Option Explicit>> eklendi.vbs
echo Const conForReading = ^1>> eklendi.vbs
echo Dim objFSO, objReadFile, objFile, contents, result, shell, WshShell, somestring, txFldr2Open>> eklendi.vbs
echo Set objFSO = CreateObject("Scripting.FileSystemObject")>> eklendi.vbs
echo Set objFile = objFSO.GetFile("C:\Progra~1\FileBot\OtoAltyazi\eklendi.txt") >> eklendi.vbs
echo. >> eklendi.vbs
echo If objFile.Size ^> 0 Then >> eklendi.vbs
echo Set objReadFile = objFSO.OpenTextFile("C:\Progra~1\FileBot\OtoAltyazi\eklendi.txt", 1, False)>> eklendi.vbs
echo contents = objReadFile.ReadAll>> eklendi.vbs
echo result = MsgBox ("%he%" ^& vbCr ^& contents ^& "",vbYesNo+vbExclamation+vbSystemModal,"%eklendibaslik%")>> eklendi.vbs
echo Select Case result>> eklendi.vbs
echo Case vbYes>> eklendi.vbs
echo Set WshShell = WScript.CreateObject("WScript.Shell")>> eklendi.vbs
echo txFldr2Open = "%pathName%">> eklendi.vbs
echo somestring = "EXPLORER.EXE /e," ^& txFldr2Open>> eklendi.vbs
echo WshShell.run somestring>> eklendi.vbs
echo Set WshShell = Nothing>> eklendi.vbs
echo Case vbNo>> eklendi.vbs
echo End Select>> eklendi.vbs
echo objReadFile.close>> eklendi.vbs
echo. >> eklendi.vbs
echo Else >> eklendi.vbs
echo End If  >> eklendi.vbs
echo. >> eklendi.vbs 
echo Set objFSO = Nothing >> eklendi.vbs
echo Set objReadFile = Nothing >> eklendi.vbs
echo WScript.Quit() >> eklendi.vbs

echo. 2> takip_ayari.txt
echo cmd /c filebot -script fn:suball \"PATH_HERE\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO >> takip_ayari.txt

echo @echo off  > sub.bat
echo CD.^>"%pathName%\empty.srt">> sub.bat
echo dir /b /s "%pathName%" ^| findstr /m /i "\.srt$" ^> C:\Progra~1\FileBot\OtoAltyazi\eski.txt  >> sub.bat
echo CD.^>C:\Progra~1\FileBot\OtoAltyazi\yeni.txt  >> sub.bat
echo. >> sub.bat
echo filebot -script fn:suball "%pathName%" -non-strict --lang tr --log-file context.log --encoding utf8 --format MATCH_VIDEO >> sub.bat
echo. >> sub.bat
echo dir /b /s "%pathName%" ^| findstr /m /i "\.srt$" ^> C:\Progra~1\FileBot\OtoAltyazi\yeni.txt  >> sub.bat
echo fc /b C:\Progra~1\FileBot\OtoAltyazi\eski.txt C:\Progra~1\FileBot\OtoAltyazi\yeni.txt^|find /i "no differences"^>nul >> sub.bat
echo if errorlevel 1 goto farkli  >> sub.bat
echo if not errorlevel 1 goto olustur >> sub.bat
echo. >> sub.bat
echo :farkli  >> sub.bat
echo set dosya1="C:\Progra~1\FileBot\OtoAltyazi\eski.txt" >> sub.bat
echo set dosya2="C:\Progra~1\FileBot\OtoAltyazi\yeni.txt" >> sub.bat
echo. >> sub.bat
echo for /f "delims=" %yuzde%%yuzde%a in ('findstr /G:%%dosya1%% /I /L /B /V %%dosya2%%') do (@echo %yuzde%%yuzde%~nxa ^>^> C:\Progra~1\FileBot\OtoAltyazi\eklendi.txt)  >> sub.bat
echo. >> sub.bat
echo ping 192.0.2.2 -n 1 -w 4000 > nul >> sub.bat
echo goto olustur >> sub.bat
echo. >> sub.bat
echo :olustur >> sub.bat
echo start "" wscript "C:\Progra~1\FileBot\OtoAltyazi\eklendi.vbs" >> sub.bat
echo ping 192.0.2.2 -n 1 -w 4000 ^> nul >> sub.bat
echo dir /b /s "%pathName%" ^| findstr /m /i "\.srt$" ^> C:\Progra~1\FileBot\OtoAltyazi\eski.txt >> sub.bat
echo goto cik  >> sub.bat
echo. >> sub.bat
echo :cik >> sub.bat
echo ATTRIB -R -S -H "C:\Progra~1\FileBot\OtoAltyazi\eklendi.txt" >> sub.bat
echo CD.^>C:\Progra~1\FileBot\OtoAltyazi\eklendi.txt  >> sub.bat
echo del "%pathName%\empty.srt">> sub.bat
echo exit >> sub.bat

echo Set objShell = CreateObject("Shell.Application") > sub.vbs
echo objShell.ShellExecute "C:\Program Files\FileBot\OtoAltyazi\sub.bat", "", "", "runas", 0 >> sub.vbs

echo Katates PIZARTMASI > Info.txt
echo twitter.com/RBCetin - bit.ly/katatesp >> Info.txt
echo Thanks to Ithiel (CapriciousSage) >> Info.txt
echo %infoscripti% >> Info.txt
echo %subatayi% 2014 >> Info.txt

mkdir "C:\Program Files\FileBot\OtoAltyazi"
copy takip_ayari.txt "C:\Program Files\FileBot\OtoAltyazi"
copy sub.vbs "C:\Program Files\FileBot\OtoAltyazi"
copy sub.bat "C:\Program Files\FileBot\OtoAltyazi"
copy eklendi.vbs "C:\Program Files\FileBot\OtoAltyazi"
copy info.txt "C:\Program Files\FileBot\OtoAltyazi"

DEL eklendi.vbs
DEL takip_ayari.txt
DEL sub.vbs
DEL sub.bat
DEL info.txt

schtasks /create /sc minute /mo %dakiKa% /tn "ALTYAZI" /tr "%%ProgramW6432%%\FileBot\OtoAltyazi\sub.vbs"

If exist "%Temp%\~import.reg" (
 Attrib -R -S -H "%Temp%\~import.reg"
 del /F /Q "%Temp%\~import.reg"
 If exist "%Temp%\~import.reg" (
  Echo Could not delete file "%Temp%\~import.reg"
  Pause
 )
)
> "%Temp%\~import.reg" ECHO Windows Registry Editor Version 5.00
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\Shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\Shell\%sagindir%]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\Shell\%sagindir%\Command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c  filebot.launcher -get-subtitles \"%%1\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\Shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\Shell\%sagindir%]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\Shell\%sagindir%\Command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c  filebot.launcher -get-subtitles \"%%1\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.avi]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.avi\Shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.avi\Shell\%sagindir%]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.avi\Shell\%sagindir%\Command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c  filebot.launcher -get-subtitles \"%%1\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\01Altyazýlarý indir]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagindirler%"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\01Altyazýlarý indir\command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c filebot.launcher -script fn:suball \"%%1\" -non-strict --lang %altdil% --log-file context.log --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\02Takip]
>> "%Temp%\~import.reg" ECHO "ExtendedSubCommandsKey"="Folder\\\\shell\\\\02Takip"
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagtakip%"
>> "%Temp%\~import.reg" ECHO "icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\1Takip Et]
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagtakipet%"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\1Takip Et\command]
>> "%Temp%\~import.reg" ECHO @="cmd /c call \"C:\\Program Files\\FileBot\\OtoAltyazi\\takip_et.cmd\" \"%%1\" \"setmatch\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\2Takibi Kaldýr]
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagtakipbirak%"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\2Takibi Kaldýr\command]
>> "%Temp%\~import.reg" ECHO @="cmd /c call \"C:\\Program Files\\FileBot\\OtoAltyazi\\takip_et.cmd\" \"%%1\" \"removetask\""
START /WAIT REGEDIT /S "%Temp%\~import.reg"
DEL "%Temp%\~import.reg"

DEL /Q "%tmp%\_.cmd"
DEL /Q "%tmp%\_.vbs"

bitsadmin.exe /transfer "Klasor_Takip_CMD" /priority foreground  "https://github.com/katates/otoaltyazi/raw/master/files/takip.cmd" "C:\Program Files\FileBot\OtoAltyazi\takip.cmd"
bitsadmin.exe /transfer "Klasor_Takip_CMD2" /priority foreground  "https://github.com/katates/otoaltyazi/raw/master/files/takip_et.cmd" "C:\Program Files\FileBot\OtoAltyazi\takip_et.cmd"
bitsadmin.exe /transfer "Klasor_Takip_VBS" /priority foreground  "https://github.com/katates/otoaltyazi/raw/master/files/takip.vbs" "C:\Program Files\FileBot\OtoAltyazi\takip.vbs"


ECHO %basariyla%

goto end

	
:YOK
echo (
echo (
echo ############################################################
echo ############################################################
echo %infoilk%
echo %infoiki%
echo ############################################################
echo ############################################################
echo %infouc%
echo %infodort%
echo %infobes%
echo %infoalti%
echo %infoyedi%
echo ############################################################
echo ############################################################
echo (
ECHO )
ECHO %bulunamadi%
set /p choice=%burayaz%==
if '%choice%'=='' ECHO "%choice%" %gecerlisecim%
if '%choice%'=='1' goto INDIR
if '%choice%'=='2' goto exit
if '%choice%'=='uninstall' goto KALDIR
ECHO.
goto YOK

:INDIR
ECHO )
ECHO %simdiindir%
bitsadmin.exe /transfer "Filebot_indir" /priority foreground "http://netcologne.dl.sourceforge.net/project/filebot/filebot/HEAD/FileBot-setup.exe" "%Temp%\FileBot-setup.exe"
ECHO %indibasla%
start %Temp%\FileBot-Setup.exe
set /p choice=%bittiyse%==
if '%choice%'=='' goto kurdumu
ECHO.
goto kurdumu

:kurdumu
if exist "C:\Program Files\FileBot\filebot.jar" (
goto :GUNCELLE
) else (
ECHO %kurbekle%
set /p choice=%bittiyse%==
if '%choice%'=='' goto kurdumu
)
goto kurdumu


:GUNCELLE

	echo ---------------------------
	echo %guncelleniyor%
	echo Tarih: %date%
	echo ---------------------------
	echo.

	echo %jariniyor% %downloadURL%
	bitsadmin.exe /transfer "FileBot_Guncelle" /priority foreground "http://sourceforge.net/projects/filebot/files/filebot/HEAD/FileBot.jar" "%tmp%\FileBot.jar"

	if not errorlevel 0 GOTO end
	
	echo %indibas%

	IF EXIST "C:\Program Files\FileBot\FileBot_old.jar" (
		echo "C:\Program Files\FileBot\FileBot_old.jar" %silin%
		del "C:\Program Files\FileBot\FileBot_old.jar"
	) ELSE (
		echo FileBot_old.jar %bulamadijar%
	)

	echo FileBot.jar %dosyax% %adlandiriyo% FileBot_old.jar
	ren "C:\Program Files\FileBot\FileBot.jar" FileBot_old.jar

	echo %yeni% FileBot.jar %dosyax% %yukll%
	move "%tmp%\FileBot.jar" "C:\Program Files\FileBot\FileBot.jar"
	
	echo %jartamam%

GOTO kontrol4


:YOK2
echo (
echo (
echo ############################################################
echo ############################################################
echo %infoilk%
echo %infoiki%
echo ############################################################
echo ############################################################
echo %infouc%
echo %infodort%
echo %infobes%
echo %infoalti%
echo %infoyedi%
echo ############################################################
echo ############################################################
echo (
echo (
ECHO %zatenkuru%
ECHO %kaldiracaksan%
set /p choice=%burayaz%==
if '%choice%'=='' ECHO "%choice%" %gecerlisecim%
if '%choice%'=='3' goto KALDIR
ECHO.
goto YOK2


:KALDIR
ECHO ) %kaldiriyo%

@ECHO OFF
If exist "%Temp%\~import.reg" (
 Attrib -R -S -H "%Temp%\~import.reg"
 del /F /Q "%Temp%\~import.reg"
 If exist "%Temp%\~import.reg" (
  Echo Could not delete file "%Temp%\~import.reg"
  Pause
 )
)
> "%Temp%\~import.reg" ECHO Windows Registry Editor Version 5.00
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\Shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\Shell\%sagindir%]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\SystemFileAssociations\.mkv\Shell\%sagindir%\Command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c  filebot.launcher -get-subtitles \"%%1\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\Shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\Shell\%sagindir%]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\SystemFileAssociations\.mp4\Shell\%sagindir%\Command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c  filebot.launcher -get-subtitles \"%%1\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.avi]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [HKEY_CLASSES_ROOT\SystemFileAssociations\.avi\Shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\SystemFileAssociations\.avi\Shell\%sagindir%]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\SystemFileAssociations\.avi\Shell\%sagindir%\Command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c  filebot.launcher -get-subtitles \"%%1\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\01Altyazýlarý indir]
>> "%Temp%\~import.reg" ECHO "Icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagindirler%"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\01Altyazýlarý indir\command]
>> "%Temp%\~import.reg" ECHO @="cmd /q /c filebot.launcher -script fn:suball \"%%1\" -non-strict --lang %altdil% --log-file context.log --format MATCH_VIDEO"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\02Takip]
>> "%Temp%\~import.reg" ECHO "ExtendedSubCommandsKey"="Folder\\\\shell\\\\02Takip"
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagtakip%"
>> "%Temp%\~import.reg" ECHO "icon"="\"C:\\Program Files\\FileBot\\filebot.exe\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell]
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\1Takip Et]
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagtakipet%"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\1Takip Et\command]
>> "%Temp%\~import.reg" ECHO @="cmd /c call \"C:\\Program Files\\FileBot\\OtoAltyazi\\takip_et.cmd\" \"%%1\" \"setmatch\""
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\2Takibi Kaldýr]
>> "%Temp%\~import.reg" ECHO "MUIVerb"="%sagtakipbirak%"
>> "%Temp%\~import.reg" ECHO.
>> "%Temp%\~import.reg" ECHO [-HKEY_CLASSES_ROOT\Folder\shell\02Takip\shell\2Takibi Kaldýr\command]
>> "%Temp%\~import.reg" ECHO @="cmd /c call \"C:\\Program Files\\FileBot\\OtoAltyazi\\takip_et.cmd\" \"%%1\" \"removetask\""
START /WAIT REGEDIT /S "%Temp%\~import.reg"
DEL "%Temp%\~import.reg"


SCHTASKS /Delete /TN "ALTYAZI" /f

echo y | wmic product where name="FileBot" call uninstall

set "watchlist=C:\Progra~1\FileBot\OtoAltyazi\gorev_listesi.txt"
for /f "delims=" %%a in (%watchlist%) do schtasks /delete /tn "%%a" /f 

DEL /Q "%watchlist%"
RD /S /Q "C:\Program Files\FileBot\OtoAltyazi\"
RD /S /Q "C:\Program Files\FileBot\"

DEL /Q "%tmp%\FileBot-setup.exe"


ECHO ) %kaldirdik%


goto end


:end
pause

:exit
exit