//=============================================================================
// P_1_6_1_1_QuickInterro
//=============================================================================
class P_1_6_1_1_QuickInterro extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int One;


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
        if (P.name == 'spetsnaz10')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    One=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneQuickInterro:
    Log("MilestoneQuickInterro");
    CheckFlags(One,TRUE,'LastLine');
    SetFlags(One,TRUE);
    Talk(Sound'S3_4_2Voice.Play_34_33_03', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_01', 0, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_02', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_04', 0, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_33_07', 1, , TRUE, 0);
    End();
LastLine:
    Log("LastLine");
    Talk(Sound'S3_4_2Voice.Play_34_33_12', 1, , TRUE, 0);
    EndConversation();
    End();

}

defaultproperties
{
}
