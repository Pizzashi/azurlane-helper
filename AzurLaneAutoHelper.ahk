;====================Compiler directives====================;
;@Ahk2Exe-SetName Azur Lane Auto Helper
;@Ahk2Exe-SetMainIcon Main.ico
;@Ahk2Exe-AddResource Main.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource Main.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource Main.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource Main.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetCopyright Copyright @ Baconfry 2021
;@Ahk2Exe-SetCompanyName Furaico
;@Ahk2Exe-SetVersion 0.5.1.4
;===========================================================;

#NoEnv                                          ; Needed for blazing fast performance
#SingleInstance, Force                          ; Allows only one instance of the script to run
SetWorkingDir %A_ScriptDir%                     ; Needed by some functions to work properly
; This code appears only in the compiled script
/*@Ahk2Exe-Keep
ListLines Off                                   ; Turns off logging script actions for improved performance
#KeyHistory 0                                   ; Turns off loggins keystrokes for improved performance
*/

global APP_VERSION := "Azur Lane Auto Helper v0.5.1.4"
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
#Include Push.ahk

UpdateTrayStatus() ; Initial tray update

return

; Check for events that require prompts every three seconds
; Switch is Shift + F12
; Switch for Autopilot mode is Shift + F11
; Switch for phone notifications is Shift + F10

+F12::
    Critical

    if (IS_MONITORING) {
        IS_MONITORING := false
        UpdateTrayStatus()
        AlertShikikan("monitoring is now off", true, false)
        DisableAllTimers()
    } else {
        RetrieveEmuPos()
        IS_MONITORING := true
        UpdateTrayStatus()
        AlertShikikan("monitoring is now active", true, false)
        SetTimer, ImportantEventsCheck, 1000
        TimeOutTick("start")
    }
return

+F11::
    Critical
    
    if (AUTOPILOT_MODE) {
        AUTOPILOT_MODE := false
        UpdateTrayStatus()
        AlertShikikan("autopilot is now off", true, false)
    }
    else {
        AUTOPILOT_MODE := true
        UpdateTrayStatus()
        AlertShikikan("autopilot is now on", true, false)
    }
return

+F10::
    Critical
    
    if (NOTIFY_EVENTS) {
        NOTIFY_EVENTS := false
        UpdateTrayStatus()
        AlertShikikan("phone notifications are now off", true, false)
    }
    else {
        NOTIFY_EVENTS := true
        UpdateTrayStatus()
        AlertShikikan("phone notifications are now on", true, true, false)
    }
return

RetrieveEmuPos()
{
    ; Make sure to rename the Bluestacks emulator containing Azur Lane to "Azur Lane"
    WinGetPos, BLUESTACKS_X, BLUESTACKS_Y, BLUESTACKS_W, BLUESTACKS_H, Azur Lane
    ; Bluestacks' toolbar is a flat 40 (no matter the resolution), and it's not included in ControlClick's scope
    ; Exclude the emulator's toolbar in the dimensions
    BLUESTACKS_Y += 40, BLUESTACKS_H -= 40
    if (BLUESTACKS_X = "" || BLUESTACKS_X < 0) {
        Msgbox, 0, % " Azur Lane Helper: Monitoring error", % "Azur Lane Window was not found. Please make sure that it is visible on the screen and recalibrate by restarting the monitoring status (Shift + F12). " . "X: " X . " Y: " Y "." 
        exit
    }

    Msgbox, 4, % " Azur Lane Helper", % "The position and dimensions of Bluestacks are:`n" "X: " BLUESTACKS_X "`nY: " BLUESTACKS_Y "`nW: " BLUESTACKS_W "`nH: " BLUESTACKS_H "`n`nIf these are correct, press YES; otherwise press NO and recalibrate by pressing Shift+F12 again."
    IfMsgBox, No
        exit
}

ClickContinue()
{
    ; https://www.autohotkey.com/boards/viewtopic.php?f=7&t=33596
    ; ctrl + f: "click without moving the cursor"
    
    ; clickX and clickY values were retrieved with experimental methods using proportions  
    clickX := "x" . ( (BLUESTACKS_W)*5 )//8
    , clickY := "y" . ( (BLUESTACKS_H)*13 )//15

    emuHwnd := DllCall("user32\WindowFromPoint", "UInt64", (BLUESTACKS_X+100 & 0xFFFFFFFF)|(BLUESTACKS_Y+100 << 32), "Ptr")
            
    ControlClick,, % "ahk_id " emuHwnd,,,, NA %clickX% %clickY%
}

; Depends on the superglobal variables IS_MONITORING and AUTOPILOT_MODE
UpdateTrayStatus()
{
    monitoringStatus := (IS_MONITORING) ? "on" : "off"
    , autopilotStatus := (AUTOPILOT_MODE) ? "on" : "off"
    , pushNotifStatus := (NOTIFY_EVENTS) ? "on" : "off"
    Menu, Tray, Tip, % APP_VERSION . "`n`n"
                                   . "Monitoring: " monitoringStatus "`n"
                                   . "Autopilot: " autopilotStatus "`n"
                                   . "Push Notifs: " pushNotifStatus
}

DisableAllTimers()
{
    SetTimer, CheckLevelCompletion, Off
    SetTimer, CheckDockSpace, Off
    SetTimer, CheckBoatGrill, Off
    SetTimer, CheckDefeatedWindow, Off
    SetTimer, CheckDepletedOil, Off
    SetTimer, ImportantEventsCheck, Off
    SetTimer, TimeOut, Off
}

TimeOutTick(trigger)
{
    if (trigger = "start") {
        SetTimer, TimeOut, -3600000 ; Turn off monitoring after an hour to save resources
    } else if (trigger = "stop") {
        SetTimer, TimeOut, Off
    }
    return
}

ImportantEventAlert(message)
{
    SetTimer, ImportantEventsCheck, Off
    ResetTimeOut()
    AlertShikikan(message)
}

ResetTimeOut()
{
    TimeOutTick("stop")
    TimeOutTick("start")
}

ImportantEventsCheck:
    ; Arrange the events from likely to the most unlikely for faster performance
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
    else if (Event.oilDepleted()) ; Ran out of oil
    {
        ImportantEventAlert("your oil supply has ran out")
        SetTimer, CheckDepletedOil, 1000
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

CheckDepletedOil:
    if !(Event.oilDepleted()) ; Buy more oil window is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckDepletedOil, Off
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