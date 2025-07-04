//=============================================================================
// P_2_1_2_CIA_Levelpattern
//=============================================================================
class P_2_1_2_CIA_Levelpattern extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Death');
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
        if(P.name == 'ELambert7')
            Characters[1] = P.controller;
        if(P.name == 'EMitch7')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
        if(P.name == 'EWilkes0')
            Characters[3] = P.controller;
        if(P.name == 'EBaxter2')
            Characters[4] = P.controller;
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
Death:
    Log("Kill Not");
    CheckIfIsDead(2,'MitchellDead'); // Joshua - New check
    CheckIfIsDead(2,'End');
    CheckIfIsDead(3,'End');
    CheckIfIsDead(4,'End');
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    SendPatternEvent('Comms','StopPatternItsOver');
    SendPatternEvent('Van_conversation','StopPatternItsOver');
    Speech(Localize("P_2_1_2_CIA_Levelpattern", "Speech_0001L", "Localization\\P_2_1_2CIA"), Sound'S2_1_Voice.Play_21_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
MitchellDead: // Joshua - New JumpLabel to check if Mitchell is dead during Lambert speech
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    SendPatternEvent('Comms','StopPatternItsOver');
    SendPatternEvent('Van_conversation','StopPatternItsOver');
    Speech(Localize("P_2_1_2_CIA_Levelpattern", "Speech_0001L", "Localization\\P_2_1_2CIA"), Sound'S2_1_Voice.Play_21_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
End:
    End();

}

