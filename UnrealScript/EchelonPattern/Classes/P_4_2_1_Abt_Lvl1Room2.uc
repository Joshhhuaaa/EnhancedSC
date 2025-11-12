//=============================================================================
// P_4_2_1_Abt_Lvl1Room2
//=============================================================================
class P_4_2_1_Abt_Lvl1Room2 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;
var int pass2;
var int Pass3;


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
        if (P.name == 'spetsnaz12')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    pass2=0;
    Pass3=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    CheckIfGrabbed(1,'Talk1');
    End();
Talk1:
    Log("");
    CheckFlags(pass1,TRUE,'Talk1b');
    SetFlags(pass1,TRUE);
    Talk(Sound'S4_2_1Voice.Play_42_25_01', 1, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_02', 0, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_03', 1, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_04', 0, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_05', 1, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_06', 0, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_07', 1, , TRUE, 0);
    Close();
    End();
Talk1b:
    Log("");
    CheckFlags(pass2,TRUE,'Talk2');
    SetFlags(pass2,TRUE);
    Talk(Sound'S4_2_1Voice.Play_42_25_08', 0, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_09', 1, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_10', 0, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_25_11', 1, , TRUE, 0);
    Close();
    End();
Talk2:
    Log("");
    CheckFlags(Pass3,TRUE,'JumpFin');
    SetFlags(Pass3,TRUE);
    Talk(Sound'S4_2_1Voice.Play_42_25_12', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();

}

