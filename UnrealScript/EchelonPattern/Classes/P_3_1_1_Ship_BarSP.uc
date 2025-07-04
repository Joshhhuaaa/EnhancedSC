//=============================================================================
// P_3_1_1_Ship_BarSP
//=============================================================================
class P_3_1_1_Ship_BarSP extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if(P.name == 'spetsnaz32')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz35')
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
BarSP:
    Log("Barrack swich Patrol in beginin");
    CinCamera(0, 'EFocusPoint24', 'EFocusPoint65',);
    Goal_Set(2,GOAL_MoveTo,9,,,,'BarTwo',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'spetsnaz32',,,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'BarOne',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'spetsnaz35',,,,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(2,GOAL_MoveTo,);
    CinCamera(1, , ,);
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,9,,'spetsnaz35',,'BarOne',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'spetsnaz32',,'BarTwo',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0002L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0003L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0005L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0006L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0007L", "Localization\\P_3_1_1_ShipYard"), None, 1, 1, TR_CONVERSATION, 0, false);
    AddNote("", "P_3_1_1_Ship_BarSP", "Note_0002L", "Localization\\P_3_1_1_ShipYard");
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0008L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_BarSP", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
note:
    Log("");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'LoneSentry',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,,,'LoneSentry',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'spetsnaz35_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

defaultproperties
{
}
