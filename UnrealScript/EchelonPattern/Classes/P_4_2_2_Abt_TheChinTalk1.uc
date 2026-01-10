//=============================================================================
// P_4_2_2_Abt_TheChinTalk1
//=============================================================================
class P_4_2_2_Abt_TheChinTalk1 extends EPattern;

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
        if (P.name == 'EChineseDignitary1')
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
Chi1:
    Log("");
    JumpRandom('talk1', 0.34, 'talk2', 0.67, 'talk3', 1.00, , , ,);
    End();
talk1:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_52_01', 1, , TRUE, 0);
    Close();
    End();
talk2:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_52_02', 1, , TRUE, 0);
    End();
talk3:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_52_03', 1, , TRUE, 0);
    Close();
    End();

}

