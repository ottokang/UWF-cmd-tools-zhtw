cls

echo [96m�Ұʾ�X�g�J�z�ﾹ Unified Write Filter [0m

:: �]�w�ϺЬ��Ȧs�ϡ]�w�]�ORAM�^
uwfmgr overlay set-type DISK

:: �]�w�Ȧs�ϪŶ��A��쬰 MB
uwfmgr overlay set-size 8192

:: �]�wĵ�i�Ȭ��A��쬰 MB
uwfmgr overlay set-warningthreshold 6144

:: �]�w�Y��ĵ�i�ȡA��쬰 MB
uwfmgr overlay set-criticalthreshold 8192

:: �Ұ� UWF �O�@
uwfmgr filter enable

:: �]�w�O�@�Ϻ�
uwfmgr volume protect c:

echo:
pause