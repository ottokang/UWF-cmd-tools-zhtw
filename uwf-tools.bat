@echo off
cd /D "%~dp0"

:: Windows Upadte 控制使用以下指指令
:: https://github.com/tsgrgo/windows-update-disabler

:: 進入管理模式
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)
if not "%2"=="system" (powershell . '%~dp0\wu\PsExec.exe' /accepteula -i -s -d '%0' admin system & exit /b)

:: 檢查是否為 Windows 企業版
echo [1;96m檢測系統資訊中...[0m
echo:
set is_enterprise=null
for /f "tokens=* USEBACKQ" %%F IN (`systeminfo ^| find /c "企業版"`) do (set is_enterprise=%%F)

if "%is_enterprise%"=="0" (
    echo [1;93m你安裝的不是 Windows 企業版，無法使用統一寫入篩選器 Unified Write Filter[0m
    echo:
    pause
    exit
)

:: 設定變數初始值
set message=null
set require_check_state=true
set is_uwf_installed=false
set is_uwf_enabled=false
set is_wu_enabled=true
set is_fast_startup_enabled=true

::設定延遲展開變數
setlocal enabledelayedexpansion


:: 主選單
:MENU
cls
echo:
echo [96m《統一寫入篩選器 UWF 控制工具》[0m
echo:

:::: 是否進行狀態檢查
if %require_check_state%==true (
    call _check_state.bat
)

:::: 訊息區
if %message%==null (
    echo:
) else (
    echo [92;103m  %message%  [0m
)
echo:

:::: 狀態顯示區
if %is_uwf_installed%==true (
    echo: UWF  [42m 已安裝 [0m
) else (
    echo: UWF  [41m 未安裝 [0m
)

echo:

if %is_uwf_enabled%==true (
    echo: UWF  [42m 已啟用 [0m
) else (
    echo: UWF  [41m 未啟用 [0m
)

echo:

if %is_fast_startup_enabled%==true (
    echo: 快速啟動  [42m 已啟用 [0m
) else (
    echo: 快速啟動  [41m 未啟用 [0m
)

echo:

if %is_wu_enabled%==true (
    echo: Windows Update  [42m 已啟用 [0m
) else (
    echo: Windows Update  [41m 未啟用 [0m
)
echo:
echo:

:::: 選單區
if %is_wu_enabled%==true (
    if %is_uwf_installed%==true (
        echo [97m[[1;95mU[0m[97m] 移除 UWF[0m
    ) else (
        echo [97m[[1;96mI[0m[97m] 安裝 UWF[0m
    )
) else (
    if %is_uwf_enabled%==false (
        echo [1;95m Windows Update 未啟用，無法進行 UWF 安裝，請先啟用 Windows Update[0m
    )
)
echo:

if %is_uwf_installed%==true (
    if %is_uwf_enabled%==true (
        echo [97m[[91mD[0m[97m] 關閉 UWF[0m
        echo:
    ) else (
        echo [97m[[96mE[0m[97m] 啟動 UWF[0m
    )
)
echo:
echo:

if %is_wu_enabled%%==true (
    echo [97m[[93mZ[0m[97m] 關閉 Windows Update[0m
) else (
    echo [97m[[96mW[0m[97m] 啟動 Windows Update[0m
)
echo:

if %is_uwf_installed%==true (
    echo [97m[S] 顯示 UWF 設定狀態[0m
)

echo:
echo:
echo [97m[[94mQ[0m[97m] 離開[0m
echo:
echo:

choice /c iuedwzsqr /n /m 請選擇命令：
if %ERRORLEVEL%==1 goto INSTALL_UWF
if %ERRORLEVEL%==2 goto UNINSTALL_UWF
if %ERRORLEVEL%==3 goto ENABLE_UWF
if %ERRORLEVEL%==4 goto DISABLE_UWF
if %ERRORLEVEL%==5 goto ENABLE_WU
if %ERRORLEVEL%==6 goto DISABLE_WU
if %ERRORLEVEL%==7 goto SHOW_SETTING
if %ERRORLEVEL%==8 goto EXIT
if %ERRORLEVEL%==9 goto REFRESH


:: 安裝 UWF
:INSTALL_UWF
if %is_uwf_installed%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "是否進行[4;96m安裝 UWF 程序[0m？[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call _install_uwf.bat
    set message="安裝 UWF 完成"
    set is_uwf_installed=true
    set require_check_state=true
) else (
    set message="未安裝 UWF"
    set require_check_state=false
)
goto MENU


:: 移除 UWF
:UNINSTALL_UWF
if %is_uwf_installed%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "是否進行[4;95m移除 UWF 程序[0m？[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call _uninstall_uwf.bat
    set message="移除 UWF 完成"
    set is_uwf_installed=false
    set is_uwf_enabled=false
    set require_check_state=true
) else (
    set message="未移除 UWF"
    set require_check_state=false
)
goto MENU


:: 啟動 UWF
:ENABLE_UWF
if %is_uwf_enabled%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "是否進行[4;96m啟動 UWF 程序[0m？[[92mY[0m, [91mN[0m]"
if !ERRORLEVEL!==1 (
    call .\wu\_disable_wu.bat
    call _enable_uwf.bat
    choice /n /m "是否重新啟動電腦，完成啟動 UWF 設定？[[92mY[0m, [91mN[0m]"
    if !ERRORLEVEL!==1 (
        shutdown /r /t 3
    ) else (
        set message="請重新啟動電腦，完成啟動 UWF 設定"
        set is_check_state=true
    )
) else (
    set message="未啟動 UWF"
    set require_check_state=false
)
goto MENU


:: 關閉 UWF
:DISABLE_UWF
if %is_uwf_enabled%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "是否進行[4;96m關閉 UWF 程序[0m？[[92mY[0m, [91mN[0m]"
if !ERRORLEVEL!==1 (
    call _disable_uwf.bat
    choice /n /m "是否重新啟動電腦，完成關閉 UWF 設定？[[92mY[0m, [91mN[0m]"
    if !ERRORLEVEL!==1 (
        shutdown /r /t 3 /c "關閉 UWF 重開機"
    ) else (
        set message="請重新啟動電腦，完成關閉 UWF 設定"
        set is_check_state=true
    )
) else (
    set message="未關閉 UWF"
    set require_check_state=false
)
goto MENU


:: 啟動 Windows Update
:ENABLE_WU
if %is_wu_enabled%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "是否進行[4;96m啟動 Windows Update 程序[0m？[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call .\wu\_enable_wu.bat
    set message="啟動 Windows Update 完成"
    set require_check_state= true
) else (
    set message="未啟動 Windows Update"
    set require_check_state=false
)
goto MENU


:: 關閉 Windows Update
:DISABLE_WU
if %is_wu_enabled%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "是否進行[4;96m關閉 Windows Update 程序[0m？[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call .\wu\_disable_wu.bat
    set message="關閉 Windows Update 完成"
    set require_check_state= true
) else (
    set message="未關閉 Windows Update"
    set require_check_state=false
)
goto MENU


:: 顯示 UWF 設定狀態
:SHOW_SETTING
cls
set message=null
call _show_config.bat
goto MENU


:: 離開
:EXIT
echo 離開 UWF 控制系統
exit


:: 刷新選單
:REFRESH
set require_check_state=true
goto MENU