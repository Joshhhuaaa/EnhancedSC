//=============================================================================
// P_1_2_1DefMin_CookSecond
//=============================================================================
class P_1_2_1DefMin_CookSecond extends EPattern;

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
            EventJump('Milestone');
            break;
        case AI_GRABBED:
            EventJump('Alerted');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Alerted');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('Alerted');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Alerted');
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
        if(P.name == 'ECook1')
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
Milestone:
    Log("MilestoneCookSecond");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).CookOneDead,TRUE,'BothDead');
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).CookTwoDead,TRUE);
    Speech(Localize("P_1_2_1DefMin_CookSecond", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_90_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
BothDead:
    Log("BothDeadCookSecond");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_2_1DefMin_CookSecond", "Speech_0002L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_90_02', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 2);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).CooksAlerted,TRUE);
    End();

}

