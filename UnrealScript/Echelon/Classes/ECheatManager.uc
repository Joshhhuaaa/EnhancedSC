class ECheatManager extends CheatManager;

exec function ChangeSize(float F)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.ChangeSize(F);
}

exec function CauseEvent(name EventName)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.CauseEvent(EventName);
}

exec function Fly()
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.Fly();
}

exec function Walk()
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.Walk();
}

exec function ToggleGhost()
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.ToggleGhost();
}

exec function Ghost()
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.Ghost();
}

exec function Invisible(bool B)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.Invisible(B);
}

exec function Avatar(string ClassName)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.Avatar(ClassName);
}

exec function Summon(string ClassName)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.Summon(ClassName);
}

exec function PlayersOnly()
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.PlayersOnly();
}

exec function CheatView(class<actor> aClass, optional bool bQuiet)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.CheatView(aClass, bQuiet);
}

exec function ViewSelf(optional bool bQuiet)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.ViewSelf(bQuiet);
}

exec function ViewClass(class<actor> aClass, optional bool bQuiet, optional bool bCheat)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.ViewClass(aClass, bQuiet, bCheat);
}

exec function ViewClassRadii(class<actor> aClass)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.ViewClassRadii(aClass);
}

exec function ShowActor(name InName)
{
    EPlayerController(Outer).PlayerStats.bCheatsActive = true;
    Super.ShowActor(InName);
}
