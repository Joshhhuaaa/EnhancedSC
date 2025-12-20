//=============================================================================
// P_3_4_2_Sev_SAMTechnician
//=============================================================================
class P_3_4_2_Sev_SAMTechnician extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TheyveTalked;
var int TheyveTalkedTwice;


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
        if (P.name == 'EMercenaryTechnician2')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    TheyveTalked=0;
    TheyveTalkedTwice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
TalkTech:
    Log("This is the interrogation pattern for the tech in the foundry.");
    CheckIfGrabbed(1,'talk');
    End();
talk:
    CheckFlags(TheyveTalked,TRUE,'Already');
    SetFlags(TheyveTalked,TRUE);
    Talk(Sound'S3_4_2Voice.Play_34_33_01', 0, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_02', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_03', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_04', 0, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_05', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_06', 0, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_07', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_08', 0, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_09', 1, , TRUE, 0);
    //AddNote("", "P_3_4_2_Sev_SAMTechnician", "Note_0014L", "Localization\\P_3_4_2Severonickel");
    // Joshua - Fixing incorrect note assigned
    AddNote("", "P_3_4_2_Sev_SAMTechnician", "Note_0005L", "Localization\\P_3_4_2Severonickel");
    Talk(Sound'S3_4_2Voice.Play_34_33_10', 0, , TRUE, 0);
    Close();
    End();
Already:
    Log("Theyve already talked.");
    CheckFlags(TheyveTalkedTwice,TRUE,'SecondPoss');
    SetFlags(TheyveTalkedTwice,TRUE);
FirstPoss:
    Talk(Sound'S3_4_2Voice.Play_34_33_11', 1, , TRUE, 0);
    Close();
    End();
SecondPoss:
    Talk(Sound'S3_4_2Voice.Play_34_33_12', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();

}

defaultproperties
{
}
