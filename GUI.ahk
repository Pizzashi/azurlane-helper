AlertShikikan(message, autoDestruct := false, pushNotifications := true, notifyPhoneOnly := true)
{
    Global
    
    ; If push notifications for phone were turned on
    if (NOTIFY_EVENTS && pushNotifications) {
        NotificationPush(message)
        if (notifyPhoneOnly)
            return
    }

    assistantAvatar := Assets . "\saratoga.png"

    Gui, EventAlert:Destroy
	Gui, EventAlert:New, +ToolWindow -Caption +AlwaysOnTop +HwndEventNotif
    Gui, EventAlert:Color, c1a5c3 ; Original color is 999999
    Gui, EventAlert:Margin, 15, 10
	Gui, EventAlert:Font, s14, Segoe UI
    Gui, EventAlert:Add, Picture, h50 w-1, % assistantAvatar
	Gui, EventAlert:Add, Text, x+10 cWhite yp+11 Center, % message
	Gui, EventAlert:Show, y20 x20 NoActivate

    OnMessage(0x201, "FadeOut")

    if (autoDestruct) {
        ; Wait two seconds before clearing the notif
        Sleep, 2000
        FadeOut()
    }
}

FadeOut()
{
    Global
    ; This is a fadeout animation that lasts for 300 ms
    DllCall("AnimateWindow", "UInt", EventNotif, "Int", 300, "UInt", 0x90000)
    Gui, EventAlert:Destroy
}

; For helperActive, 0 indicates OFF and 1 indicates ON
EmuMark(helperActive := 1)
{
    Global

    if !(helperActive)
    {
        Gui, Marker:Destroy
        return
    }
    else if (helperActive)
    {
        if (IS_MONITORING)
            local BarColor := "Lime"
        else if (MANUAL_PLAY)
            local BarColor := "Yellow"
        
        local autopilotIndicator := Assets . "\plane.png"
        local pushnotifsIndicator := Assets . "\phone.png"

        ; For some really weird reason, the height and width used by Gui() are 4/5 of the values obtained in WinGetPos
        ; Although x and y values are correct
        ; Allowance of 32 pixels is to be given for the sidebar
        ; BUT for some reason, FindText() uses the original values. What the hell?
        ; TO-DO: Add some option to disable allowance, IMPORTANT: Investigate this case. Or not.
        local guiW := Floor(BLUESTACKS_W*4/5-32)
        , guiH := Floor(BLUESTACKS_H*4/5)
        , bottomY := (guiH-3)
        , rightX := (guiW-3)

        Gui, Marker:New, +ToolWindow -Caption +AlwaysOnTop +LastFound
        Gui, Marker:Color, Black
        Gui, Marker:Add, Progress, % "x0 y0 h3 " "Background"BarColor " w"guiW              ; Top bar
        Gui, Marker:Add, Progress, % "x0 y0 w3 " "Background"BarColor " h"guiH              ; Left bar
        Gui, Marker:Add, Progress, % "y0 w3 "    "Background"BarColor " h"guiH " x"rightX   ; Right bar
        Gui, Marker:Add, Progress, % "x0 h3 "    "Background"BarColor " w"guiW " y"bottomY  ; Bottom bar

        /* 
        TO-DO: Implement this next patch
        if (AUTOPILOT_MODE) {
            Gui, Marker: Add, Picture, w25 h25 xp+10 y10 Background, % autopilotIndicator
        }
        if (NOTIFY_EVENTS) {
            Gui, Marker: Add, Picture, w25 h25 x+10 y10 Background, % pushnotifsIndicator
        }
        */

        WinSet, TransColor, Black 150
        Gui, Marker:Show, NoActivate x%BLUESTACKS_X% y%BLUESTACKS_Y% w%BLUESTACKS_W% h%BLUESTACKS_H%
    }
}