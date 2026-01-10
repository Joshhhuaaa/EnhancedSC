//=============================================================================
// P_4_2_2_Abt_TheHosTalk1
//=============================================================================
class P_4_2_2_Abt_TheHosTalk1 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_2Voice.uax

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
        if (P.name == 'EUSPrisoner5')
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
UShostage0:
    Log("");
    JumpRandom('Talk1', 0.34, 'Talk2', 0.67, 'Talk3', 1.00, , , ,);
Talk1:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_51_01', 1, , TRUE, 0);
    Close();
    End();
Talk2:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_51_02', 1, , TRUE, 0);
    Close();
    End();
Talk3:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_51_03', 1, , TRUE, 0);
    Close();
    End();

}

