cls

echo [96mÃö³¬¾ã¦X¼g¤J¿z¿ï¾¹ Unified Write Filter [0m
uwfmgr filter disable

choice /n /m "¬O§_­«·s±Ò°Ê¹q¸£¡H[[92mY[0m, [91mN[0m]"
if %ERRORLEVEL%==1 (
    shutdown /r /t 3
) else (
    set message="½Ð­«·s±Ò°Ê¹q¸£¡A§¹¦¨³]©w"
    set is_check_state=false
)

echo:
pause

