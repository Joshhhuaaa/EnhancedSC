class ECheatManager extends CheatManager within EPlayerController;

exec function ChangeSize(float F)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.ChangeSize(F);
}

exec function CauseEvent(name EventName)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.CauseEvent(EventName);
}

exec function Fly()
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.Fly();
}

exec function Walk()
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.Walk();
}

exec function ToggleGhost()
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.ToggleGhost();
}

exec function Ghost()
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.Ghost();
}

exec function Invisible(bool B)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.Invisible(B);
}

exec function Avatar(string ClassName)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.Avatar(ClassName);
}

exec function Summon(string ClassName)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.Summon(ClassName);
}

exec function PlayersOnly()
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.PlayersOnly();
}

exec function CheatView(class<actor> aClass, optional bool bQuiet)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.CheatView(aClass, bQuiet);
}

exec function ViewSelf(optional bool bQuiet)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.ViewSelf(bQuiet);
}

exec function ViewClass(class<actor> aClass, optional bool bQuiet, optional bool bCheat)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.ViewClass(aClass, bQuiet, bCheat);
}

exec function ViewClassRadii(class<actor> aClass)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.ViewClassRadii(aClass);
}

exec function ShowActor(name InName)
{
    Outer.PlayerStats.bCheatsActive = true;
    Super.ShowActor(InName);
}
