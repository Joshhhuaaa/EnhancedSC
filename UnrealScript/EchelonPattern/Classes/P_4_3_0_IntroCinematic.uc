//=============================================================================
// P_4_3_0_IntroCinematic
//=============================================================================
class P_4_3_0_IntroCinematic extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_0Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TriggerConversationOnce;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('SamKilledFrances');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SamKilledFrances');
            break;
        case AI_UNCONSCIOUS:
            EventJump('SamKilledFrances');
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
        if (P.name == 'EFrances0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    TriggerConversationOnce=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
IntroCinematicStart:
    Log("IntroStart");
    Talk(Sound'S4_3_0Voice.Play_43_03_01', 1, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_03_02', 0, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_03_03', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();
SamKilledFrances:
    Log("If Sam Kills Frances");
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    SendPatternEvent('LambertComms','GenericFail');
    End();

}

