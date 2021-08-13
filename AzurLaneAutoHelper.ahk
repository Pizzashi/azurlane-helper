;====================Compiler directives====================;
;@Ahk2Exe-SetName Azur Lane Auto Helper
;@Ahk2Exe-SetMainIcon Main.ico
;@Ahk2Exe-AddResource Main.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource Main.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource Main.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource Main.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetCopyright Copyright @ Baconfry 2021
;@Ahk2Exe-SetCompanyName Furaico
;@Ahk2Exe-SetVersion 0.3.3.0
;===========================================================;

#NoEnv                                          ; Needed for blazing fast performance
#SingleInstance, Force                          ; Allows only one instance of the script to run
SetWorkingDir %A_ScriptDir%                     ; Needed by some functions to work properly
; This code appears only in the compiled script
/*@Ahk2Exe-Keep
ListLines Off                                   ; Turns off logging script actions for improved performance
#KeyHistory 0                                   ; Turns off loggins keystrokes for improved performance
*/

global APP_VERSION := "Azur Lane Auto Helper v0.3.3.0"
                    . "`n"
                    . "Shift + F12 to toggle monitoring"
                    . "`n"
                    . "Shift + F11 to toggle autopilot"
Menu, Tray, Tip, % APP_VERSION

; This code appears only in the compiled script
/*@Ahk2Exe-Keep
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, QuitHelper
*/

#Include FindText.ahk
#Include Checks.ahk
#Include Assets.ahk
#Include GUI.ahk

; Check for events that require prompts every three seconds
; Switch is Shift + F12
+F12::
    Critical

    if (IS_MONITORING) {
        IS_MONITORING := false
        UpdateTrayStatus()
        AlertShikikan("monitoring is now off", true)
        DisableAllTimers()
    } else {
        IS_MONITORING := true
        UpdateTrayStatus()
        AlertShikikan("monitoring is now active", true)
        SetTimer, ImportantEventsCheck, 1000
        TimeOutTick("start")
    }
return

+F11::
    Critical
    
    if (AUTOPILOT_MODE) {
        AUTOPILOT_MODE := false
        UpdateTrayStatus()
        AlertShikikan("autopilot is now off", true)
    }
    else {
        AUTOPILOT_MODE := true
        UpdateTrayStatus()
        AlertShikikan("autopilot is now on", true)
    }
return

ClickContinue()
{
    ; https://www.autohotkey.com/boards/viewtopic.php?f=7&t=33596
    ; ctrl + f: "click without moving the cursor"

    ; Arbitrary, point this to where bluestacks is (anywhere WITHIN the game screen)
    ; Note: Try to find out why f***ing hWnd := Winexist() does not freaking work
    bluestacksX := 2000, bluestacksY := 400

    if !hWnd := DllCall("user32\WindowFromPoint", "UInt64", (bluestacksX & 0xFFFFFFFF)|(bluestacksY << 32), "Ptr")
        return

    ; the X and Y are arbitrary...
    ControlClick,, % "ahk_id " hWnd,,,, NA x590 y435
    return
}

; Depends on the superglobal variables IS_MONITORING and AUTOPILOT_MODE
UpdateTrayStatus()
{
    monitoringStatus := (IS_MONITORING) ? "on" : "off"
    , autopilotStatus := (AUTOPILOT_MODE) ? "on" : "off"
    Menu, Tray, Tip, % APP_VERSION . "`n`n"
                                   . "Monitoring: " monitoringStatus "`n"
                                   . "Autopilot: " autopilotStatus 
}

DisableAllTimers()
{
    SetTimer, CheckLevelCompletion, Off
    SetTimer, CheckDockSpace, Off
    SetTimer, CheckBoatGrill, Off
    SetTimer, CheckDefeatedWindow, Off
    SetTimer, ImportantEventsCheck, Off
    SetTimer, TimeOut, Off
}

TimeOutTick(trigger)
{
    if (trigger = "start") {
        SetTimer, TimeOut, -1800000 ; Turn off monitoring after 30 minutes to save resources
    } else if (trigger = "stop") {
        SetTimer, TimeOut, Off
    }
    return
}

ImportantEventAlert(message)
{
    ResetTimeOut()
    AlertShikikan(message)
    SetTimer, ImportantEventsCheck, Off
}

ResetTimeOut()
{
    TimeOutTick("stop")
    TimeOutTick("start")
}

ImportantEventsCheck:
    if (Event.levelComplete()) ; Level is complete
    {
        if (AUTOPILOT_MODE) { ; Automatically click continue
            ResetTimeOut()
            ClickContinue()
        } else {
            ImportantEventAlert("your boatgrills have finished the level they're farming")
            SetTimer, CheckLevelCompletion, 1000
        }
    }
    else if (Event.dockFull()) ; Dock is full
    {
        ImportantEventAlert("your dock is full")
        SetTimer, CheckDockSpace, 1000
    }
    else if (Event.newShip()) ; Found new boatgrill
    {
        ImportantEventAlert("you have found a new boatgrill")
        SetTimer, CheckBoatGrill, 1000
    }
    else if (Event.partyAnnihilated()) ; Party was annihilated
    {
        ImportantEventAlert("the farming party was defeated")
        SetTimer, CheckDefeatedWindow, 1000
    }
return

;====================Check if the important event windows were closed====================;

CheckLevelCompletion:
    if !(Event.levelComplete()) ; Complete banner is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckLevelCompletion, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckDockSpace:
    if !(Event.dockFull()) ; Dock is full warning is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckDockSpace, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckBoatGrill:
    if !(Event.newShip()) ; New boatgrill window is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckBoatGrill, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckDefeatedWindow:
    if !(Event.partyAnnihilated()) ; Fleet defeated window is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckDefeatedWindow, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

;========================================================================================;

TimeOut:
    DisableAllTimers()
    IS_MONITORING := false
    AlertShikikan("it looks like you're not farming. I'll stop monitoring to save resources")
    UpdateTrayStatus()
return

QuitHelper:
ExitApp