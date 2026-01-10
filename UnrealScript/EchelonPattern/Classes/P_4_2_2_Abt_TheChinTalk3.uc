//=============================================================================
// P_4_2_2_Abt_TheChinTalk3
//=============================================================================
class P_4_2_2_Abt_TheChinTalk3 extends EPattern;

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
        if (P.name == 'ELongDan0')
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
LongDan:
    Log("");
    JumpRandom('talk1', 0.34, 'talk2', 0.67, 'talk3', 1.00, , , ,);
    End();
talk1:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_52_07', 1, , TRUE, 0);
    Close();
    End();
talk2:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_52_08', 1, , TRUE, 0);
    Close();
    End();
talk3:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_52_09', 1, , TRUE, 0);
    Close();
    End();

}

