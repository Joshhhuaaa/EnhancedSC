//=============================================================================
// P_2_2_2_Ktech_RoomCleanUp
//=============================================================================
class P_2_2_2_Ktech_RoomCleanUp extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'EMafiaMuscle10')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle9')
            Characters[2] = P.controller;
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
RoomCleanUp:
    Log("Start");
    Goal_Set(1,GOAL_MoveTo,9,,,,'RoomCleanUpNode06',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RoomCleanUpSwitchInteractionNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_InteractWith,8,,,,'RoomCleanUpSwitch',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_InteractWith,);
StartCleanUp:
    Log("StartCleanUp");
    Goal_Default(1,GOAL_Guard,9,,'VendingMachineFocus',,'RoomCleanUpNode11',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'RoomCleanUpFocus01',,'RoomCleanUpNode10',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Attack,9,,,'3rdFloorCleaningRoom5Group','RoomCleanUpNode06',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,,'3rdFloorCleaningRoom4Group','RoomCleanUpNode05',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,9,,,'3rdFloorCleaningRoom2Group','RoomCleanUpNode03',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,7,,,'3rdFloorCleaningRoom1Group','RoomCleanUpNode09',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,8,,,'3rdFloorCleaningRoom3Group','RoomCleanUpNode04',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_Attack,);
    ChangeGroupState('s_default');
    Goal_Set(2,GOAL_MoveTo,7,,'VendingMachineFocus',,'RoomCleanUpVendingMachine',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,6,,,,'VendingMachineFocus','DispStNmBg0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,5,,,,'VendingMachineFocus','DispStNmOn0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,4,,,,'VendingMachineFocus','DispStNmNt0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,3,,,,'VendingMachineFocus','DispStNmBB0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,2,,,,'VendingMachineFocus','DispStNmEd0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

