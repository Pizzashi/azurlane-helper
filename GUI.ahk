AlertShikikan(message, autoDestruct := false, pushNotifications := true, notifyPhoneOnly := true)
{
    Global
    
    ; If push notifications for phone were turned on
    if (NOTIFY_EVENTS && pushNotifications) {
        NotificationPush("Shikikan, " . message ".")
        if (notifyPhoneOnly)
            return
    }

    enterpriseAvatar := Assets . "\enty.png"

    Gui, EventAlert:Destroy
	Gui, EventAlert:New, +ToolWindow -Caption +AlwaysOnTop +HwndEventNotif
    Gui, EventAlert:Color, 999999
    Gui, EventAlert:Margin, 15, 10
	Gui, EventAlert:Font, s14, Segoe UI
    Gui, EventAlert:Add, Picture, h50 w-1, % enterpriseAvatar
	Gui, EventAlert:Add, Text, x+10 cWhite yp+11 Center, % "Shikikan, " message "."
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
}