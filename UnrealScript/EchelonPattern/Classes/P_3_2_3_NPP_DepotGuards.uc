//=============================================================================
// P_3_2_3_NPP_DepotGuards
//=============================================================================
class P_3_2_3_NPP_DepotGuards extends EPattern;

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
        if(P.name == 'EFalseRussianSoldier1')
            Characters[1] = P.controller;
        if(P.name == 'EFalseRussianSoldier2')
            Characters[2] = P.controller;
        if(P.name == 'EFalseRussianSoldier3')
            Characters[3] = P.controller;
        if(P.name == 'EFalseRussianSoldier0')
            Characters[4] = P.controller;
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
vent:
    Log("Sam is in the pipeline, 5x5.");
    ResetGroupGoals();
    SetExclusivity(TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'DeathNode1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Wait,8,,,,,,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,9,,,,'DeathNode2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Wait,8,,,,,,FALSE,,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,0.5,,,);
    Goal_Set(3,GOAL_MoveTo,8,,,,'DeathNode3',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_Wait,7,,,,,,FALSE,,,,);
    Speech(Localize("P_3_2_3_NPP_DepotGuards", "Speech_0001L", "Localization\\P_3_2_3_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0);
    Sleep(2);
    WaitForGoal(3,GOAL_MoveTo,);
    Speech(Localize("P_3_2_3_NPP_DepotGuards", "Speech_0002L", "Localization\\P_3_2_3_PowerPlant"), None, 2, 0, TR_CONVERSATION, 0);
    Sleep(0.25);
    Goal_Set(1,GOAL_Attack,9,,'ShootMe','ShootMe',,,TRUE,,,,);
    Sleep(1);
    Close();
    Goal_Set(4,GOAL_MoveTo,9,,,,'CrouchPoint',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_Wait,8,,'StayFocused','StayFocused',,,FALSE,,,,);
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
