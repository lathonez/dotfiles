#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Persistent
#SingleInstance Force

; close the active window
!+c::WinClose A

; run the shell
^+Enter::Run PowerShell

; start screenshotter
!y::Run, "C:\Windows\system32\SnippingTool.exe"

; Capture the 3 finger click which is sent to Windows as Left windows + Shift + Ctrl + F22
#^+F22::
    Click Middle
Return