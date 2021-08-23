Assets := A_Temp . "\AzurLaneAutoHelper"

; FileInstall won't work if the folder doesn't exist already
if !FileExist("%A_Temp%\AzurLaneAutoHelper")
    FileCreateDir, %Assets%

if !FileExist("%A_Temp%\AzurLaneAutoHelper\enty.png")
    FileInstall, Assets\enty.png, %Assets%\enty.png, 1

; This OnExit function will delete temporary files once the script is closed
OnExit("ClearAssets")

ClearAssets()
{
    FileRemoveDir, %Assets%, 1
}