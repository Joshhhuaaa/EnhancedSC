//=============================================================================
// P_3_1_2_Ship_GoalNote
//=============================================================================
class P_3_1_2_Ship_GoalNote extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DebutDouble;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
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
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz46')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz1')
            Characters[3] = P.controller;
        if(P.name == 'EAnna0')
            Characters[4] = P.controller;
        if(P.name == 'ESamNPC0')
            Characters[5] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    DebutDouble=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Part1Goal:
    Log("Goal completed from part1");
    AddGoal('findbob', "", 1, "", "P_3_1_2_Ship_GoalNote", "Goal_0001L", "Localization\\P_3_1_2_ShipYard", "P_3_1_2_Ship_GoalNote", "Goal_0020L", "Localization\\P_3_1_2_ShipYard");
    GoalCompleted('findbob');
    AddGoal('DstComm', "", 3, "", "P_3_1_2_Ship_GoalNote", "Goal_0015L", "Localization\\P_3_1_2_ShipYard", "P_3_1_2_Ship_GoalNote", "Goal_0021L", "Localization\\P_3_1_2_ShipYard");
    GoalCompleted('DstComm');
    AddGoal('RaiseSub', "", 5, "", "P_3_1_2_Ship_GoalNote", "Goal_0016L", "Localization\\P_3_1_2_ShipYard", "P_3_1_2_Ship_GoalNote", "Goal_0022L", "Localization\\P_3_1_2_ShipYard");
    GoalCompleted('RaiseSub');
NotCompleted:
    Log("List of Goal not completed");
    AddGoal('UseSissix', "", 8, "", "P_3_1_2_Ship_GoalNote", "Goal_0005L", "Localization\\P_3_1_2_ShipYard", "P_3_1_2_Ship_GoalNote", "Goal_0023L", "Localization\\P_3_1_2_ShipYard");
JumpFin:
    Log("");
    End();
UsingSissix:
    Log("SAm operate the Sissix comunication system");
    SetFlags(V3_1_2_ShipYard(Level.VarObject).HNGpsrlPass1,TRUE);
    CinCamera(0, 'EFocusPoint12', 'EFocusPoint11',);
    Teleport(0, 'SamReal');
    Teleport(5, 'PathNode13');
    ResetGoals(5);
    Goal_Set(5,GOAL_Action,8,,,,'PathNode13','KbrdStAlBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(5,GOAL_Wait,7,,,,'PathNode13','KbrdStAlNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(5);
    CinCamera(0, 'EFocusPoint10', 'EFocusPoint9',);
    Speech(Localize("P_3_1_2_Ship_GoalNote", "Speech_0012L", "Localization\\P_3_1_2_ShipYard"), None, 1, 2, TR_HEADQUARTER, 0, false);
    GoalCompleted('UseSissix');
    Sleep(4);
    Speech(Localize("P_3_1_2_Ship_GoalNote", "Speech_0013L", "Localization\\P_3_1_2_ShipYard"), None, 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(5);
    Speech(Localize("P_3_1_2_Ship_GoalNote", "Speech_0014L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_2_Ship_GoalNote", "Speech_0017L", "Localization\\P_3_1_2_ShipYard"), None, 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_2_Ship_GoalNote", "Speech_0018L", "Localization\\P_3_1_2_ShipYard"), None, 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('ExtractSam', "", 10, "", "P_3_1_2_Ship_GoalNote", "Goal_0019L", "Localization\\P_3_1_2_ShipYard", "P_3_1_2_Ship_GoalNote", "Goal_0024L", "Localization\\P_3_1_2_ShipYard");
    Sleep(5);
    Close();
    Teleport(5, 'SamFake');
    Teleport(0, 'PathNode13');
    CinCamera(1, , ,);
    End();

}

defaultproperties
{
}
