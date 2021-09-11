global LEVEL_COMPLETE := "|<Total>*178$60.k07zzzzzz3U07zzlzzz3U07zzVzzz3U07zzVzzz3z3zVz0Dkz3z3y0S0C0D3z3w0C0C073z3w460CA73z3sC7Vzy73z3sS3Vzs73z3sT3Vz073z3sT3Vy073z3sS3VwC73z3sC7VwC73z3w07Uw471z3w0DUA07Uz3y0TkC07Uz3zUzsD37kU"
, DOCK_FULL := "|<expand>*175$61.zzzzzzzzzyTzzzzzzzzyDzzzzzzzzz7zzzzzzzzzXVllYDUwlw1UQFk3UC0Q0X68sFn70CAHXUwMTXX7601kyCC0ln700sT760MtXWDs7X2AAQsl2QFk306CQ0kAMs3k37C0QCCA3wHXblDzzyDzzzzzzzzz7zzzzzzzzzXzzzzzz"
, NEW_SHIP := "|<NEW>*132$69.zk707y0M000yy0s0zk3000D7k707y00801sS0s0zk0100D3k707700801sS0s00s01U0D1k700700A01sC0s00s01U0C1k700700A01k60s01s03U0S0k700T00Q03k20s0Ts03U0S0E707z00S03k00s0zw03k3y00707zU0S1zU00s0zw03lzk00707zU0Tzk000s0yw03zs0007077U0wM0000s00w0za00007007Uzwk0000s00yTza00407007zzwU00U0s00zzz40040700DzzsU04"
, PARTY_ANNIHILATED := "|<Improve>*142$66.3zzzzzzzzzz3zzzzzzzzzz1zzzzzzzzzz00000E017U1000000007010000Q0Uk70sU000Q1ls01wU000M1ls0000000M1ls08T0000M1lsE8z000001k0kMTU0000Fs1kw1zjzU3nw7ty3zzzwzzzzzzzzzzwzzzzzzzzzzwzzzzzzzzzzxzzzzzzzU"
, OIL_RANOUTP1 := "|<Oil>*157$21.zz6C1slU7i8MTl7X68wMl7X68wMl7X68wMlU76C1skwzzg"
, OIL_RANOUTP2 := "|<You need>*171$62.CTzzzzzzzy37zzzzzzzzUHVlbs7VsC0YkANy0kA308Mn6TaAnAFX6AFbtW0k4MlX4NyMUA36AMn4TaAzDlX70k7tX0kC0lsS9yMsD3UM"
, IS_MONITORING := false
, AUTOPILOT_MODE := false
, NOTIFY_EVENTS := false

class Event
{
    levelComplete()
    {
        return FindText(2197, 95, 2259, 117, 0, 0, LEVEL_COMPLETE)
    }

    newShip()
    {
        return FindText(2075, 89, 2153, 123, 0, 0, NEW_SHIP)
    }

    dockFull()
    {
        return FindText(2358, 268, 2422, 290, 0, 0, DOCK_FULL)
    }

    partyAnnihilated()
    {
        return FindText(2191, 124, 2309, 184, 0, 0, PARTY_ANNIHILATED)
    }

    oilDepleted()
    {   
        ; Checks for "Oil" keyword header,
        ; which will be verified by a second check whether the user is intentionally buying or has ran out
        if (FindText(2297, 216, 2331, 238, 0, 0, OIL_RANOUTP1)) {
            return FindText(2303, 265, 2369, 281, 0, 0, OIL_RANOUTP2) ; Checks for "You need" keyword
        } else {
            return 0
        }
    }
}