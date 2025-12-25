//=============================================================================
// LambertWarnings
//=============================================================================
class LambertWarnings extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Lambert.uax

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
        if (P.tag == 'ELambert')
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
AlarmStageA:
    Log("First Alarm Stage");
    DisableMessages(TRUE, TRUE);
	Sleep(5);                                               //temporary fix for xboxmag demo
    // Joshua - Clear NPC transmissions before Lambert speaks to prevent visual bug
    ClearNPCTransmissions();
    Sleep(0.1);
    Speech(Localize("LambertWarnings", "Speech_0001L", "Localization\\Hint"), Sound'Lambert.Play_AlarmStage1Opt1', 1, 0, TR_MENUSPEECH, 0, false);
	Close();
    DisableMessages(FALSE, FALSE);
    End();
AlarmStageB:
    Log("Second Alarm Stage");
    DisableMessages(TRUE, TRUE);
	Sleep(5);
    // Joshua - Clear NPC transmissions before Lambert speaks to prevent visual bug
    ClearNPCTransmissions();
    Sleep(0.1);
    Speech(Localize("LambertWarnings", "Speech_0002L", "Localization\\Hint"), Sound'Lambert.Play_AlarmStage1Opt1', 1, 0, TR_MENUSPEECH, 0, false);
	Close();
    DisableMessages(FALSE, FALSE);
    End();
AlarmStageC:
    Log("Third Alarm Stage");
    DisableMessages(TRUE, TRUE);
	Sleep(5);
    // Joshua - Clear NPC transmissions before Lambert speaks to prevent visual bug
    ClearNPCTransmissions();
    Sleep(0.1);
    Speech(Localize("LambertWarnings", "Speech_0003L", "Localization\\Hint"), Sound'Lambert.Play_AlarmStage1Opt2', 1, 0, TR_MENUSPEECH, 0, false);
	Close();
    DisableMessages(FALSE, FALSE);
    End();
AlarmStageD:
    Log("Last Alarm Stage");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    // Joshua - Clear NPC transmissions before Lambert speaks to prevent visual bug
	ClearNPCTransmissions();
    Sleep(0.1);
    PlayerMove(false);
    Speech(Localize("LambertWarnings", "Speech_0004L", "Localization\\Hint"), Sound'Lambert.Play_AlarmStage1Opt3', 1, 0, TR_MENUSPEECH, 0, true);
	Close();
    Sleep(1);
    GameOver(false,1);
    DisableMessages(FALSE, FALSE);
    End();

}

