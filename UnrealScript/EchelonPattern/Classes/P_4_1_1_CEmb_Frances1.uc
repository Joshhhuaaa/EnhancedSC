//=============================================================================
// P_4_1_1_CEmb_Frances1
//=============================================================================
class P_4_1_1_CEmb_Frances1 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TalkOnce;
var int TalkTwice;


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
        if (P.name == 'EFrances0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    TalkOnce=0;
    TalkTwice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ConversationWithFrancesCoen:
    Log("This is the first covnersation with Frances in this level.");
    CheckFlags(TalkOnce,TRUE,'SecondTalk');
    SetFlags(TalkOnce,TRUE);
    Talk(Sound'S4_1_1Voice.Play_41_05_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_10_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_10_02', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_10_03', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_10_04', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_10_05', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_10_06', 0, , TRUE, 0);
    Close();
    End();
SecondTalk:
    Log("SecondTalk");
    CheckFlags(TalkTwice,TRUE,'End');
    SetFlags(TalkTwice,TRUE);
    Talk(Sound'S4_1_1Voice.Play_41_11_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_11_02', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_11_03', 1, , TRUE, 0);
    Close();
    EndConversation();
End:
    End();

}

