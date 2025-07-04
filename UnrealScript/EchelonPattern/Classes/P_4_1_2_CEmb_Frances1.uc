//=============================================================================
// P_4_1_2_CEmb_Frances1
//=============================================================================
class P_4_1_2_CEmb_Frances1 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_2Voice.uax

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
        if(P.name == 'EFrances0')
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
Milestone:
    Log("Milestone");
    DisableMessages(TRUE, TRUE);
    Talk(Sound'S4_1_2Voice.Play_41_46_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_2Voice.Play_41_46_03', 1, , TRUE, 0);
    Close();
    EndConversation();
    GameOver(true, 0);
    End();

}

