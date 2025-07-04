//=============================================================================
// P_1_1_2_Tbilisi_Prisoners
//=============================================================================
class P_1_1_2_Tbilisi_Prisoners extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Heard;
var int Seen;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Exclusive');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('HeardSomething');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SeenSam');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SeenSam');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Exclusive');
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
        if(P.name == 'EAINonHostile0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Heard=0;
    Seen=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is the pattern for the prisoners in the basement");
HeardSomething:
    Log("One of the prisoners heard something.");
    CheckFlags(Heard,TRUE,'DoNothing');
    SetFlags(Heard,TRUE);
    DisableMessages(TRUE, TRUE);
    Goal_Default(1,GOAL_Wait,0,,'Alexei_0',,'BlaisBars','JailStNmNt0',TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    DisableMessages(FALSE, FALSE);
    End();
SeenSam:
    Log("The prisoners saw sam");
    CheckFlags(Seen,TRUE,'DoNothing');
    SetFlags(Seen,TRUE);
    Talk(Sound'S1_1_2Voice.Play_11_28_09', 1, , TRUE, 0);
    Sleep(1);
    Talk(Sound'S1_1_2Voice.Play_11_28_10', 1, , TRUE, 0);
    Sleep(1);
    Talk(Sound'S1_1_2Voice.Play_11_28_11', 1, , TRUE, 0);
    Sleep(1);
    Close();
    End();
Exclusive:
    Log("Setting exclusivity to False");
    SetExclusivity(FALSE);
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

