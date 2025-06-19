:: �ˬd��X�g�J�z�ﾹ Unified Write Filter �O�_�w��
set uwf_install_state=null
for /f "tokens=* USEBACKQ" %%F IN (`where /Q uwfmgr ^| find /c "uwfmgr"`) do (set uwf_install_state=%%F)

if "%uwf_install_state%"=="1" (
    set is_uwf_installed=true
) else (
    set is_uwf_installed=false
)

:: �ˬd��X�g�J�z�ﾹ Unified Write Filter �O�_�ҥ�
if "%is_uwf_installed%"=="true" (
    for /F "usebackq delims=" %%i in (`powershell -NoProfile -Command "(Get-WmiObject -Namespace 'root\standardcimv2\embedded' -Class UWF_Filter).CurrentEnabled.toString().toLower()"`) do (
        set is_uwf_enabled=%%i
    )
)

:: �ˬd Windows Update �O�_�ҥ�
for /F "usebackq delims=" %%i in (`powershell -NoProfile -Command "if (Get-Service -Name 'wuauserv','UsoSvc','uhssvc','WaaSMedicSvc' | Where-Object { $_.Status -eq 'Running' }) { 'true' } else { 'false' }"`) do (
    set is_wu_enabled=%%i
)

:: �ˬd�ֳt�ҰʬO�_�ҥ�
set fast_startup_state=null
for /f "tokens=* USEBACKQ" %%F IN (`reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled ^| find /c "0x1"`) do (set fast_startup_state=%%F)

if "%fast_startup_state%"=="1" (
    set is_fast_startup_enabled=true
) else (
    set is_fast_startup_enabled=false
)