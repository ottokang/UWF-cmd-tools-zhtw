cls

echo [96m������X�g�J�z�ﾹ Unified Write Filter [0m
uwfmgr filter disable

choice /n /m "�O�_���s�Ұʹq���H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    shutdown /r /t 3
) else (
    set message="�Э��s�Ұʹq���A�����]�w"
    set is_check_state=false
)

echo:
pause

