//=============================================================================
// P_4_3_2_FeirongInterro
//=============================================================================
class P_4_3_2_FeirongInterro extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Once;
var int Twice;


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
        if (P.name == 'EFeirong0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Once=0;
    Twice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FeirongIntelA:
    Log("FeirongIntelA");
    CheckFlags(Once,TRUE,'FeirongIntelB');
    SetFlags(Once,TRUE);
    Talk(Sound'S4_3_2Voice.Play_43_46_01', 0, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_02', 1, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_03', 0, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_04', 1, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_05', 0, , TRUE, 0);
    Close();
    End();
FeirongIntelB:
    Log("FeirongIntelB");
    CheckFlags(Twice,TRUE,'RandomCalisse');
    SetFlags(Twice,TRUE);
    Talk(Sound'S4_3_2Voice.Play_43_46_06', 0, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_07', 1, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_08', 0, , TRUE, 0);
    Talk(Sound'S4_3_2Voice.Play_43_46_09', 1, , TRUE, 0);
    Close();
    End();
RandomCalisse:
    Log("RandomCalisse");
    Log("These two RED commands should solve PC Bug 377. If it doesn't, talk to Clint");
    EndConversation();
    JumpRandom('FeirongIntelC', 0.50, 'FeirongIntelD', 1.00, , , , , ,);
    End();
FeirongIntelC:
    Log("FeirongIntelC");
    Talk(Sound'S4_3_2Voice.Play_43_46_10', 1, , TRUE, 0);
    Close();
    End();
FeirongIntelD:
    Log("FeirongIntelD");
    Talk(Sound'S4_3_2Voice.Play_43_46_11', 1, , TRUE, 0);
    Close();
    End();

}

