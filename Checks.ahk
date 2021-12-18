global BATTLE_COMPLETE      := "|<TOUCH>*153$66.zzzDzzzyTzz01s1wS7k73k01k0wS7U33kU1k0QS7073kwDVsQS73z3kwDVwQS77z3kwDVwQS67z00wDXwQS67z00wDVwQS67z00wDVwQS77z3kwDVsQC73z3kwDkkQAD1X3kwDk0y0DU33kwDs1y0Tk33kwTy7zVzwDbtU"
, LEVEL_COMPLETE            := "|<Total>*174$59.zzzzzzzzzDzzzzzzzzwA01zzyTzzsM03zzsTzzkk07zzkzzzVU0DzzVzzz3w7y1w0S0y7sDk1s0k0wDkTU1k1U1sTUy31kTb1kzVwD3Uzy3Vz3kS71z073y7UwC3w0C7wD1sQ7kEQDsT3kwDVksTky31sS31kz1w07k603Uy3w0DUA071y7w1zUQ0D1zzzDzlyzza"
, DOCK_FULL                 := "|<expand>*174$61.zzzzzzzzzwTzzzzzzzzyDzzzzzzzzz7jzzxzrzrzX1lX0D0s1s10MFU30A0Q06C1kly66AA071ssw376C03kwQQ1XX70zkSCAMllXUDs726AMskV0MVU70AQQ0k8Mk3k6CC0TzzszzzzzzzzzwTzzzzzzzzyDzzzzzzzzzbzzzzzz"
, NEW_SHIP                  := "|<NEW>*142$69.zz0w0Ts1U007zk7U3z08000zy0w0Ts10007Xk7U3z08400kS0w0Ts00U003k7U3r004000C0w0Es00U001k7U07004010C0w00s01U080k7U0700A01060w00s01k080k7U0DU0C01020w07w01k080E7U3zU0C01000w0Tw01k0s007U3zU0T0z000w0Tw03sTs007U3zU0TTz000w0zw03zzs007U7nk0Tzz000w0ES0Dzzs007U03kDzzz000w00SDzzzs407U03zzzzz0U0w00Tzzzzw"
, PARTY_ANNIHILATED         := "|<Improve>*140$67.nzzzzzzzzzzUzzzzzzzzzzkTzzzzzzzzzs001U70UNwkA00000000Q02000000006010000M0ss00Q0000C0MQ0000000708C00080003067203w0000U3X101y000001k1UsPU0000Fw1sS0zzzw1zzrzzvzzzz7zzzzzzzzzzXzzzzzzzzzzlzzzzzzz"
, OIL_RANOUT                := "|<Oil>*150$21.zzbzXsNk7bA0TtXXb8Q8N7l38y8N3l3AQMNV3360wMsDb4"
, CERTIFICATE_OF_SUPPORT    := "|<Certifica>*172$69.zzzzzzbzbzzzzzzzzwS0Tzzs7zzz7XUXzzy0TzzsywTzzzUbvzq7z3zxzQTw340AEAQ30Xz0M21X1X0M0Tsl1kwMQMTw3y08T7XXX7y4Tk13swQQMz0Xy7sT7XXX7sY4Mz3swQQMT4k30MT1XXX0M70w33wAQQQ30U"
, LOW_MOOD                  := "|<Mood>*170$44.zzzzzzz0yDzzzzUD3zzzzs3kzzzzy0MD1y3s063UD0Q00Us1U7000AAMsVUEX76C8M48llXW612AAMkVUNXU60Q07sw3k708"
, LOW_MOOD_2                := "|<Exhaust>*165$66.UTzlzzzzzzz0DzlzzzzzzX0DzlzzzzzzX3wtk7kSCS300QFk1U6AA200C3lVy6AATX0S3lVk6AA7X7y3lVU6AC3X7y3lVW6ADVX0A1lV260AVV00ElVU60A3U00slXV72A3kU"

RetrieveEmuPos()
{
    ; Make sure to rename the Bluestacks emulator containing Azur Lane to "Azur Lane"
    WinGetPos, BLUESTACKS_X, BLUESTACKS_Y, BLUESTACKS_W, BLUESTACKS_H, Azur Lane
    
    ; Bluestacks' toolbar is a flat 40 (no matter the resolution), and it's not included in ControlClick's scope
    ; Exclude the emulator's toolbar in the dimensions
    BLUESTACKS_Y += 40, BLUESTACKS_H -= 40
    if (BLUESTACKS_X = "" || BLUESTACKS_X < 0) {
        Msgbox, 0, % " Azur Lane Helper: Monitoring error", % "Azur Lane seems to be out of bounds. Please make sure that it is COMPLETELY visible on the screen and recalibrate by restarting the monitoring status. " . "X: " X . " Y: " Y "." 
        exit
    }

    if (DEBUG_MODE) {
        Msgbox, 4, % " Azur Lane Helper", % "The position and dimensions of Bluestacks are:`n" "X: " BLUESTACKS_X "`nY: " BLUESTACKS_Y "`nW: " BLUESTACKS_W "`nH: " BLUESTACKS_H "`n`nIf these are correct, press YES; otherwise press NO and recalibrate by restarting the monitoring status."
        IfMsgBox, No
        exit
    }
}

