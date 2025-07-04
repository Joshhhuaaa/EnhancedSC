//=============================================================================
// P_1_7_1_2_Interro
//=============================================================================
class P_1_7_1_2_Interro extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'spetsnaz15')
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
MilestoneInterro:
    Log("MilestoneInterro");
    Talk(Sound'S3_1_1Voice.Play_31_27_01', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_27_02', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_27_09', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_27_12', 1, , TRUE, 0);
    EndConversation();
    End();

}

defaultproperties
{
}
