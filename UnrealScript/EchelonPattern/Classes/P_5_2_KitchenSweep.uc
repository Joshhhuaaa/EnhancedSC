//=============================================================================
// P_5_2_KitchenSweep
//=============================================================================
class P_5_2_KitchenSweep extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Started;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('DropKit');
            break;
        case AI_GRABBED:
            EventJump('DropKit');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('DropKit');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('DropKit');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('DropKit');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('DropKit');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('DropKit');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('DropKit');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('DropKit');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('DropKit');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DropKit');
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
        if (P.name == 'EGeorgianPalaceGuard20')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianPalaceGuard18')
            Characters[2] = P.controller;
        if (P.name == 'EGeorgianPalaceGuard15')
            Characters[3] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Started=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    SetFlags(Started,TRUE);
    SetExclusivity(FALSE);
    ChangeGroupState('s_alert');
    Goal_Default(2,GOAL_Patrol,9,,,,'KitchenSweep2_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Teleport(1, 'PostPatrolUpK');
    Goal_Set(1,GOAL_MoveTo,9,,,,'KitchenSweep5_200',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'KitchenSweep5_200',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'KitchenSweep3_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Patrol,8,,,,'KitchenSweep3_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(5);
    ePawn(Characters[2].Pawn).Bark_Type = BARK_CombArea;
    Talk(ePawn(Characters[2].Pawn).Sounds_Barks, 2, 0, false);
    Sleep(80);
KitchenSweepEnd:
    Log("KitchenSweepEnd");
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_default');
    Goal_Set(3,GOAL_MoveTo,9,,,,'KitchenSweep4end',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Guard,8,,,,'KitchenSweep4end',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PostKitOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Guard,8,,,,'PostKitOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Wait,9,,,,,'RdioStNmNt0',FALSE,,,,);
    Speech(Localize("P_5_2_KitchenSweep", "Speech_0002L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_82_01', 1, 0, TR_NPCS, 0, false);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'KitchenSweep4_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,,,'KitchenSweep4_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
DropKit:
    Log("DropKit");
    CheckFlags(Started,FALSE,'End');
    SendUnrealEvent('NoKitIntVol');
    DisableMessages(TRUE, TRUE);
End:
    End();

}

