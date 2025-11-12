//=============================================================================
// P_2_2_2_Ktech_BreakerRoomAmbush
//=============================================================================
class P_2_2_2_Ktech_BreakerRoomAmbush extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int SamHasBeenSeen;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('NoReturn');
            break;
        case AI_DEAD:
            EventJump('NoReturn');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('NoReturn');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('NoReturn');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('NoReturn');
            break;
        case AI_UNCONSCIOUS:
            EventJump('NoReturn');
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
        if (P.name == 'EMafiaMuscle5')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle6')
            Characters[2] = P.controller;
        if (P.name == 'EMafiaMuscle7')
            Characters[3] = P.controller;
        if (P.name == 'EMafiaMuscle8')
        {
            Characters[4] = P.controller;
            EAIController(Characters[4]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    SamHasBeenSeen=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BreakerRoomAmbush:
    Log("Ambush in the breaker room");
    Sleep(0.5);
    CheckFlags(SamHasBeenSeen,TRUE,'NoComeBack');
    CinCamera(0, 'BreakerRoomCamera01', 'BreakerRoomTarget01',);
    Sleep(1);
    Speech(Localize("P_2_2_2_Ktech_BreakerRoomAmbush", "Speech_0006L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_23_01', 2, 0, TR_CONVERSATION, 0, false);
    Close();
StartSearching:
    Log("Start Searching");
    Goal_Set(2,GOAL_MoveTo,9,,,,'BreakerRoomAmbushNode01',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'BreakerRoomAmbushNode03',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,,,'BreakerRoomAmbushNode01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,,,'BreakerRoomAmbushNode03',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1.5);
    CinCamera(1, , ,);
    SetExclusivity(FALSE);
    End();
BreakerRoomAmbushReturn:
    Log("If the player switches the breaker.");
    CheckFlags(SamHasBeenSeen,TRUE,'NoComeBack');
    Sleep(2);
    ResetGroupGoals();
    ChangeState(2,'s_default');
    ChangeState(3,'s_default');
    Goal_Default(2,GOAL_Guard,9,,'BreakerRoomGuardsFocus',,'BreakerRoomAmbushDefaultNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(3,GOAL_Guard,9,,'BreakerRoomGuardsFocus',,'BreakerRoomAmbushDefaultNode03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    ChangeGroupState('s_default');
    Sleep(1);
    Speech(Localize("P_2_2_2_Ktech_BreakerRoomAmbush", "Speech_0007L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_24_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_2_Ktech_BreakerRoomAmbush", "Speech_0008L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_24_02', 2, 0, TR_NPCS, 0, false);
    SetExclusivity(FALSE);
    Speech(Localize("P_2_2_2_Ktech_BreakerRoomAmbush", "Speech_0003L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_24_03', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_2_Ktech_BreakerRoomAmbush", "Speech_0004L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_24_04', 3, 0, TR_NPCS, 0, false);
    Speech(Localize("P_2_2_2_Ktech_BreakerRoomAmbush", "Speech_0005L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_24_05', 1, 0, TR_NPCS, 0, false);
    Close();
NoComeBack:
    End();
BreakerON:
    Log("When Sam activates the breakers");
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).FuseBoxDone,TRUE);
    GoalCompleted('FuseBox');
    Teleport(4, 'AuditoriumPatrolMafioso03_0');
    Goal_Default(4,GOAL_Patrol,9,,,,'AuditoriumPatrolMafioso03_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(0.5);
    SendUnrealEvent('BreakerRoomSaveGame');
    Jump('BreakerRoomAmbushReturn');
    End();
NoReturn:
    Log("If Sam Has Been Seen");
    SetFlags(SamHasBeenSeen,TRUE);
    End();

}