class Event
{
    battleComplete()
    {   ; FindText(2081-150000, 474-150000, 2081+150000, 474+150000, 0, 0, BATTLE_COMPLETE)
        return this.findImg(BATTLE_COMPLETE, 3)
    }

    levelComplete()
    {   ; FindText(2197, 95, 2259, 117, 0, 0, LEVEL_COMPLETE)
        return this.findImg(LEVEL_COMPLETE, 2)
    }

    newShip()
    {   ; FindText(2075, 89, 2153, 123, 0, 0, NEW_SHIP)
        return this.findImg(NEW_SHIP, 2, 0.15, 0.15)
    }

    dockFull()
    {   ; FindText(2358, 268, 2422, 290, 0, 0, DOCK_FULL)
        return this.findImg(DOCK_FULL, 0)
    }

    partyAnnihilated()
    {   ; FindText(2191, 124, 2309, 184, 0, 0, PARTY_ANNIHILATED)
        return this.findImg(PARTY_ANNIHILATED, 2)
    }

    oilDepleted()
    {   
        ; Since no one buys oil, this function wont be able to distinguish between intentionally buying oil and running out of oil while sortieing
        ; FindText(2297, 216, 2331, 238, 0, 0, OIL_RANOUT)
        return this.findImg(OIL_RANOUT, 0)
    }

    receivedCertificate()
    {
        return this.findImg(CERTIFICATE_OF_SUPPORT, 0)
    }

    lowMood()
    {
        if (this.findImg(LOW_MOOD, 0))
            return 1
        else
            return this.findImg(LOW_MOOD_2, 0)
    }

    findImg(Image, Region := 0, errTol1 := 0, errTol2 := 0)
    {
        ;	FindText(
        ;      X1 --> the search scope's upper left corner X coordinates
        ;    , Y1 --> the search scope's upper left corner Y coordinates
        ;    , X2 --> the search scope's lower right corner X coordinates
        ;    , Y2 --> the search scope's lower right corner Y coordinates
        ;    , err1 --> Fault tolerance percentage of text       (0.1=10%)
        ;    , err0 --> Fault tolerance percentage of background (0.1=10%)
        ;    , Text --> can be a lot of text parsed into images, separated by "|"
        ;    , ScreenShot --> if the value is 0, the last screenshot will be used
        ;    , FindAll --> if the value is 0, Just find one result and return
        ;    , JoinText --> if the value is 1, Join all Text for combination lookup
        ;    , offsetX --> Set the max text offset (X) for combination lookup
        ;    , offsetY --> Set the max text offset (Y) for combination lookup
        ;    , dir --> Nine directions for searching: up, down, left, right and center
        ;	)

        ; Region -1 is the whole Bluestacks screen
        ; Region 0 is 1/9 center
        ; For R1-R4, follow the Cartesian Plane quadrants
        ; Region 5 is the upper half,
        ; Region 6 is the lower half
        switch Region
        {
            case -1:
                return FindText(BLUESTACKS_X, BLUESTACKS_Y, BLUESTACKS_X+BLUESTACKS_W, BLUESTACKS_Y+BLUESTACKS_H, errTol1, errTol2, Image)
            case 0:
                return FindText(BLUESTACKS_X+(BLUESTACKS_W//3), BLUESTACKS_Y+(BLUESTACKS_H//3), BLUESTACKS_X+((2*BLUESTACKS_W)//3), BLUESTACKS_Y+((2*BLUESTACKS_H)//3), errTol1, errTol2, Image)
            case 1:
                return FindText(BLUESTACKS_X+(BLUESTACKS_W//2), BLUESTACKS_Y, BLUESTACKS_X+BLUESTACKS_W, BLUESTACKS_Y+(BLUESTACKS_H//2), errTol1, errTol2, Image)
            case 2:
                return FindText(BLUESTACKS_X, BLUESTACKS_Y, BLUESTACKS_X+(BLUESTACKS_W//2), BLUESTACKS_Y+(BLUESTACKS_H//2), errTol1, errTol2, Image)
            case 3:
                return FindText(BLUESTACKS_X, BLUESTACKS_Y+(BLUESTACKS_H//2), BLUESTACKS_X+(BLUESTACKS_W//2), BLUESTACKS_Y+BLUESTACKS_H, errTol1, errTol2, Image)
            case 4:
                return FindText(BLUESTACKS_X+(BLUESTACKS_W//2), BLUESTACKS_Y+(BLUESTACKS_H//2), BLUESTACKS_X+BLUESTACKS_W, BLUESTACKS_Y+BLUESTACKS_H, errTol1, errTol2, Image)
            case 5:
                return FindText(BLUESTACKS_X, BLUESTACKS_Y, BLUESTACKS_X+BLUESTACKS_W, BLUESTACKS_Y+(BLUESTACKS_H//2), errTol1, errTol2, Image)
            case 6:
                return FindText(BLUESTACKS_X, BLUESTACKS_Y+(BLUESTACKS_H//2), BLUESTACKS_X+BLUESTACKS_W, BLUESTACKS_Y+BLUESTACKS_H, errTol1, errTol2, Image)
            default:
                Msgbox, 0, % " Azur Lane Helper: Monitoring error", % "Region chosen is out of bounds."
        }
    }
}