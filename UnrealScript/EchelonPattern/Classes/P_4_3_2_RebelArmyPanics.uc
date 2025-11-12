//=============================================================================
// P_4_3_2_RebelArmyPanics
//=============================================================================
class P_4_3_2_RebelArmyPanics extends EPattern;

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
        if (P.name == 'EChineseSoldier1')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier3')
            Characters[2] = P.controller;
        if (P.name == 'EChineseSoldier0')
            Characters[3] = P.controller;
        if (P.name == 'EChineseSoldier4')
            Characters[4] = P.controller;
        if (P.name == 'EChineseSoldier8')
            Characters[5] = P.controller;
        if (P.name == 'ERottweiler0')
            Characters[6] = P.controller;
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
4340:
    Log("Scripted Event 43_40 The rebel army panics");
    Teleport(3, 'BatchTeleportNode01');
    Teleport(4, 'BatchTeleportNode02');
    Teleport(5, 'BatchTeleportNode03');
    Teleport(6, 'BatchTeleportNode04');
    KillNPC(3, FALSE, FALSE);
    KillNPC(4, FALSE, FALSE);
    KillNPC(5, FALSE, FALSE);
    KillNPC(6, FALSE, FALSE);
    Teleport(1, 'RebelArmyPanicsNode02');
    Teleport(2, 'RebelArmyPanicsNode01');
    ResetGroupGoals();
    ChangeGroupState('s_investigate');
    Goal_Default(1,GOAL_Guard,9,,'GuardFallingFocus',,'RebelArmyPanicsNode02',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,9,,'GuardFallingFocus',,'RebelArmyPanicsNode01',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
    CinCamera(0, 'GardenCameraPosition01', 'GardenCameraTarget01',);
    Goal_Set(1,GOAL_Action,9,,,,'GuardFallingFocus','ReacStAlFd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(0.5);
    Goal_Set(2,GOAL_Action,9,,,,'GuardFallingFocus','StunStAlEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'CinematicTeleport01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'GuardFalling',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Action,7,,,,'GuardFallingFocus','TripStAlFd2',TRUE,,,,);
    Goal_Set(2,GOAL_MoveTo,6,,,,'CinematicTeleport01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    Teleport(1, 'RebelArmyPanicsNode03');
    WaitForGoal(2,GOAL_MoveTo,);
    WaitForGoal(2,GOAL_MoveTo,);
    CinCamera(1, , ,);
    Teleport(2, 'RebelArmyPanicsNode04');
    SendPatternEvent('LambertComms','TruckDestroyed');
    End();

}

