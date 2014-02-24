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
set yoluyaz=Dizilerinizin bulundugu ana klasoru yazin
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
del %TEMP%\tr.nn
goto :kontrol
) else (
set ilksatir=for INSTALL 1, for EXIT 2, for UPDATING FILEBOT press 3.
set yoluyaz=Write the path of your TV Series
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



:EVET

set /p pathName=%yoluyaz%:%=%
set /p dakiKa=%kackontrol%:%=%
set /p altdil=%hangidil%:%=%

echo @echo off  >> kontrol.bat
echo. >> kontrol.bat
echo echo. 2^> C:\Progra~1\FileBot\OtoAltyazi\yeni.txt >> kontrol.bat
echo. >> kontrol.bat 
echo if exist "C:\Progra~1\FileBot\OtoAltyazi\eski.txt" (  >> kontrol.bat
echo goto :karsilastir  >> kontrol.bat
echo ) else (  >> kontrol.bat
echo dir /b /s "%pathName%"  ^| findstr /m /i "\.srt$" ^> C:\Progra~1\FileBot\OtoAltyazi\eski.txt  >> kontrol.bat
echo goto cik  >> kontrol.bat
echo )  >> kontrol.bat
echo. >> kontrol.bat
echo :karsilastir >> kontrol.bat
echo dir /b /s "%pathName%" ^| findstr /m /i "\.srt$" ^> C:\Progra~1\FileBot\OtoAltyazi\yeni.txt  >> kontrol.bat
echo fc /b C:\Progra~1\FileBot\OtoAltyazi\eski.txt C:\Progra~1\FileBot\OtoAltyazi\yeni.txt^|find /i "no differences"^>nul >> kontrol.bat
echo if errorlevel 1 goto farkli  >> kontrol.bat
echo if not errorlevel 1 goto olustur >> kontrol.bat
echo. >> kontrol.bat 
echo :farkli  >> kontrol.bat
echo set dosya1="C:\Progra~1\FileBot\OtoAltyazi\eski.txt" >> kontrol.bat
echo set dosya2="C:\Progra~1\FileBot\OtoAltyazi\yeni.txt" >> kontrol.bat
echo findstr /G:%%dosya1%% /I /L /B /V %%dosya2%% ^> eklendi.txt >> kontrol.bat
echo msg * /w ^< eklendi.txt >> kontrol.bat
echo goto olustur >> kontrol.bat
echo. >> kontrol.bat
echo :olustur >> kontrol.bat
echo dir /b /s "%pathName%" ^| findstr /m /i "\.srt$" ^> C:\Progra~1\FileBot\OtoAltyazi\eski.txt >> kontrol.bat
echo goto cik  >> kontrol.bat
echo. >> kontrol.bat
echo :cik >> kontrol.bat
echo exit >> kontrol.bat

echo. 2> takip_ayari.txt
echo cmd /c filebot -script fn:suball \"PATH_HERE\" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO >> takip_ayari.txt

echo @echo off > sub.bat
echo wscript C:\Progra~1\FileBot\OtoAltyazi\kontrol.vbs >> sub.bat
echo filebot -script fn:suball "%pathName%" -non-strict --lang %altdil% --log-file context.log --encoding utf8 --format MATCH_VIDEO >> sub.bat
echo wscript C:\Progra~1\FileBot\OtoAltyazi\kontrol.vbs >> sub.bat

echo Set objShell = CreateObject("Shell.Application") > sub.vbs
echo objShell.ShellExecute "C:\Program Files\FileBot\OtoAltyazi\sub.bat", "", "", "runas", 0 >> sub.vbs

echo Set objShell = CreateObject("Shell.Application") > kontrol.vbs
echo objShell.ShellExecute "C:\Program Files\FileBot\OtoAltyazi\kontrol.bat", "", "", "runas", 0 >> kontrol.vbs

echo Katates PIZARTMASI > Info.txt
echo twitter.com/RBCetin - bit.ly/katatesp >> Info.txt
echo Thanks to Ithiel for the -Folder Watch via Context Menu Feature- >> Info.txt
echo %infoscripti% >> Info.txt
echo %subatayi% 2014 >> Info.txt

mkdir "C:\Program Files\FileBot\OtoAltyazi"

copy kontrol.bat "C:\Program Files\FileBot\OtoAltyazi"

copy takip_ayari.txt "C:\Program Files\FileBot\OtoAltyazi"

copy kontrol.vbs "C:\Program Files\FileBot\OtoAltyazi"

copy sub.vbs "C:\Program Files\FileBot\OtoAltyazi"

copy sub.bat "C:\Program Files\FileBot\OtoAltyazi"

copy info.txt "C:\Program Files\FileBot\OtoAltyazi"

DEL kontrol.vbs
DEL kontrol.bat
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

wscript C:\Progra~1\FileBot\OtoAltyazi\kontrol.vbs 

bitsadmin.exe /transfer "Klasor_Takip_CMD" /priority foreground  "https://github.com/katates/otoaltyazi/raw/master/files/takip.bat" "C:\Program Files\FileBot\OtoAltyazi\takip.bat"
bitsadmin.exe /transfer "Klasor_Takip_CMD2" /priority foreground  "https://github.com/katates/otoaltyazi/raw/master/files/takip_et.cmd" "C:\Program Files\FileBot\OtoAltyazi\takip_et.cmd"
bitsadmin.exe /transfer "Klasor_Takip_VBS" /priority foreground  "https://github.com/katates/otoaltyazi/raw/master/files/takip.vbs" "C:\Program Files\FileBot\OtoAltyazi\takip.vbs"


ECHO %basariyla%

pause 
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
	bitsadmin.exe /transfer "FileBot_Guncelle" /priority foreground "http://ufpr.dl.sourceforge.net/project/filebot/filebot/HEAD/FileBot.jar" "%tmp%\FileBot.jar"

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

RD /S /Q "C:\Program Files\FileBot\"
DEL /Q "%watchlist%"

DEL /Q "C:\Program Files\FileBot\OtoAltyazi\sub.vbs"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\sub.bat"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\takip.vbs"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\takip_ayari.txt"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\takip.bat"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\takip_et.cmd"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\kontrol.vbs"
DEL /Q "C:\Program Files\FileBot\OtoAltyazi\kontrol.bat"
RD /S /Q "C:\Program Files\FileBot\OtoAltyazi\"

ECHO ) %kaldirdik%


goto end


:end
pause

:exit
exit