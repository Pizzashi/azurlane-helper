;====================Compiler directives====================;
;@Ahk2Exe-SetName Azur Lane Auto Helper
;@Ahk2Exe-SetMainIcon Main.ico
;@Ahk2Exe-AddResource Main.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource Main.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource Main.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource Main.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetCopyright Copyright @ Baconfry 2021
;@Ahk2Exe-SetCompanyName Furaico
;@Ahk2Exe-SetVersion 0.5.3.0
;===========================================================;

#NoEnv                                          ; Needed for blazing fast performance
#SingleInstance, Force                          ; Allows only one instance of the script to run
SetWorkingDir %A_ScriptDir%                     ; Needed by some functions to work properly
; This code appears only in the compiled script
/*@Ahk2Exe-Keep
ListLines Off                                   ; Turns off logging script actions for improved performance
#KeyHistory 0                                   ; Turns off loggins keystrokes for improved performance
*/

global APP_VERSION := "Azur Lane Auto Helper v0.5.3.0"
Menu, Tray, Tip, % APP_VERSION

; This code appears only in the compiled script
/*@Ahk2Exe-Keep
Menu, Tray, Add, %APP_VERSION%, QuitHelper
Menu, Tray, Disable, %APP_VERSION%
Menu, Tray, Add ; Adds line separator
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, QuitHelper
*/

#Include FindText.ahk
#Include Checks.ahk
#Include Assets.ahk
#Include GUI.ahk
#Include Push.ahk
#Include AutoClicker.ahk

UpdateTrayStatus() ; Initial tray update

return

; Check for events that require prompts every three seconds
; Switch is Shift + F12
; Switch for Autopilot mode is Shift + F11
; Switch for phone notifications is Shift + F10
; Switch for Manual Play assistant is Shift + F9

global MANUAL_PLAY := false
, IS_MONITORING := false
, AUTOPILOT_MODE := false
, NOTIFY_EVENTS := false
, BLUESTACKS_X := ""
, BLUESTACKS_Y := ""
, BLUESTACKS_W := ""
, BLUESTACKS_H := ""

+F12::
    Critical
    if (IS_MONITORING) {
        IS_MONITORING := false
        UpdateTrayStatus()
        AlertShikikan("monitoring is now off", true, false)
        DisableAllTimers()
    } else {
		if (MANUAL_PLAY) {
			Msgbox, 4, % " Azur Lane Helper", % "Manual play assistant is on, would you like to switch to AutoPlay assistant?"
			IfMsgBox, No
				exit
			MANUAL_PLAY := false
    	}

        RetrieveEmuPos()
        IS_MONITORING := true
        UpdateTrayStatus()
		DisableAllTimers()
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

+F9::
    Critical
	if (MANUAL_PLAY) {
		MANUAL_PLAY := false
		DisableAllTimers()
		UpdateTrayStatus()
		AlertShikikan("manual play assistant is now off", true, false)
	} else {
		if (IS_MONITORING) {
			Msgbox, 4, % " Azur Lane Helper", % "AutoPlay assistant is on, would you like to switch to manual play assistant?"
			IfMsgBox, No
				exit
			IS_MONITORING := false
    	}
		RetrieveEmuPos()
        MANUAL_PLAY := true
        UpdateTrayStatus()
        DisableAllTimers()
        AlertShikikan("manual play helper is now on", true, false)
        SetTimer, ManualPlayChecks, 1000
		TimeOutTick("start")
	}
return

; Depends on the superglobal variables IS_MONITORING and AUTOPILOT_MODE
UpdateTrayStatus()
{
    monitoringStatus := (IS_MONITORING) ? "on" : "off"
    , autopilotStatus := (AUTOPILOT_MODE) ? "on" : "off"
    , pushNotifStatus := (NOTIFY_EVENTS) ? "on" : "off"
	, manualPlayStatus := (MANUAL_PLAY) ? "on" : "off"
    Menu, Tray, Tip, % "Monitoring: " monitoringStatus "`n"
                     . "Autopilot: " autopilotStatus "`n"
                     . "Push Notifs: " pushNotifStatus "`n`n"
                     . "Manual helper: " manualPlayStatus
}

DisableAllTimers()
{
    SetTimer, CheckLevelCompletion, Off
    SetTimer, CheckDockSpace, Off
    SetTimer, CheckBoatGrill, Off
    SetTimer, CheckDefeatedWindow, Off
    SetTimer, CheckDepletedOil, Off
    SetTimer, CheckCertificateNotice, Off
    SetTimer, ImportantEventsCheck, Off

    SetTimer, CheckDefeatedWindowM, Off
    SetTimer, CheckBattleCompletion, Off
    SetTimer, ManualPlayChecks, Off

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
	if (IS_MONITORING)
		SetTimer, ImportantEventsCheck, Off
	else if (MANUAL_PLAY)
		SetTimer, ManualPlayChecks, Off

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
    else if (Event.receivedCertificate()) ; Found certificate of support
    {
        if (AUTOPILOT_MODE) { ; Automatically click continue
            ResetTimeOut()
            ClickSupportCert()
        } else {
            ImportantEventAlert("you have obtained a certificate of support")
            SetTimer, CheckCertificateNotice, 1000
        }
    }
return

;====================Check if the important event windows were closed====================;
; These subroutines are for FARMING HELPER, the MANUAL HELPER is at the bottom of this

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

CheckCertificateNotice:
    if !(Event.receivedCertificate())
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckCertificateNotice, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

ManualPlayChecks:
    ; Arrange the events from likely to the most unlikely for faster performance
    if (Event.battleComplete()) ; Battle is complete
    {
		ImportantEventAlert("your boatgrills have finished the battle")
		SetTimer, CheckBattleCompletion, 1000
    }
    else if (Event.partyAnnihilated()) ; Party was annihilated
    {
        ImportantEventAlert("the party was defeated")
        SetTimer, CheckDefeatedWindowM, 1000
    }
return

;===================================Manual Play Checks===================================;
CheckBattleCompletion:
    if !(Event.battleComplete()) ; Battle complete window is closed
    {
		Gui, EventAlert:Destroy
		SetTimer, CheckBattleCompletion, Off
		SetTimer, ManualPlayChecks, 1000
    }
return

CheckDefeatedWindowM:
    if !(Event.partyAnnihilated()) ; Fleet defeated window is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckDefeatedWindowM, Off
        SetTimer, ManualPlayChecks, 1000
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