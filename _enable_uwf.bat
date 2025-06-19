cls

echo [96m±Ò°Ê¾ã¦X¼g¤J¿z¿ï¾¹ Unified Write Filter [0m

:: ³]©wºÏºÐ¬°¼È¦s°Ï¡]¹w³]¬ORAM¡^
uwfmgr overlay set-type DISK

:: ³]©w¼È¦s°ÏªÅ¶¡¡A³æ¦ì¬° MB
uwfmgr overlay set-size 8192

:: ³]©wÄµ§i­È¬°¡A³æ¦ì¬° MB
uwfmgr overlay set-warningthreshold 6144

:: ³]©wÄY­«Äµ§i­È¡A³æ¦ì¬° MB
uwfmgr overlay set-criticalthreshold 8192

:: ±Ò°Ê UWF «OÅ@
uwfmgr filter enable

:: ³]©w«OÅ@ºÏºÐ
uwfmgr volume protect c:

echo:
pause