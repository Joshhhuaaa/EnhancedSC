//=============================================================================
// P_3_1_1_Ship_DinnerBarrack
//=============================================================================
class P_3_1_1_Ship_DinnerBarrack extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


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
        if(P.name == 'spetsnaz37')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz36')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz34')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Dinner:
    Log("dinner conversation");
    Goal_Set(1,GOAL_Action,9,,,,,'TalkAsNmEE0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkAsNmFF0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0002L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Goal_Set(3,GOAL_Attack,9,,,,,'TalkAsNmDD0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0003L", "Localization\\P_3_1_1_ShipYard"), None, 3, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Goal_Set(1,GOAL_Action,8,,,,,'TalkAsNmFF0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Goal_Set(3,GOAL_Action,8,,,,,'TalkAsNmCC0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0005L", "Localization\\P_3_1_1_ShipYard"), None, 3, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Goal_Set(2,GOAL_Action,8,,,,,'TalkAsNmDD0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0006L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Goal_Set(1,GOAL_Action,7,,,,,'TalkAsNmFF0',FALSE,,,,);
    Speech(Localize("P_3_1_1_Ship_DinnerBarrack", "Speech_0007L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(5);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode69',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode70',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,7,,,,'PathNode75',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,6,,,,'BobGuard',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,5,,'EBobrov0',,'BobGuard',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(3);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'PathNode37',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveAndAttack,8,,,,'PathNode33',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveAndAttack,7,,,,'PathNode45',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,6,,,,'PathNode197',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Guard,5,,,,'PathNode197',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    WaitForGoal(3,GOAL_MoveTo,);
    Teleport(3, 'PathNode66');
    Goal_Default(3,GOAL_Guard,4,,'EFocusPoint18',,'PathNode66',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

defaultproperties
{
}
