//=============================================================================
// P_1_3_3OilRig_Blindside
//=============================================================================
class P_1_3_3OilRig_Blindside extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Blinded;
var int Hub;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Exclu');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Exclu');
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
    }

    if (!bInit)
    {
    bInit=TRUE;
    Blinded=0;
    Hub=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Blind:
    Log("Guard blindside, now a shell of what it once was.");
    CheckFlags(Hub,FALSE,'Nada');
    CheckFlags(Blinded,TRUE,'Nada');
    SetFlags(Blinded,TRUE);
    ChangeState(1,'s_investigate');
    SendUnrealEvent('TopOfRigEnableZoneAI');
    SendUnrealEvent('MachiDistractDisableZoneAI');
    SendPatternEvent('TopDudes','GoodEyeClosed');
    SendUnrealEvent('BlindsideDeathSound');
    ShakeCamera(800, 20000, 4000);
    KillNPC(1, FALSE, FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'hubpoint2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
Hub:
    Log("Pattern now active, hub door 2 open.");
    SetFlags(Hub,TRUE);
Nada:
    End();
Comm:
    Log("Initial map routine, inserted here to stop the bad bad mojo.");
    Sleep(0.01);
    IgnoreAlarmStage(TRUE);
    GoalCompleted('1_3_1');
    SendUnrealEvent('MovingTarget1');
    SendUnrealEvent('Spout');
    End();
Exclu:
    Log("Resets Blindside exclusivity.");
    SetExclusivity(FALSE);
    End();
EarlyChop:
    Log("Blindside guy now knows.  Oh yes, he knows.");
    SetExclusivity(FALSE);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_GroupScatter;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,3,,,);
    End();

}

