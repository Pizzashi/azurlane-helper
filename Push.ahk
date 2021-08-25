NotificationPush(pushMessage)
{
    receivingDevices := "Baconfry" ; Use "Baconfry,Fartphone,OtherPhoneName" for multiple devices
    ; In the AuthKey file, do:
    ; keyApi := [key for api]
    ; e.g. keyApi := 0123456789101112131415
    #Include AuthKey
    notifIcon := "https://i.ibb.co/7yz04fv/L4egc3-U-252525255-B1-252525255-D.png"
    notifTitle := "Azur Lane Helper"
    notifMessage := pushMessage

    notificationCode := "https://joinjoaomgcd.appspot.com/_ah/api/messaging/v1/sendPush?"
                        . "apikey=" . keyApi
                        . "&deviceNames=" . receivingDevices
                        . "&text=" . UrlEncode(notifMessage)
                        . "&title=" . UrlEncode(notifTitle)
                        . "&icon=" . UrlEncode(notifIcon)
                        . "&smallicon=" . UrlEncode(notifIcon)                  
                        
    oPushRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    oPushRequest.open("GET", notificationCode)
    oPushRequest.send()
}

; https://www.autohotkey.com/boards/viewtopic.php?p=372134&sid=6ccacfcfd2eb820d173a4a1abc6e9238#p372134
UrlEncode(str, encode := true, component := true) {
   static Doc, JS
   if !Doc {
      Doc := ComObjCreate("htmlfile")
      Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
      JS := Doc.parentWindow
      ( Doc.documentMode < 9 && JS.execScript() )
   }
   Return JS[ (encode ? "en" : "de") . "codeURI" . (component ? "Component" : "") ](str)
}