//=============================================================================
// P_2_2_2_Ktech_HostageATalks
//=============================================================================
class P_2_2_2_Ktech_HostageATalks extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FirstTalkDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'EMercenaryTechnician9')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    FirstTalkDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
HostageA:
    Log("When you talk to hostages A");
    CheckFlags(FirstTalkDone,TRUE,'HostageABark');
    SetFlags(FirstTalkDone,TRUE);
    Goal_Set(1,GOAL_Action,9,,,,,'WaitCrAlFd0',FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Talk(Sound'S2_2_2Voice.Play_22_34_01', 1, , TRUE, 0);
    Close();
    End();
HostageABark:
    Log("HostageABark");
    Goal_Default(1,GOAL_Wait,9,,,,,'WaitCrAlFd0',FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Talk(Sound'S2_2_2Voice.Play_22_34_02', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();

}

