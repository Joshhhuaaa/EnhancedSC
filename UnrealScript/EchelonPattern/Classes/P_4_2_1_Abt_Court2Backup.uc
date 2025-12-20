//=============================================================================
// P_4_2_1_Abt_Court2Backup
//=============================================================================
class P_4_2_1_Abt_Court2Backup extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;
var int pass2;
var int SpetzOnOff;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Start');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EGeorgianSoldier10')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier13')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz5')
            Characters[3] = P.controller;
        if (P.name == 'EGeorgianSoldier11')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    pass2=0;
    SpetzOnOff=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
TowerGuard:
    Log("");
    CheckFlags(pass1,TRUE,'BalconyGuard');
    CheckIfIsDead(1,'TelepTower');
    CheckIfIsUnconscious(1,'TelepTower');
    Jump('BalconyGuard');
BalconyGuard:
    Log("");
    CheckFlags(pass2,TRUE,'JumpFin');
    CheckIfIsDead(2,'TelepBalcony');
    CheckIfIsUnconscious(2,'TelepBalcony');
JumpFin:
    Log("");
    CheckFlags(pass1,TRUE,'AlarmTower');
A2:
    CheckFlags(pass2,TRUE,'AlarmBalcony');
End:
    End();
AlarmTower:
    Log("");
    SendPatternEvent('ALStage','AlarmStageOFF');
    Sleep(0.5);
    StartAlarm('EAlarm3',1);
    SendPatternEvent('ALStage','AlarmStageON');
    Jump('A2');
AlarmBalcony:
    Log("");
    SendPatternEvent('ALStage','AlarmStageOFF');
    Sleep(0.5);
    StartAlarm('EAlarm1',1);
    SendPatternEvent('ALStage','AlarmStageON');
    Jump('End');
TelepTower:
    Log("");
    CheckFlags(SpetzOnOff,FALSE,'BalconyGuard');
    SetFlags(pass1,TRUE);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).TowerTeleported,TRUE,'SkipTeleport');
    SetFlags(V4_2_1_Abattoir(Level.VarObject).TowerTeleported,TRUE);
    Teleport(3, 'PathNode232');
SkipTeleport:
    Log("He has already been teleported, so it won't happen twice.");
    SendPatternEvent('EGroupAI34','Start');
    Jump('BalconyGuard');
TelepBalcony:
    Log("");
    SetFlags(pass2,TRUE);
    Teleport(4, 'PathNode83');
    Jump('JumpFin');
SpetzTowerOFF:
    Log("");
    SetFlags(SpetzOnOff,FALSE);
    End();
SpetzTowerON:
    Log("");
    SetFlags(SpetzOnOff,TRUE);
    End();
CantSpawn:
    Log("dont make guard two on far balcony spawn anymore");
    SetFlags(pass2,TRUE);
    End();
RemoveLiveOnes:
    Log("Removing any living guards on this balcony");
    CheckIfIsDead(4,'DoNothing');
    CheckIfIsUnconscious(4,'DoNothing');
    Teleport(4, 'BalcGuardTwoOut');
    KillNPC(4, FALSE, TRUE);
    CheckIfIsDead(2,'DoNothing');
    CheckIfIsUnconscious(2,'DoNothing');
    Teleport(2, 'BalcGuardOneOut');
    KillNPC(2, FALSE, TRUE);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

