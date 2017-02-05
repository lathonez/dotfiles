# Setup a code4fun laptop

* TWO shortcuts to Chrome on the desktop - one named Kiosk, one named Chrome. Edit the target of Kiosk and append `--kiosk` INSIDE the string
* Remove McAfee from starup: msconfig -> startup -> hide windows serviecs -> kill evreything 'McAffee'
* Remove unwanted startup programs: ctrl + alt + delete -> startup
* Add disable_hotkeys.exe and kiosk to startup: run > shell:startup > download disable_hotkeys.exe from here
* Set power options to shut down when lid is closed (all)
* disable taskman: cmd (as administrator) > `REG add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 1 /f`
* restart as it may block the disable_hotkeys.exe and test

Alt+F5 (5498) to suspend the keyblocking
Ctrl+F5 to re-enable