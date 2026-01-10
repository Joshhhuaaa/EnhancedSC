//=============================================================================
// P_4_2_2_Abt_TheHosTalk3
//=============================================================================
class P_4_2_2_Abt_TheHosTalk3 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


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
        if (P.name == 'EUSPrisoner4')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
UShostage2:
    Log("");
    CheckFlags(pass1,FALSE,'Talk1');
    JumpRandom('Talk2', 0.50, 'Talk3', 1.00, , , , , ,);
Talk1:
    Log("");
    SetFlags(pass1,TRUE);
    Talk(Sound'S4_2_2Voice.Play_42_51_07', 1, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_51_08', 0, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_51_09', 1, , TRUE, 0);
    Close();
    End();
Talk2:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_51_10', 1, , TRUE, 0);
    Close();
    End();
Talk3:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_51_11', 1, , TRUE, 0);
    Close();
    End();

}

