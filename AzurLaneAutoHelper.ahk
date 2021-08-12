;====================Compiler directives====================;
;@Ahk2Exe-SetName Azur Lane Auto Helper
;@Ahk2Exe-SetMainIcon Main.ico
;@Ahk2Exe-AddResource Main.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource Main.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource Main.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource Main.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetCopyright Copyright @ Baconfry 2021
;@Ahk2Exe-SetCompanyName Furaico
;@Ahk2Exe-SetVersion 0.3.1.0
;===========================================================;

#NoEnv                                          ; Needed for blazing fast performance
#SingleInstance, Force                          ; Allows only one instance of the script to run
SetWorkingDir %A_ScriptDir%                     ; Needed by some functions to work properly
; This code appears only in the compiled script
/*@Ahk2Exe-Keep
ListLines Off                                   ; Turns off logging script actions for improved performance
#KeyHistory 0                                   ; Turns off loggins keystrokes for improved performance
*/

global APP_VERSION := "Azur Lane Auto Helper v0.3.1.0"
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
#Include Assets.ahk
#Include GUI.ahk

global LEVEL_COMPLETE := "|<>*181$69.zzzzzzzy7zzs07zz7zzkzk000zzszzy7y0007zz7zzkzk0wDwDU7ky7y7bVy0w0k3kzkwwDU3U60C7y7bVsAC7vVkzkswT3Vkzy67y07VsSC7w0kzk0wD3lky067y07VsSC7kkkzkkwD3VkwC67y77Vw0C2UUkTkswDU3s6073y7bVy0zUk0sTkwzzyzzTzzrzzw"
, DOCK_FULL := "|<>*174$69.zzzzbzzzzzzzzzzwzzzzzzzUsC11z3mDktU60k8DkC3w347l67bwMlz6Q0AQFwzX6Ds3VUXWDbwMlz0QD4QlwzX6DszUAk6DXw0lz2sU71lw7kCDw3AXwTDlzbnzsto"
, NEW_SHIP := "|<>*137$71.zzy1k3y0E007zsw3U7y0UU0Dy1s70Dw1100zs3kC0Qs2201jk3UQ01k4403TU70s03U0807z0C1k0700E0Dy0A3U0C01k0Tw0M700Q03U0zs0kC07s0701jk0UQ0zs0C07TU00s1zk0Q0Sz001k3zU0s7xy003U7z01tzXw0070Dy07zs7s00C0TQ0DC0Dk00Q0ks0yE0TU00s01kDwU0z001k03lzk01y103U07zzU03w20700Dzz047s60C01zzy08DkA0Q0DzzsUETUM0s3zzzl1Uz0s1kzzzzU31"
, PARTY_ANNIHILATED := "|<>*164$67.ySnrkr/ST30jDNvkPBjD9UH3gRtxCrbjw9Zq6wSDPnny5qPPT77htwSHkBgDsVqwzaNM6r7yIvSTvzVtPnn/BjDNzkwhtsBmk01U4"
, IS_MONITORING := false
, AUTOPILOT_MODE := false
; Add ran out of oil case

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
    if (FindText(2212, 86, 2290, 112, 0, 0, LEVEL_COMPLETE)) ; Level is complete
    {
        if (AUTOPILOT_MODE) { ; Automatically click continue
        CoordMode, Mouse, Screen
        MouseGetPos, prevCurX, prevCurY	; Previous mouse position
        MouseClick, Left, 2508, 425, 1, 0
        MouseMove, prevCurX, prevCurY
        } else {
            ImportantEventAlert("your boatgrills have finished the level they're farming")
            SetTimer, CheckLevelCompletion, 1000
        }
    }
    else if (FindText(2305, 242, 2389, 266, 0, 0, DOCK_FULL)) ; Dock is full
    {
        ImportantEventAlert("your dock is full")
        SetTimer, CheckDockSpace, 1000
    }
    else if (FindText(2100, 85, 2176, 115, 0, 0, NEW_SHIP)) ; Found new boatgrill
    {
        ImportantEventAlert("you have found a new boatgrill")
        SetTimer, CheckBoatGrill, 1000
    }
    else if (FindText(2422, 300, 2522, 338, 0, 0, PARTY_ANNIHILATED)) ; Party was annihilated
    {
        ImportantEventAlert("the farming party was defeated")
        SetTimer, CheckDefeatedWindow, 1000
    }
return

;====================Check if the important event windows were closed====================;

CheckLevelCompletion:
    if !(FindText(2212, 86, 2290, 112, 0, 0, LEVEL_COMPLETE)) ; Complete banner is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckLevelCompletion, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckDockSpace:
    if !(FindText(2305, 242, 2389, 266, 0, 0, DOCK_FULL)) ; Dock is full warning is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckDockSpace, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckBoatGrill:
    if !(FindText(2100, 85, 2176, 115, 0, 0, NEW_SHIP)) ; New boatgrill window is closed
    {
        Gui, EventAlert:Destroy
        SetTimer, CheckBoatGrill, Off
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckDefeatedWindow:
    if !(FindText(2422, 300, 2522, 338, 0, 0, PARTY_ANNIHILATED)) ; Fleet defeated window is closed
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