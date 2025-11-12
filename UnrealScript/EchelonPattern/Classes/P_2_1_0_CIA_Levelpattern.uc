//=============================================================================
// P_2_1_0_CIA_Levelpattern
//=============================================================================
class P_2_1_0_CIA_Levelpattern extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('death');
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
        if (P.name == 'ELambert1')
            Characters[1] = P.controller;
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
death:
    Log("Thou shalt not kill");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    SendPatternEvent('Comms','StopItsOver');
    PlayerMove(false);
    Speech(Localize("P_2_1_0_CIA_Levelpattern", "Speech_0001L", "Localization\\P_2_1_0CIA"), Sound'S2_1_Voice.Play_21_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();

}

