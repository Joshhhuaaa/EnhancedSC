//=============================================================================
// P_4_1_1_CEmb_GameOver
//=============================================================================
class P_4_1_1_CEmb_GameOver extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Lambert.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('MissionFailed');
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
        if(P.name == 'ELambert2')
            Characters[1] = P.controller;
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
MissionFailed:
    Log("MissionFailed");
    SetProfileDeletion();
    PlayerMove(false);
    IgnoreAlarmStage(TRUE);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_1_1_CEmb_GameOver", "Speech_0001L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'Lambert.Play_41_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
AlreadyTriggered:
    End();

}

