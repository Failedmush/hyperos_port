@echo off
title ��ˢ�ű� [����ѡ�д��ڣ���ס���Ҽ���س���Ŵ���С���ڻָ�]
:MENU
if not exist bin\Windows (
   echo.
   echo.δ��ѹ��| Please unzip the entire zip file first.
   echo.
   pause
   exit
)
cls

if not exist *boot* (
   echo.
   echo.Boot �ļ���ʧ����ֹˢ�� | Boot.img is missing, abort.
   echo.
   pause
   exit
)
if exist super.zst (
   echo.����ת�� super.zst | Decompressing super.zst
   echo.
   bin\Windows\zstd.exe --rm -d super.zst -o super.img
   if "%ERRORLEVEL%" neq "0" (
      echo.ת��ʧ�ܣ�| failed, abort.
      pause
      exit
   )
)
cls
echo.
echo.^<1^> ��ʼˢ����ˢ��֧��KSU��boot.img | Flashing with KSU supported boot.img
echo.^<2^> ��ʼˢ��������ٷ�boot.img | Flashing with official boot.img
echo.
set /p CHOICE="��ѡ��|Choose:"
if "%CHOICE%" equ "1" goto FLASH_ROOT
if "%CHOICE%" equ "2" goto REMOVE_ROOT
goto MENU
:FLASH_ROOT
if not exist boot_tv.img (
   echo.
   echo.û��Root�ļ�|No KSU supported boot.img found
   echo.
   pause
   exit
) else (
   echo.
   bin\Windows\fastboot flash boot boot_tv.img
   echo.
   goto FLASH
)

:REMOVE_ROOT
if not exist boot_official.img (
   echo.
   echo.û�йٷ�Boot�ļ� | No official boot.img found.
   echo.
   pause
   exit
) else (
   echo.
   bin\Windows\fastboot flash boot boot_official.img
   echo.
   goto FLASH
)
:FLASH
echo.
set /p WIPE="�Ƿ���Ҫ������ݣ�(y/n) | Wipe all data? (y/n)"
echo.
echo.ˢ��super���ܻῨһ�ᣬ�����ĵȴ�������| Please wait patiently 
echo.������ ^<waiting for any device^> ������Ѱ������ | if stuct at ^<waiting for any device^>, you need to find and install usb drivers manually. 
echo.

rem
bin\Windows\fastboot flash "abl" "firmware-update/abl.elf"
bin\Windows\fastboot flash "ablbak" "firmware-update/abl.elf"
bin\Windows\fastboot flash "aop" "firmware-update/aop.mbn"
bin\Windows\fastboot flash "aopbak" "firmware-update/aop.mbn"
bin\Windows\fastboot flash "bluetooth" "firmware-update/BTFM.bin"
bin\Windows\fastboot flash "cmnlib" "firmware-update/cmnlib.mbn"
bin\Windows\fastboot flash "cmnlibbak" "firmware-update/cmnlib.mbn"
bin\Windows\fastboot flash "cmnlib64" "firmware-update/cmnlib64.mbn"
bin\Windows\fastboot flash "cmnlib64bak" "firmware-update/cmnlib64.mbn"
bin\Windows\fastboot flash "devcfg" "firmware-update/devcfg.mbn"
bin\Windows\fastboot flash "devcfgbak" "firmware-update/devcfg.mbn"
bin\Windows\fastboot flash "dsp" "firmware-update/dspso.bin"
bin\Windows\fastboot flash "dtbo" "firmware-update/dtbo.img"
bin\Windows\fastboot flash "featenabler" "firmware-update/featenabler.mbn"
bin\Windows\fastboot flash "hyp" "firmware-update/hyp.mbn"
bin\Windows\fastboot flash "hypbak" "firmware-update/hyp.mbn"
bin\Windows\fastboot flash "keymaster" "firmware-update/km4.mbn"
bin\Windows\fastboot flash "logo" "firmware-update/logo.img"
bin\Windows\fastboot flash "modem" "firmware-update/NON-HLOS.bin"
bin\Windows\fastboot flash "qupfw" "firmware-update/qupv3fw.elf"
bin\Windows\fastboot flash "qupfwbak" "firmware-update/qupv3fw.elf"
bin\Windows\fastboot flash "storsec" "firmware-update/storsec.mbn"
bin\Windows\fastboot flash "storsecbak" "firmware-update/storsec.mbn"
bin\Windows\fastboot flash "tz" "firmware-update/tz.mbn"
bin\Windows\fastboot flash "tzbak" "firmware-update/tz.mbn"
bin\Windows\fastboot flash "uefisecapp" "firmware-update/uefi_sec.mbn"
bin\Windows\fastboot flash "vbmeta_system" "firmware-update/vbmeta_system.img"
bin\Windows\fastboot flash "vbmeta" "firmware-update/vbmeta.img"
bin\Windows\fastboot flash "xbl_4" "firmware-update/xbl_4.elf"
bin\Windows\fastboot flash "xbl_5" "firmware-update/xbl_5.elf"
bin\Windows\fastboot flash "xbl_config_4" "firmware-update/xbl_config_4.elf"
bin\Windows\fastboot flash "xbl_config_5" "firmware-update/xbl_config_5.elf"
if exist super_empty.img bin\Windows\fastboot flash super firmware-update/super_empty.img
if exist super.img bin\Windows\fastboot flash super super.img
echo.ˢ��super���ܻῨһ�ᣬ�����ĵȴ������� | Please wait patiently !!!

if /i "%WIPE%" equ "y" (
   bin\Windows\fastboot erase metadata
   bin\Windows\fastboot erase userdata
)
bin\Windows\fastboot reboot
pause