cls

echo [96m關閉整合寫入篩選器 Unified Write Filter [0m
uwfmgr filter disable

choice /n /m "是否重新啟動電腦？[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    shutdown /r /t 3
) else (
    set message="請重新啟動電腦，完成設定"
    set is_check_state=false
)

echo:
pause

