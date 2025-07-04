//=============================================================================
// P_1_3_3OilRig_PiotrInterrogation
//=============================================================================
class P_1_3_3OilRig_PiotrInterrogation extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FirstSpoken;
var int SpokenSecond;
var int ThirdSpokenMonkey;


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
        if(P.name == 'EMercenaryTechnician1')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    FirstSpoken=0;
    SpokenSecond=0;
    ThirdSpokenMonkey=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Piotr:
    Log("Piotr's interrogation dialog.");
    CheckFlags(FirstSpoken,TRUE,'Two');
    SetFlags(FirstSpoken,TRUE);
    Talk(Sound'S1_3_3Voice.Play_13_51_01', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_02', 1, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_03', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_04', 1, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_05', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_06', 1, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_07', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_08', 1, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_09', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_10', 1, , TRUE, 0);
    Close();
    End();
Two:
    Log("Two times.");
    CheckFlags(SpokenSecond,TRUE,'Three');
    SetFlags(SpokenSecond,TRUE);
    Talk(Sound'S1_3_3Voice.Play_13_51_11', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_12', 1, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_13', 0, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_51_14', 1, , TRUE, 0);
    Close();
    End();
Three:
    Log("Three times.");
    CheckFlags(ThirdSpokenMonkey,TRUE,'Four');
    SetFlags(ThirdSpokenMonkey,TRUE);
    Talk(Sound'S1_3_3Voice.Play_13_51_15', 1, , TRUE, 0);
    Close();
    End();
Four:
    Log("Four times.");
    Talk(Sound'S1_3_3Voice.Play_13_51_16', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();

}

