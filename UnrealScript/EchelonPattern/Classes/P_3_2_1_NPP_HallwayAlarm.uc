//=============================================================================
// P_3_2_1_NPP_HallwayAlarm
//=============================================================================
class P_3_2_1_NPP_HallwayAlarm extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Meltdown;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Intruder');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Exclu');
            break;
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
        if (P.name == 'EFalseRussianSoldier24')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier25')
            Characters[2] = P.controller;
        if (P.name == 'EFalseRussianSoldier19')
            Characters[3] = P.controller;
        if (P.name == 'EFalseRussianSoldier20')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Meltdown=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Intruder:
    Log("Walk away and taste the pain, come again some other day.");
    CheckFlags(Meltdown,TRUE,'Nada');
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,4,,,);
    Goal_Default(1,GOAL_Patrol,8,,,,'Cavalry1_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,9,,,,'Cavalry2_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Patrol,9,,,,'Cavalry3_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(4,GOAL_Stop,9,,,,,,FALSE,4,,,);
    Goal_Default(4,GOAL_Patrol,8,,,,'Cavalry4_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
Exclu:
    Log("Exclusivity false.");
    SetExclusivity(FALSE);
Nada:
    End();
Meltdown:
    Log("Sets the meltdown flag.");
    SetFlags(Meltdown,TRUE);
    End();

}

defaultproperties
{
}
