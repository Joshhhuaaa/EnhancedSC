//=============================================================================
// P_3_3_1_Mine_TechInfoUpdate
//=============================================================================
class P_3_3_1_Mine_TechInfoUpdate extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int MovingAlready;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('OneKillDone');
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
        if(P.name == 'EMercenaryTechnician3')
            Characters[1] = P.controller;
        if(P.name == 'EMercenaryTechnician4')
            Characters[2] = P.controller;
        if(P.name == 'ELambert1')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    MovingAlready=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneTechInfoUpdate");
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInfoUpdate", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 3, 2, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Speech(Localize("P_3_3_1_Mine_TechInfoUpdate", "Speech_0003L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_TechInfoUpdate", "Speech_0004L", "Localization\\P_3_3_1MiningTown"), None, 3, 2, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_TechInfoUpdate", "Speech_0017L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_CONSOLE, 0, false);
    GoalCompleted('3_3_2');
    AddGoal('3_3_3', "", 2, "", "P_3_3_1_Mine_TechInfoUpdate", "Goal_0012L", "Localization\\P_3_3_1MiningTown", "P_3_3_1_Mine_TechInfoUpdate", "Goal_0018L", "Localization\\P_3_3_1MiningTown");
    Close();
    End();
TensionMove:
    Log("TensionMove");
    CheckFlags(MovingAlready,TRUE,'End');
    SetFlags(MovingAlready,TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'testingcommgeeks',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPointConvGeeksOne','EFocusPointConvGeeksOne','testingcommgeeks',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
    ResetGoals(1);
talking:
    Goal_Set(1,GOAL_Action,7,,'EFocusPointConvGeeksOne','EFocusPointConvGeeksOne','testingcommgeeks','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    Jump('talking');
    End();
OneKillDone:
    Log("OneKillDone");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE,'TooMuchKillDone');
    SetFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE);
    Speech(Localize("P_3_3_1_Mine_TechInfoUpdate", "Speech_0015L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
TooMuchKillDone:
    Log("TooMuchKillDone");
    SetProfileDeletion();
    Speech(Localize("P_3_3_1_Mine_TechInfoUpdate", "Speech_0016L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).InsideHQAlerted,TRUE);
    End();

}

defaultproperties
{
}
