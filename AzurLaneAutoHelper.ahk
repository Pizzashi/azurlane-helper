;====================Compiler directives====================;
;@Ahk2Exe-SetName Azur Lane Auto Helper
;@Ahk2Exe-SetMainIcon Main.ico
;@Ahk2Exe-AddResource Main.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource Main.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource Main.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource Main.ico, 208  ; Replaces 'S on red'
;@Ahk2Exe-SetCopyright Copyright @ Baconfry 2021
;@Ahk2Exe-SetVersion 0.2.0.0
;===========================================================;

#NoEnv                                          ; Needed for blazing fast performance
#SingleInstance, Force                          ; Allows only one instance of the script to run
SendMode Input                                  ; Superior speed and reliability for triggers
SetWorkingDir %A_ScriptDir%                     ; Needed by some functions to work properly
ListLines Off                                   ; Turns off logging script actions for improved performance
#KeyHistory 0                                   ; Turns off loggins keystrokes for improved performance

#Include FindText.ahk
#Include Assets.ahk
#Include GUI.ahk

helperActive := 0
, bannerComplete := "|<Total Rewards>*181$69.zzzzzzzy7zzs07zz7zzkzk000zzszzy7y0007zz7zzkzk0wDwDU7ky7y7bVy0w0k3kzkwwDU3U60C7y7bVsAC7vVkzkswT3Vkzy67y07VsSC7w0kzk0wD3lky067y07VsSC7kkkzkkwD3VkwC67y77Vw0C2UUkTkswDU3s6073y7bVy0zUk0sTkwzzyzzTzzrzzw"
, dockFullWarn := "|<Sort or expand>*174$69.zzzzbzzzzzzzzzzwzzzzzzzUsC11z3mDktU60k8DkC3w347l67bwMlz6Q0AQFwzX6Ds3VUXWDbwMlz0QD4QlwzX6DszUAk6DXw0lz2sU71lw7kCDw3AXwTDlzbnzsto"
, newBoat := "|<New boat>*137$71.zzy1k3y0E007zsw3U7y0UU0Dy1s70Dw1100zs3kC0Qs2201jk3UQ01k4403TU70s03U0807z0C1k0700E0Dy0A3U0C01k0Tw0M700Q03U0zs0kC07s0701jk0UQ0zs0C07TU00s1zk0Q0Sz001k3zU0s7xy003U7z01tzXw0070Dy07zs7s00C0TQ0DC0Dk00Q0ks0yE0TU00s01kDwU0z001k03lzk01y103U07zzU03w20700Dzz047s60C01zzy08DkA0Q0DzzsUETUM0s3zzzl1Uz0s1kzzzzU31"

TimeOutTick(trigger)
{
    if (trigger = "start")
        SetTimer, TimeOut, -1800000 ; Timeout after 30 minutes
    else if (trigger = "stop")
        SetTimer, TimeOut, Off
}

; Check for events that require prompts every three seconds
; Switch is Shift + F12
+F12::
    if (helperActive == 1) {
        helperActive := 0
        AlertShikikan("monitoring is now off", true)
        SetTimer, ImportantEventsCheck, Off
    } else {
        helperActive := 1
        AlertShikikan("monitoring is now active", true)
        SetTimer, ImportantEventsCheck, 1000
        TimeOutTick("start")
    }
return

ImportantEventsCheck:
    levelIsComplete := FindText(2212, 86, 2290, 112, 0, 0, bannerComplete)
    dockIsFull := FindText(2305, 242, 2389, 266, 0, 0, dockFullWarn)
    foundBoat := FindText(2100, 85, 2176, 115, 0, 0, newBoat)

    if (levelIsComplete) {
        TimeOutTick("stop")
        AlertShikikan("your boatgrills have finished the level they're farming")
        TimeOutTick("start")
        SetTimer, ImportantEventsCheck, Off
        SetTimer, CheckLevelCompletion, 1000
    }
    else if (dockIsFull) {
        TimeOutTick("stop")
        AlertShikikan("your dock is full")
        TimeOutTick("start")
        SetTimer, ImportantEventsCheck, Off
        SetTimer, CheckDockSpace, 1000
    }
    else if (foundBoat) {
        TimeOutTick("stop")
        AlertShikikan("you have found a new boatgrill")
        TimeOutTick("start")
        SetTimer, ImportantEventsCheck, Off
        SetTimer, CheckBoatGrill, 1000
    }
return

CheckLevelCompletion:
    levelIsComplete := FindText(2212, 86, 2290, 112, 0, 0, bannerComplete)
    if (levelIsComplete = 0)
    {
        FadeOut()
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckDockSpace:
    dockIsFull := FindText(2305, 242, 2389, 266, 0, 0, dockFullWarn)
    if (dockIsFull = 0)
    {
        FadeOut()
        SetTimer, ImportantEventsCheck, 1000
    }
return

CheckBoatGrill:
    foundBoat := FindText(2100, 85, 2176, 115, 0, 0, newBoat)
    if (foundBoat = 0)
    {
        FadeOut()
        SetTimer, ImportantEventsCheck, 1000
    }
return

TimeOut:
    AlertShikikan("it looks like you're not farming. I'll stop monitoring to save resources", true)
    SetTimer, ImportantEventsCheck, Off
return