//=============================================================================
// P_3_2_1_NPP_PistonHostiles
//=============================================================================
class P_3_2_1_NPP_PistonHostiles extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Activate');
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
        if(P.name == 'EFalseRussianSoldier10')
            Characters[1] = P.controller;
        if(P.name == 'EFalseRussianSoldier17')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Activate:
    Log("The Piston alarm has been triggered, activating the 2 catwalk guards.");
    IgnoreAlarmStage(TRUE);
    StartAlarm('HallAlarm',1);
    IgnoreAlarmStage(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'JCDenton_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'JCDenton_0',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,9,,,,'JRDenton_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'JRDenton_0',,FALSE,,,,);
    End();

}

defaultproperties
{
}
