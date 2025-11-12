//=============================================================================
// P_5_2_NikoInterro
//=============================================================================
class P_5_2_NikoInterro extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TOne;
var int TThree;
var int TTwo;


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
        if (P.name == 'ENikoladze1')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    TOne=0;
    TThree=0;
    TTwo=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    CheckIfGrabbed(1,'Talk');
    End();
Talk:
    Log("Talk");
    CheckFlags(TOne,TRUE,'Talk2');
    Talk(Sound'S5_1_2Voice.Play_51_52_01', 0, , TRUE, 0);
    Sleep(0.10);
    Talk(Sound'S5_1_2Voice.Play_51_52_02', 1, , TRUE, 0);
    Sleep(0.10);
    Talk(Sound'S5_1_2Voice.Play_51_52_03', 0, , TRUE, 0);
    Sleep(0.10);
    Talk(Sound'S5_1_2Voice.Play_51_52_04', 1, , TRUE, 0);
    Sleep(0.10);
    Close();
    SetFlags(TOne,TRUE);
    End();
Talk2:
    Log("Talk2");
    CheckFlags(TTwo,TRUE,'Talk3');
    Talk(Sound'S5_1_2Voice.Play_51_52_05', 0, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_52_06', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_52_07', 0, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_52_08', 1, , TRUE, 0);
    Close();
    SetFlags(TTwo,TRUE);
    End();
Talk3:
    Log("Talk3");
    Talk(Sound'S5_1_2Voice.Play_51_52_09', 0, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_52_10', 1, , TRUE, 0);
    Close();
    EndConversation();
End:
    End();

}

