@echo off
rem ----------------------------------------------------------------
rem  Patching Microsoft Windows Install Image
rem ----------------------------------------------------------------

echo [Mounting Install Image]
dism.exe /Mount-WIM /WimFile:".\WinOSCD\sources\install.wim" /index:6 /MountDir:".\WIM"

echo [Apply Hotfix to Install Image]
dism.exe /image:".\WIM" /Add-Package /PackagePath:".\Hotfix"

echo [Rebase Install Image]
dism.exe /Image:".\WIM" /Cleanup-Image /StartComponentCleanup /ResetBase

echo [Commit Changes to Install Image]
dism.exe  /Unmount-wim /mountdir:".\WIM" /commit

echo [Copy autounattend.xml to install media]
copy /y .\autounattend\autounattend.xml .\WinOSCD

echo [Generate ISO]
oscdimg.exe  -m -o -u2 -udfver102 -bootdata:2#p0,e,b.\WinOSCD\boot\etfsboot.com#pEF,e,b.\WinOSCD\efi\microsoft\boot\Efisys.bin .\WinOSCD\ Win11Pro_22H2_en-GB_x64-Auto.iso
goto :end

rem check number of edition and associated index
dism.exe /Get-WimInfo /wimFile:".\WinOSCD\sources\install.wim"

rem verify package install after patching
dism.exe /Get-Packages /image:".\WIM"

rem add drivers to install image
dism.exe /Image:".\WIM" /Add-Driver /Driver:".\Drivers" /recurse

rem delete unwanted edition from install.wim
dism.exe /Delete-Image /ImageFile:".\WinOSCD\sources\install.wim" /Index:11

rem clean-up dism task
dism.exe /cleanup-wim

:end
