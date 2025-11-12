//=============================================================================
// P_3_1_2_Ship_Bridge
//=============================================================================
class P_3_1_2_Ship_Bridge extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Go2');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Go2');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Go2');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Go2');
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
        if (P.name == 'EAzeriColonel0')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle0')
            Characters[2] = P.controller;
        if (P.name == 'EAzeriColonel1')
            Characters[3] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
TakePosition:
    Log("");
    ResetGoals(2);
    Goal_Default(2,GOAL_Attack,9,,'EFocusPoint35','PLAYER','PathNode22',,TRUE,,MOVE_WalkAlert,,MOVE_CrouchJog);
    Speech(Localize("P_3_1_2_Ship_Bridge", "Speech_0001L", "Localization\\P_3_1_2_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(0.5);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode26',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'EFocusPoint35','PLAYER','PathNode26',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PathNode21',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,8,,,,'PathNode9',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,7,,'EFocusPoint35','PLAYER','PathNode9',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(0.5);
    Speech(Localize("P_3_1_2_Ship_Bridge", "Speech_0002L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    WaitForGoal(3,GOAL_MoveTo,);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode14',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'EFocusPoint35','PLAYER','PathNode14',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(1);
    ResetGoals(1);
    Goal_Default(1,GOAL_Attack,9,,'EFocusPoint35','PLAYER','PathNode26',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(0.5);
    SetExclusivity(FALSE);
    End();
Go2:
    Log("");
    Speech(Localize("P_3_1_2_Ship_Bridge", "Speech_0001L", "Localization\\P_3_1_2_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    SetExclusivity(FALSE);
    Sleep(1);
    Speech(Localize("P_3_1_2_Ship_Bridge", "Speech_0002L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();

}

defaultproperties
{
}
