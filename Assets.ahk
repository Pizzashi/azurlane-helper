Assets := A_Temp . "\AzurLaneAutoHelper"

; FileInstall won't work if the folder doesn't exist already
if !FileExist("%A_Temp%\AzurLaneAutoHelper")
    FileCreateDir, %Assets%

if !FileExist("%A_Temp%\AzurLaneAutoHelper\belfast.png")
    FileInstall, Assets\belfast.png, %Assets%\belfast.png, 1

; This OnExit function will delete temporary files once the script is closed
OnExit("ClearAssets")

ClearAssets()
{
    Global
    FileRemoveDir, %Assets%, 1
}