ClickSupportCert()
{
    ; https://www.autohotkey.com/boards/viewtopic.php?f=7&t=33596
    ; ctrl + f: "click without moving the cursor"
    
    ; clickX and clickY values were retrieved with experimental methods using proportions  
    clickX := "x" . (BLUESTACKS_W//3)
    , clickY := "y" . ( (BLUESTACKS_H)*7 )//10

    emuHwnd := DllCall("user32\WindowFromPoint", "UInt64", (BLUESTACKS_X+100 & 0xFFFFFFFF)|(BLUESTACKS_Y+100 << 32), "Ptr")
            
    ControlClick,, % "ahk_id " emuHwnd,,,, NA %clickX% %clickY%
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