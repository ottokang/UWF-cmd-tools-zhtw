@echo off
cd /D "%~dp0"

:: Windows Upadte ����ϥΥH�U�����O
:: https://github.com/tsgrgo/windows-update-disabler

:: �i�J�޲z�Ҧ�
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)
if not "%2"=="system" (powershell . '%~dp0\wu\PsExec.exe' /accepteula -i -s -d '%0' admin system & exit /b)

:: �ˬd�O�_�� Windows ���~��
echo [1;96m�˴��t�θ�T��...[0m
echo:
set is_enterprise=null
for /f "tokens=* USEBACKQ" %%F IN (`systeminfo ^| find /c "���~��"`) do (set is_enterprise=%%F)

if "%is_enterprise%"=="0" (
    echo [1;93m�A�w�˪����O Windows ���~���A�L�k�ϥβΤ@�g�J�z�ﾹ Unified Write Filter[0m
    echo:
    pause
    exit
)

:: �]�w�ܼƪ�l��
set message=null
set require_check_state=true
set is_uwf_installed=false
set is_uwf_enabled=false
set is_wu_enabled=true
set is_fast_startup_enabled=true

::�]�w����i�}�ܼ�
setlocal enabledelayedexpansion


:: �D���
:MENU
cls
echo:
echo [96m�m�Τ@�g�J�z�ﾹ UWF ����u��n[0m
echo:

:::: �O�_�i�檬�A�ˬd
if %require_check_state%==true (
    call _check_state.bat
)

:::: �T����
if %message%==null (
    echo:
) else (
    echo [92;103m  %message%  [0m
)
echo:

:::: ���A��ܰ�
if %is_uwf_installed%==true (
    echo: UWF  [42m �w�w�� [0m
) else (
    echo: UWF  [41m ���w�� [0m
)

echo:

if %is_uwf_enabled%==true (
    echo: UWF  [42m �w�ҥ� [0m
) else (
    echo: UWF  [41m ���ҥ� [0m
)

echo:

if %is_fast_startup_enabled%==true (
    echo: �ֳt�Ұ�  [42m �w�ҥ� [0m
) else (
    echo: �ֳt�Ұ�  [41m ���ҥ� [0m
)

echo:

if %is_wu_enabled%==true (
    echo: Windows Update  [42m �w�ҥ� [0m
) else (
    echo: Windows Update  [41m ���ҥ� [0m
)
echo:
echo:

:::: ����
if %is_wu_enabled%==true (
    if %is_uwf_installed%==true (
        echo [97m[[1;95mU[0m[97m] ���� UWF[0m
    ) else (
        echo [97m[[1;96mI[0m[97m] �w�� UWF[0m
    )
) else (
    if %is_uwf_enabled%==false (
        echo [1;95m Windows Update ���ҥΡA�L�k�i�� UWF �w�ˡA�Х��ҥ� Windows Update[0m
    )
)
echo:

if %is_uwf_installed%==true (
    if %is_uwf_enabled%==true (
        echo [97m[[91mD[0m[97m] ���� UWF[0m
        echo:
    ) else (
        echo [97m[[96mE[0m[97m] �Ұ� UWF[0m
    )
)
echo:
echo:

if %is_wu_enabled%%==true (
    echo [97m[[93mZ[0m[97m] ���� Windows Update[0m
) else (
    echo [97m[[96mW[0m[97m] �Ұ� Windows Update[0m
)
echo:

if %is_uwf_installed%==true (
    echo [97m[S] ��� UWF �]�w���A[0m
)

echo:
echo:
echo [97m[[94mQ[0m[97m] ���}[0m
echo:
echo:

choice /c iuedwzsqr /n /m �п�ܩR�O�G
if %ERRORLEVEL%==1 goto INSTALL_UWF
if %ERRORLEVEL%==2 goto UNINSTALL_UWF
if %ERRORLEVEL%==3 goto ENABLE_UWF
if %ERRORLEVEL%==4 goto DISABLE_UWF
if %ERRORLEVEL%==5 goto ENABLE_WU
if %ERRORLEVEL%==6 goto DISABLE_WU
if %ERRORLEVEL%==7 goto SHOW_SETTING
if %ERRORLEVEL%==8 goto EXIT
if %ERRORLEVEL%==9 goto REFRESH


:: �w�� UWF
:INSTALL_UWF
if %is_uwf_installed%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "�O�_�i��[4;96m�w�� UWF �{��[0m�H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call _install_uwf.bat
    set message="�w�� UWF ����"
    set is_uwf_installed=true
    set require_check_state=true
) else (
    set message="���w�� UWF"
    set require_check_state=false
)
goto MENU


:: ���� UWF
:UNINSTALL_UWF
if %is_uwf_installed%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "�O�_�i��[4;95m���� UWF �{��[0m�H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call _uninstall_uwf.bat
    set message="���� UWF ����"
    set is_uwf_installed=false
    set is_uwf_enabled=false
    set require_check_state=true
) else (
    set message="������ UWF"
    set require_check_state=false
)
goto MENU


:: �Ұ� UWF
:ENABLE_UWF
if %is_uwf_enabled%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "�O�_�i��[4;96m�Ұ� UWF �{��[0m�H[[92mY[0m, [91mN[0m]"
if !ERRORLEVEL!==1 (
    call .\wu\_disable_wu.bat
    call _enable_uwf.bat
    choice /n /m "�O�_���s�Ұʹq���A�����Ұ� UWF �]�w�H[[92mY[0m, [91mN[0m]"
    if !ERRORLEVEL!==1 (
        shutdown /r /t 3
    ) else (
        set message="�Э��s�Ұʹq���A�����Ұ� UWF �]�w"
        set is_check_state=true
    )
) else (
    set message="���Ұ� UWF"
    set require_check_state=false
)
goto MENU


:: ���� UWF
:DISABLE_UWF
if %is_uwf_enabled%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "�O�_�i��[4;96m���� UWF �{��[0m�H[[92mY[0m, [91mN[0m]"
if !ERRORLEVEL!==1 (
    call _disable_uwf.bat
    choice /n /m "�O�_���s�Ұʹq���A�������� UWF �]�w�H[[92mY[0m, [91mN[0m]"
    if !ERRORLEVEL!==1 (
        shutdown /r /t 3 /c "���� UWF ���}��"
    ) else (
        set message="�Э��s�Ұʹq���A�������� UWF �]�w"
        set is_check_state=true
    )
) else (
    set message="������ UWF"
    set require_check_state=false
)
goto MENU


:: �Ұ� Windows Update
:ENABLE_WU
if %is_wu_enabled%==true (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "�O�_�i��[4;96m�Ұ� Windows Update �{��[0m�H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call .\wu\_enable_wu.bat
    set message="�Ұ� Windows Update ����"
    set require_check_state= true
) else (
    set message="���Ұ� Windows Update"
    set require_check_state=false
)
goto MENU


:: ���� Windows Update
:DISABLE_WU
if %is_wu_enabled%==false (
    set message=null
    set require_check_state=false
    goto MENU
)

choice /n /m "�O�_�i��[4;96m���� Windows Update �{��[0m�H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    call .\wu\_disable_wu.bat
    set message="���� Windows Update ����"
    set require_check_state= true
) else (
    set message="������ Windows Update"
    set require_check_state=false
)
goto MENU


:: ��� UWF �]�w���A
:SHOW_SETTING
cls
set message=null
call _show_config.bat
goto MENU


:: ���}
:EXIT
echo ���} UWF ����t��
exit


:: ��s���
:REFRESH
set require_check_state=true
goto MENU