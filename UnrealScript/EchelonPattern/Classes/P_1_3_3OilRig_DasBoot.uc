//=============================================================================
// P_1_3_3OilRig_DasBoot
//=============================================================================
class P_1_3_3OilRig_DasBoot extends EPattern;

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
        if (P.name == 'EMercenaryTechnician2')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier2')
            Characters[2] = P.controller;
        if (P.name == 'EGeorgianSoldier4')
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
Boat:
    Log("Un keiner eier.");
    SendUnrealEvent('Boat');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Hoser1',,FALSE,,,,);
    CinCamera(0, 'SassyCamera', 'SassyTarget',);
    Goal_Default(1,GOAL_Guard,1,,,,'Hoser1',,FALSE,,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,1.25,,,);
    Goal_Default(2,GOAL_Guard,0,,,,'Hoser2',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,8,,,,'Hoser2',,FALSE,,,,);
    Goal_Set(3,GOAL_Stop,8,,,,,,FALSE,1.5,,,);
    Goal_Set(3,GOAL_MoveTo,7,,,,'goheresecond',,FALSE,,,,);
    Goal_Set(3,GOAL_Action,6,,,,,'ReacStNmFd0',FALSE,,,,);
    Goal_Default(3,GOAL_Guard,0,,,,'Hoser3',,FALSE,,,,);
    Goal_Set(3,GOAL_MoveTo,5,,,,'Hoser3',,FALSE,,,,);
    Sleep(12);
    CinCamera(1, , ,);
    KillNPC(1, FALSE, FALSE);
    KillNPC(2, FALSE, FALSE);
    KillNPC(3, FALSE, FALSE);
    End();
EscortTimer:
    Log("This is the independent timer for the escort hearing something.");
    SendUnrealEvent('OnAndOffSave');
    Sleep(5);
    SendPatternEvent('JedediahAI','CancelStop');
    SendUnrealEvent('OnAndOffSave');
    SendPatternEvent('DispatcherHackerAI','CheckPointRouter');
    End();

}

