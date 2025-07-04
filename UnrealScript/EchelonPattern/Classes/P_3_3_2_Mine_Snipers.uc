//=============================================================================
// P_3_3_2_Mine_Snipers
//=============================================================================
class P_3_3_2_Mine_Snipers extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('FromBelow');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
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
        if(P.name == 'spetsnaz4')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz6')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz1')
            Characters[3] = P.controller;
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
Alerted:
    Log("Alerted");
    SetFlags(V3_3_2MiningTown(Level.VarObject).GameplayJunkyardAlerted,TRUE);
    End();
Sniperbehaviors:
    Log("Sniperbehaviors");
    ChangeGroupState('s_alert');
    ResetGoals(1);
    Goal_Set(2,GOAL_MoveTo,9,,,,'InAntennagrgrgr',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Guard,8,,'TowerSnipeFokusA','TowerSnipeFokusA','InAntennagrgrgr',,FALSE,,MOVE_CrouchJog,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,,,'SnipeJunkPathNode',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Guard,8,,'SnipeFocusBlindA','SnipeFocusBlindA','SnipeJunkPathNode',,FALSE,,MOVE_CrouchJog,,MOVE_JogAlert);
    Sleep(6);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'SnipeJunkPathNode',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPointSNJU','EFocusPointSNJU','SnipeJunkPathNode',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(9);
    Jump('Sniperbehaviors');
    End();
FromBelow:
    Log("FromBelow");
    Teleport(3, 'PostInMaintF');
    Goal_Default(3,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    End();

}

defaultproperties
{
}
