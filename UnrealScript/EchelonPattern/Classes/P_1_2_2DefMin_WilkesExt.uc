//=============================================================================
// P_1_2_2DefMin_WilkesExt
//=============================================================================
class P_1_2_2DefMin_WilkesExt extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('KilledWilkes');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('KilledWilkes');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KilledWilkes');
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
        if(P.name == 'EWilkes0')
            Characters[1] = P.controller;
        if(P.name == 'ELambert0')
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
KilledWilkes:
    Log("KilledWilkes");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_2_2DefMin_WilkesExt", "Speech_0005L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_1_Voice.Play_11_95_01', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
RunAway:
    Log("RunAway");
    ChangeState(1,'s_alert');
    Sleep(1);
    ResetGoals(1);
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).WilkesKikinAss,TRUE);
rejumpattack:
    Goal_Default(1,GOAL_Attack,9,,'SDFifthOne','SDFifthOne',,,TRUE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(2);
    ResetGoals(1);
    Jump('rejumpattack');
    End();
relax:
    Log("relax");
    ResetGoals(1);
    ChangeState(1,'s_default');
    Goal_Set(1,GOAL_MoveTo,9,,,,'StandHereWAfterKill',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'StandHereWAfterKill',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TalkToMe:
    Log("TalkToMe");
    ResetGoals(1);
    ChangeState(1,'s_default');
    Goal_Default(1,GOAL_Guard,9,,'PLAYER','PLAYER',,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

