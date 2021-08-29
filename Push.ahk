NotificationPush(pushMessage, testMode := false)
{
   receivingDevices := "Baconfry" ; Use "Baconfry,Fartphone,OtherPhoneName" for multiple devices
   ; In the AuthKey.lic file, do:
   ; keyApi := [key for api]
   ; e.g. keyApi := 0123456789101112131415
   #Include AuthKey.lic
   if (testMode) {
      ; Check if AuthKey was properly set up
      if (keyApi = "INSERT_KEY_HERE" || keyApi = "") {
         Msgbox, 0, % "Fatal Error", % "Please set the authentication key correctly."
         ExitApp
      } else {
         return
      }
   }

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
   try {
      oPushRequest.send()
   } catch errorCode {
      Msgbox, 0, % "Error", % "I can't seem to reach the server to send push notifications. Please make sure the Helper can access the Internet."
   }
}

NotificationPush("Testing the validity of your authentication key...", true) ; Test if there's a proper authentication key

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