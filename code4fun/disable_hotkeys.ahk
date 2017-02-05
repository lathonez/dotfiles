; mute sound (this must go at the top before ANY returns)
SoundSet, 1, Master, mute

; disable Alt+Tab
!Tab::Return

; Disable Windows Key + Tab
#Tab::Return

; Disable Left Windows Key
LWin::Return

; Disable Right Windows Key
RWin::Return

; Disable Alt+F4
!F4::Return

; disable volume keys
Volume_Mute::Return
Volume_Up::Return
Volume_Down::Return

;suspend / resume intercept:
!F5::
InputBox, Code, Unlock, Enter the unlock code.,HIDE
If ErrorLevel
    Return
If (Code = 5498)
    MsgBox, Unlocked
    Suspend, On
Return

^F5::
    Suspend, Off
Return