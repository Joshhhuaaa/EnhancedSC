//=============================================================================
// P_0_0_2_Training_GrimChat
//=============================================================================
class P_0_0_2_Training_GrimChat extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int ChatOnce;
var int ChatThrice;
var int ChatTwice;


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
        if (P.name == 'EAnna1')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    ChatOnce=0;
    ChatThrice=0;
    ChatTwice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is Grimsdottir's conversation pattern.");
    CheckFlags(ChatThrice,TRUE,'FinalLoop');
FirstChat:
    Log("Sam approaches for the first time.");
    CheckFlags(ChatOnce,TRUE,'SecondChat');
    SetFlags(ChatOnce,TRUE);
    Talk(Sound'S0_0_2Voice.Play_00_18_01', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_02', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_03', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_04', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_05', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_06', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_07', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
SecondChat:
    Log("Sam tries again");
    CheckFlags(ChatTwice,TRUE,'ThirdChat');
    SetFlags(ChatTwice,TRUE);
    Talk(Sound'S0_0_2Voice.Play_00_18_08', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_09', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_10', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_11', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_12', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
ThirdChat:
    Log("Jeez, what are you trying to do, pick her up or something?");
    CheckFlags(ChatThrice,TRUE,'FinalLoop');
    SetFlags(ChatThrice,TRUE);
    Talk(Sound'S0_0_2Voice.Play_00_18_13', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_14', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_15', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_16', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_17', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S0_0_2Voice.Play_00_18_18', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    SendPatternEvent('ScriptedEvents','GrimReturn');
    End();
FinalLoop:
    Log("Sam has drained it, looping the endings.");
    JumpRandom('ANiceties', 0.50, 'BNiceties', 1.00, , , , , ,);
    End();
ANiceties:
    Talk(Sound'S0_0_2Voice.Play_00_18_19', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
BNiceties:
    Talk(Sound'S0_0_2Voice.Play_00_18_20', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();

}

