//=============================================================================
// P_1_3_2OilRig_BridgeDudes
//=============================================================================
class P_1_3_2OilRig_BridgeDudes extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bMoveDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('C4Plant');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('C4Plant');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('C4Plant');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('C4Plant');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('C4Plant');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('C4Plant');
            break;
        case AI_UNCONSCIOUS:
            EventJump('C4Plant');
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
        if(P.name == 'EGeorgianSoldier0')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianSoldier1')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bNotInStats = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    bMoveDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
C4Plant:
    Log("Pattern for Georgians under bridge planting explosives.");
    CheckFlags(bMoveDone,TRUE,'Nothing');
    SetFlags(bMoveDone,TRUE);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BridgeGoal1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Stop,9,,,,,'KbrdCrNmNt0',TRUE,10.5,,,);
    Goal_Default(2,GOAL_MoveTo,7,,,,'BridgeGoal0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,7,,,,'BridgeGoal1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,6,,,,'BridgeGoal0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Speech(Localize("P_1_3_2OilRig_BridgeDudes", "Speech_0005L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_11_01', 1, 0, TR_NPCS, 0, false);
    Close();
Nothing:
    End();
Quick:
    Log("Readjusts the pattern with the explosion.");
    Teleport(1, 'BridgeGoal1');
    ShakeCamera(1444, 10000, 2222);
    SendUnrealEvent('Blow');
    End();
Poop:
    Log("");
    Speech(Localize("P_1_3_2OilRig_BridgeDudes", "Speech_0003L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_21_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();

}

