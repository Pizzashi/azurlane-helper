global LEVEL_COMPLETE := "|<Total>*174$59.zzzzzzzzzDzzzzzzzzwA01zzyTzzsM03zzsTzzkk07zzkzzzVU0DzzVzzz3w7y1w0S0y7sDk1s0k0wDkTU1k1U1sTUy31kTb1kzVwD3Uzy3Vz3kS71z073y7UwC3w0C7wD1sQ7kEQDsT3kwDVksTky31sS31kz1w07k603Uy3w0DUA071y7w1zUQ0D1zzzDzlyzza"
, DOCK_FULL := "|<expand>*174$61.zzzzzzzzzwTzzzzzzzzyDzzzzzzzzz7jzzxzrzrzX1lX0D0s1s10MFU30A0Q06C1kly66AA071ssw376C03kwQQ1XX70zkSCAMllXUDs726AMskV0MVU70AQQ0k8Mk3k6CC0TzzszzzzzzzzzwTzzzzzzzzyDzzzzzzzzzbzzzzzz"
, NEW_SHIP := "|<NEW>*132$69.zk707y0M000yy0s0zk3000D7k707y00801sS0s0zk0100D3k707700801sS0s00s01U0D1k700700A01sC0s00s01U0C1k700700A01k60s01s03U0S0k700T00Q03k20s0Ts03U0S0E707z00S03k00s0zw03k3y00707zU0S1zU00s0zw03lzk00707zU0Tzk000s0yw03zs0007077U0wM0000s00w0za00007007Uzwk0000s00yTza00407007zzwU00U0s00zzz40040700DzzsU04"
, PARTY_ANNIHILATED := "|<Improve>*140$67.nzzzzzzzzzzUzzzzzzzzzzkTzzzzzzzzzs001U70UNwkA00000000Q02000000006010000M0ss00Q0000C0MQ0000000708C00080003067203w0000U3X101y000001k1UsPU0000Fw1sS0zzzw1zzrzzvzzzz7zzzzzzzzzzXzzzzzzzzzzlzzzzzzz"
, OIL_RANOUT := "|<Oil>*150$21.zzbzXsNk7bA0TtXXb8Q8N7l38y8N3l3AQMNV3360wMsDb4"
, IS_MONITORING := false
, AUTOPILOT_MODE := false
, NOTIFY_EVENTS := false
, BLUESTACKS_X := ""
, BLUESTACKS_Y := ""
, BLUESTACKS_W := ""
, BLUESTACKS_H := ""

class Event
{
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
        ; Since no one buys oil, this function wont be able to distinguish between intentionally buying oil
        ; , and ran out of oil while sortieing
        ; FindText(2297, 216, 2331, 238, 0, 0, OIL_RANOUT)
        return this.findImg(OIL_RANOUT, 0)
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