//=============================================================================
// P_3_2_1_NPP_Shpdoinkle
//=============================================================================
class P_3_2_1_NPP_Shpdoinkle extends EPattern;

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
        if(P.name == 'EPowerPlantEmployee6')
            Characters[1] = P.controller;
        if(P.name == 'EPowerPlantEmployee7')
            Characters[2] = P.controller;
        if(P.name == 'EPowerPlantEmployee8')
            Characters[3] = P.controller;
        if(P.name == 'EPowerPlantEmployee9')
            Characters[4] = P.controller;
        if(P.name == 'EPowerPlantEmployee10')
            Characters[5] = P.controller;
        if(P.name == 'EPowerPlantEmployee11')
            Characters[6] = P.controller;
        if(P.name == 'EPowerPlantEmployee2')
            Characters[7] = P.controller;
        if(P.name == 'EPowerPlantEmployee5')
            Characters[8] = P.controller;
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
Cannibal:
    Log("The air's as pure as a baked potato.");
    SendUnrealEvent('CameraDestruct');
    SendPatternEvent('HallWorker1AI','Evacuate');
    SendPatternEvent('HallWorker2AI','Evacuate');
    SendPatternEvent('HallWorker4AI','Evacuate');
    SendPatternEvent('HallWorker5AI','Evacuate');
    SendPatternEvent('HallWorker6AI','Evacuate');
    SendPatternEvent('HallWorker7AI','Evacuate');
    SendPatternEvent('HallWorker8AI','Evacuate');
    SendPatternEvent('HallWorker9AI','Evacuate');
    SendPatternEvent('WhySoldiers','Evacuate');
    Goal_Set(1,GOAL_Patrol,9,,,,'Evac1_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Patrol,9,,,,'Evac2_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_Patrol,9,,,,'Evac3_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_Patrol,9,,,,'Evac4_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(5,GOAL_Patrol,9,,,,'Evac5_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(6,GOAL_Guard,9,,,,'Evac6_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(7,GOAL_Patrol,9,,,,'Evac7_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(8,GOAL_Patrol,9,,,,'Evac8_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1);
    CinCamera(0, 'EvacLocus', 'EvacTarget',);
    Sleep(9);
    SendUnrealEvent('EvacBlastDoor');
    Sleep(6);
    CinCamera(1, , ,);
    ResetGroup();
    CinCamera(0, 'Evac2Locus', 'Evac2Target',);
    SendUnrealEvent('BlastDoor');
    Sleep(5);
    CinCamera(1, , ,);
    GoalCompleted('1');
    SendPatternEvent('LambertAI','AlertCompleted');
    Sleep(1);
    KillNPC(1, FALSE, FALSE);
    KillNPC(2, FALSE, FALSE);
    KillNPC(3, FALSE, FALSE);
    KillNPC(4, FALSE, FALSE);
    KillNPC(5, FALSE, FALSE);
    KillNPC(6, FALSE, FALSE);
    KillNPC(7, FALSE, FALSE);
    KillNPC(8, FALSE, FALSE);
    End();

}

defaultproperties
{
}
