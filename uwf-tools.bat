@echo off
cd /D "%~dp0"

:: Windows Upadte ±±¨î¨Ï¥Î¥H¤U«ü«ü¥O
:: https://github.com/tsgrgo/windows-update-disabler

:: ¶i¤JºÞ²z¼Ò¦¡
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)
if not "%2"=="system" (powershell . '%~dp0\wu\PsExec.exe' /accepteula -i -s -d '%0' admin system & exit /b)

:: ÀË¬d¬O§_¬° Windows ¥ø·~ª©
echo [1;96mÀË´ú¨t²Î¸ê°T¤¤...[0m
echo:
set is_enterprise=null
for /f "tokens=* USEBACKQ" %%F IN (`systeminfo ^| find /c "¥ø·~ª©"`) do (set is_enterprise=%%F)

if "%is_enterprise%"=="0" (
    echo [1;93m§A¦w¸Ëªº¤£¬O Windows ¥ø·~ª©¡AµLªk¨Ï¥Î²Î¤@¼g¤J¿z¿ï¾¹ Unified Write Filter[0m
    echo:
    pause
    exit
)

:: ³]©wÅÜ¼Æªì©l­È
set message=null
set require_check_state=true
set is_uwf_installed=false
set is_uwf_enabled=false
set is_wu_enabled=true
set is_fast_startup_enabled=true

::³]©w©µ¿ð®i¶}ÅÜ¼Æ
setlocal enabledelayedexpansion


:: ¥D¿ï³æ
:MENU
cls
echo:
echo [96m¡m²Î¤@¼g¤J¿z¿ï¾¹ UWF ±±¨î¤u¨ã¡n[0m
echo:

:::: ¬O§_¶i¦æª¬ºAÀË¬d
if %require_check_state%==true (
    call _check_state.bat
)

:::: °T®§°Ï
if %message%==null (
    echo:
) else (
    echo [92;103m  %message%  [0m
)
echo:

:::: ª¬ºAÅã¥Ü°Ï
if %is_uwf_installed%==true (
    echo: UWF  [42m ¤w¦w¸Ë [0m
) else (
    echo: UWF  [41m ¥¼¦w¸Ë [0m
)

echo:

if %is_uwf_enabled%==true (
    echo: UWF  [42m ¤w±Ò¥Î [0m
) else (
    echo: UWF  [41m ¥¼±Ò¥Î [0m
)

echo:

if %is_fast_startup_enabled%==true (
    echo: §Ö³t±Ò°Ê  [42m ¤w±Ò¥Î [0m
) else (
    echo: §Ö³t±Ò°Ê  [41m ¥¼±Ò¥Î [0m
)

echo:

if %is_wu_enabled%==true (
    echo: Windows Update  [42m ¤w±Ò¥Î [0m
) else (
    echo: Windows Update  [41m ¥¼±Ò¥Î [0m
)
echo:
echo:

:::: ¿ï³æ°Ï
if %is_wu_enabled%==true (
    if %is_uwf_installed%==true (
        echo [97m[[1;95mU[0m[97m] ²¾°£ UWF[0m
    ) else (
        echo [97m[[1;96mI[0m[97m] ¦w¸Ë UWF[0m
    )
) else (
    if %is_uwf_enabled%==false (
        echo [1;95m Windows Update ¥¼±Ò¥Î¡AµLªk¶i¦æ UWF ¦w¸Ë¡A½Ð¥ý±Ò¥Î Windows Update[0m
    )
)
echo:

if %is_uwf_installed%==true (
    if %is_uwf_enabled%==true (
        echo [97m[[91mD[0m[97m] Ãö³¬ UWF[0m
        echo:
    ) else (
        echo [97m[[96mE[0m[97m] ±Ò°Ê UWF[0m
    )
)
echo:
echo:

if %is_wu_enabled%%==true (
    echo [97m[[93mZ[0m[97m] Ãö³¬ Windows Update[0m
) else (
    echo [97m[[96mW[0m[97m] ±Ò°Ê Windows Update[0m
)
echo:

if %is_uwf_installed%==true (
    echo [97m[S] Åã¥Ü UWF ³]©wª¬ºA[0m
)

echo:
echo:
echo [97m[[94mQ[0m[97m] Â÷¶}[0m
echo:
echo:

choice /c iuedwzsqr /n /m ½Ð¿ï¾Ü©R¥O¡G
if %ERRORLEVEL%==1 goto INSTALL_UWF
if %ERRORLEVEL%==2 goto UNINSTALL_UWF
if %ERRORLEVEL%==3 goto ENABLE_UWF
if %ERRORLEVEL%==4 goto DISABLE_UWF
if %ERRORLEVEL%==5 goto ENABLE_WU
if %ERRORLEVEL%==6 goto DISABLE_WU
if %ERRORLEVEL%==7 goto SHOW_SETTING
if %ERRORLEVEL%==8 goto EXIT
if %ERRORLEVEL%==9 goto REFRESH


:: ¦w¸Ë UWF
:INSTALL_UWF
if %is_uwf_installed%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "¬O§_¶i¦æ[4;96m¦w¸Ë UWF µ{§Ç[0m¡H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call _install_uwf.bat
    set message="¦w¸Ë UWF §¹¦¨"
    set is_uwf_installed=true
    set require_check_state=true
) else (
    set message="¥¼¦w¸Ë UWF"
    set require_check_state=false
)
goto MENU


:: ²¾°£ UWF
:UNINSTALL_UWF
if %is_uwf_installed%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "¬O§_¶i¦æ[4;95m²¾°£ UWF µ{§Ç[0m¡H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call _uninstall_uwf.bat
    set message="²¾°£ UWF §¹¦¨"
    set is_uwf_installed=false
    set is_uwf_enabled=false
    set require_check_state=true
) else (
    set message="¥¼²¾°£ UWF"
    set require_check_state=false
)
goto MENU


:: ±Ò°Ê UWF
:ENABLE_UWF
if %is_uwf_enabled%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "¬O§_¶i¦æ[4;96m±Ò°Ê UWF µ{§Ç[0m¡H[[92mY[0m, [91mN[0m]"
if !ERRORLEVEL!==1 (
    call .\wu\_disable_wu.bat
    call _enable_uwf.bat
    choice /n /m "¬O§_­«·s±Ò°Ê¹q¸£¡A§¹¦¨±Ò°Ê UWF ³]©w¡H[[92mY[0m, [91mN[0m]"
    if !ERRORLEVEL!==1 (
        shutdown /r /t 3
    ) else (
        set message="½Ð­«·s±Ò°Ê¹q¸£¡A§¹¦¨±Ò°Ê UWF ³]©w"
        set is_check_state=true
    )
) else (
    set message="¥¼±Ò°Ê UWF"
    set require_check_state=false
)
goto MENU


:: Ãö³¬ UWF
:DISABLE_UWF
if %is_uwf_enabled%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "¬O§_¶i¦æ[4;96mÃö³¬ UWF µ{§Ç[0m¡H[[92mY[0m, [91mN[0m]"
if !ERRORLEVEL!==1 (
    call _disable_uwf.bat
    choice /n /m "¬O§_­«·s±Ò°Ê¹q¸£¡A§¹¦¨Ãö³¬ UWF ³]©w¡H[[92mY[0m, [91mN[0m]"
    if !ERRORLEVEL!==1 (
        shutdown /r /t 3 /c "Ãö³¬ UWF ­«¶}¾÷"
    ) else (
        set message="½Ð­«·s±Ò°Ê¹q¸£¡A§¹¦¨Ãö³¬ UWF ³]©w"
        set is_check_state=true
    )
) else (
    set message="¥¼Ãö³¬ UWF"
    set require_check_state=false
)
goto MENU


:: ±Ò°Ê Windows Update
:ENABLE_WU
if %is_wu_enabled%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "¬O§_¶i¦æ[4;96m±Ò°Ê Windows Update µ{§Ç[0m¡H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call .\wu\_enable_wu.bat
    set message="±Ò°Ê Windows Update §¹¦¨"
    set require_check_state= true
) else (
    set message="¥¼±Ò°Ê Windows Update"
    set require_check_state=false
)
goto MENU


:: Ãö³¬ Windows Update
:DISABLE_WU
if %is_wu_enabled%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "¬O§_¶i¦æ[4;96mÃö³¬ Windows Update µ{§Ç[0m¡H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call .\wu\_disable_wu.bat
    set message="Ãö³¬ Windows Update §¹¦¨"
    set require_check_state= true
) else (
    set message="¥¼Ãö³¬ Windows Update"
    set require_check_state=false
)
goto MENU


:: Åã¥Ü UWF ³]©wª¬ºA
:SHOW_SETTING
cls
set message=null
call _show_config.bat
goto MENU


:: Â÷¶}
:EXIT
echo Â÷¶} UWF ±±¨î¨t²Î
exit


:: ¨ê·s¿ï³æ
:REFRESH
set require_check_state=true
goto MENU