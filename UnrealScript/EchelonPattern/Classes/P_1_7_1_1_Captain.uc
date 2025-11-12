//=============================================================================
// P_1_7_1_1_Captain
//=============================================================================
class P_1_7_1_1_Captain extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Interrogated;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_UNCONSCIOUS:
            EventJump('SayThanks');
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
        if (P.name == 'EFalseRussianSoldier0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Interrogated=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SayMonkey:
    Log("SayMonkey");
    SetFlags(Interrogated,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_19', 0, , TRUE, 0);
    Talk(Sound'S3_2_2Voice.Play_32_35_20', 1, , TRUE, 0);
    Close();
    End();
SayThanks:
    Log("SayThanks");
    CheckFlags(Interrogated,FALSE,'NoThanks');
    Talk(Sound'S4_3_2Voice.Play_43_55_04', 0, , TRUE, 0);
    Close();
NoThanks:
    End();
TelCaptain:
    Log("TelCaptain");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelNodeB');
    KillNPC(1, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}
