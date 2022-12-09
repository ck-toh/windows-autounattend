# Windows 10/11 Autounattended

1. Download ISO from Microsoft and extract into `.\winoscd`
2. Download Latest Patch from [Windows Catalog Update](https://www.catalog.update.microsoft.com/) and store in `.\hotfix`
3. Check ISO edition to patch 
4. Mount targeted edition from install.wim 
5. Apply update on mounted wim
6. Clean up unnecessary file from wim
7. Commit changes in install.wim
8. copy autounattend.xml into root of `.\winoscd`
9. Generate bootable ISO using oscdimg utility

```
rem dism.exe /Get-WimInfo /wimFile:".\WinOSCD\sources\install.wim"
dism.exe /cleanup-wim
dism.exe /Mount-WIM /WimFile:".\WinOSCD\sources\install.wim" /index:6 /MountDir:".\WIM"
dism.exe /image:".\WIM" /Add-Package /PackagePath:".\Hotfix"
dism.exe /Image:".\WIM" /Cleanup-Image /StartComponentCleanup /ResetBase
dism.exe  /Unmount-wim /mountdir:".\WIM" /commit
copy /y .\autounattend\autounattend.xml .\WinOSCD
oscdimg.exe  -m -o -u2 -udfver102 -bootdata:2#p0,e,b.\WinOSCD\boot\etfsboot.com#pEF,e,b.\WinOSCD\efi\microsoft\boot\Efisys.bin .\WinOSCD\ Win11Pro_22H2_en-GB_x64-Auto.iso
```

## patchISO directory structure
<pre>
patchiso/
├── winoscd/
│   ├── boot/
│   ├── efi/
│   ├── sources/
│   └── support/
├── autounattend/
│   └── autounattend.xml
├── hotfix/
│   └── *.msu
├── wim/
└── patchiso.cmd
</pre>
