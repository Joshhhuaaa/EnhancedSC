//=============================================================================
// P_3_2_1_NPP_PistonInterro
//=============================================================================
class P_3_2_1_NPP_PistonInterro extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Foursies;
var int Once;
var int Thrice;
var int Twice;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_GRABBED:
            EventJump('Grabbed');
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

    if (!bInit)
    {
    bInit=TRUE;
    Foursies=0;
    Once=0;
    Thrice=0;
    Twice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Grabbed:
    Log("AI_GRABBED");
    CheckIfGrabbed(1,'Interrogate');
    End();
Interrogate:
    Log("Sam has grabbed Esfir.");
    CheckFlags(Once,TRUE,'Twice');
    SetFlags(Once,TRUE);
    Talk(Sound'S3_2_1Voice.Play_32_29_01', 0, , TRUE, 0);
    Sleep(0.1);
    Speech(Localize("P_3_2_1_NPP_PistonInterro", "Speech_0008L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_29_02', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_03', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_04', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_05', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_06', 1, , TRUE, 0);
    SendPatternEvent('PistonTech','CodeAcquired');
    Sleep(0.1);
    GoalCompleted('5');
    AddNote("", "P_3_2_1_NPP_PistonInterro", "Note_0023L", "Localization\\P_3_2_1_PowerPlant");
    SendPatternEvent('LambertAI','Coded');
    Talk(Sound'S3_2_1Voice.Play_32_29_07', 0, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Twice:
    Log("Sam has prodded Esfir twice.");
    CheckFlags(Twice,TRUE,'Thrice');
    SetFlags(Twice,TRUE);
    Talk(Sound'S3_2_1Voice.Play_32_29_08', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_09', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_10', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_11', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Thrice:
    Log("Sam has prodded Esfir 3 times.");
    CheckFlags(Thrice,TRUE,'Four');
    SetFlags(Thrice,TRUE);
    Talk(Sound'S3_2_1Voice.Play_32_29_12', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_1Voice.Play_32_29_13', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Four:
    Log("Sam has prodded Esfir 4+ times.");
    CheckFlags(Foursies,TRUE,'Five');
    SetFlags(Foursies,TRUE);
    Talk(Sound'S3_2_1Voice.Play_32_29_14', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Five:
    Log("Sam has prodded Esfir 5+ times.");
    SetFlags(Foursies,FALSE);
    Talk(Sound'S3_2_1Voice.Play_32_29_15', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();

}

defaultproperties
{
}
