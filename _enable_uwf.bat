cls

echo [96m啟動整合寫入篩選器 Unified Write Filter [0m

:: 設定磁碟為暫存區（預設是RAM）
uwfmgr overlay set-type DISK

:: 設定暫存區空間，單位為 MB
uwfmgr overlay set-size 8192

:: 設定警告值為，單位為 MB
uwfmgr overlay set-warningthreshold 6144

:: 設定嚴重警告值，單位為 MB
uwfmgr overlay set-criticalthreshold 8192

:: 啟動 UWF 保護
uwfmgr filter enable

:: 設定保護磁碟
uwfmgr volume protect c:

echo:
pause