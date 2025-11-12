//=============================================================================
// P_0_0_3_Training_T3_Interrog_Conv
//=============================================================================
class P_0_0_3_Training_T3_Interrog_Conv extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bFirstTimeConv;
var int bInterrogate;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
            break;
        case AI_RELEASED:
            EventJump('BreakConv');
            break;
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
        if (P.name == 'ECIARookie1')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    bFirstTimeConv=1;
    bInterrogate=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BeginConversation:
    Log("BeginConversation");
    CheckFlags(bInterrogate,TRUE,'AfterInterrogateConv');
    CheckIfGrabbed(1,'GrabbedConv');
    End();
GrabbedConv:
    Log("GrabbedConv");
    Talk(Sound'S0_0_Voice.Play_00_25_01', 0, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_25_02', 1, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_25_03', 0, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_25_04', 1, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_25_05', 0, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_25_06', 1, , TRUE, 0);
    SendPatternEvent('GroupKeypad03','GotCode');
    AddNote("", "P_0_0_3_Training_T3_Interrog_Conv", "Note_0017L", "Localization\\P_0_0_3_Training");
    SetFlags(bInterrogate,TRUE);
    Talk(Sound'S0_0_3Voice.Play_00_25_07', 0, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_25_08', 1, , TRUE, 0);
    Close();
    End();
AfterInterrogateConv:
    Log("AfterInterrogateConv");
    Talk(Sound'S0_0_3Voice.Play_00_25_06', 1, , TRUE, 0);
    Close();
    End();
BreakConv:
    Log("Break Conv");
    Close();
    End();
ManDown:
    Log("Sam killed the NPC. Telling Lambert.");
    CheckIfIsDead(1,'Murder');
    End();
Murder:
    SendPatternEvent('T3CommsGroup','BloodyMurder');
DoNothing:
    Log("Doing Nothing");
    End();

}

