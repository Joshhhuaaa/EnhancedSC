//=============================================================================
// P_1_6_1_1_NVServerSweep
//=============================================================================
class P_1_6_1_1_NVServerSweep extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int SweepStarted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('GoFalse');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('GoFalse');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('GoFalse');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GoFalse');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GoFalse');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'spetsnaz3')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz7')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz8')
            Characters[3] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'StaticMeshActor449')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    SweepStarted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneNVServerSweep:
    Log("MilestoneNVServerSweep");
    ToggleGroupAI(TRUE, 'GroupServerSweep', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Sleep(8);
    Goal_Set(1,GOAL_InteractWith,9,,,,'ServerSwitch',,FALSE,,,,);
    WaitForGoal(1,GOAL_InteractWith,);
    Sleep(2);
    Teleport(1, 'TelNVThree');
    Teleport(2, 'TestTelP');
    Teleport(3, 'TelNVThree');
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ServerPreSweepOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'FocusForSeverStanby',,'ServerPreSweepOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ServerPreSweepTwo',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Guard,8,,'FocusForSeverStanby',,'ServerPreSweepTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'MiningBleh',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(3,GOAL_PlaceWallMine,8,,,,'WallMinePlace',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(3,GOAL_MoveTo,7,,,,'ServerPreSweepThree',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Guard,6,,'FocusForSeverStanby',,'ServerPreSweepThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
GoFalse:
    Log("GoFalse");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,FALSE,'SkipDoorOpen');
    SendUnrealEvent('servertrapdoor');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,FALSE);
SkipDoorOpen:
    Log("SkipDoorOpen");
    DisableMessages(TRUE, FALSE);
    SetExclusivity(FALSE);
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).SweepCancel,TRUE);
    End();
SweepIt:
    Log("SweepIt");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).SweepCancel,TRUE,'End');
    SetFlags(SweepStarted,TRUE);
    SendUnrealEvent('servertrapdoor');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,FALSE);
    Goal_Set(3,GOAL_Action,9,,,,,'SignStAlLt0',FALSE,,,,);
    WaitForGoal(3,GOAL_Action,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'LServerOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_MoveTo,8,,,,'LServerBOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Guard,7,,'FocusForSeverStanby',,'LServerBOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(2.5);
    Goal_Set(3,GOAL_Action,9,,,,,'SignStAlRt0',FALSE,,,,);
    WaitForGoal(3,GOAL_Action,);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RServerOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,8,,,,'RServerBOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Guard,7,,'FocusForSeverStanby',,'RServerBOne',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(4);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'LastSweepPoint',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(3,GOAL_Guard,8,,'serverdirectfocus',,'LastSweepPoint',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(22);
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_default');
    ChangeGroupState('s_investigate');
    ePawn(Characters[3].Pawn).Bark_Type = BARK_SearchFailedPlayer;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    Goal_Default(1,GOAL_Search,9,,,,'NVsrchC',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Search,9,,,,'NVsrchB',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(3,GOAL_Search,9,,,,'NVsrchA',,FALSE,,MOVE_Search,,MOVE_Search);
    End();
IntroOn:
    Log("IntroOn");
    Goal_Set(1,GOAL_InteractWith,9,,,,'ServerSwitch',,FALSE,,,,);
    WaitForGoal(1,GOAL_InteractWith,);
    ToggleGroupAI(FALSE, 'GroupServerSweep', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'TelB');
    Teleport(1, 'NVOutC');
    KillNPC(1, FALSE, TRUE);
TelB:
    Log("TelB");
    CheckIfIsUnconscious(2,'TelC');
    Teleport(2, 'NVOutB');
    KillNPC(2, FALSE, TRUE);
TelC:
    Log("TelC");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'NVOutA');
    KillNPC(3, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}
