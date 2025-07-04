//=============================================================================
// P_2_2_2_Ktech_HostageBTalks
//=============================================================================
class P_2_2_2_Ktech_HostageBTalks extends EPattern;

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
        if(P.name == 'EMercenaryTechnician2')
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
HostageB:
    Log("When you talk to hostages B");
    CheckFlags(FirstTalkDone,TRUE,'HostageBBark');
    SetFlags(FirstTalkDone,TRUE);
    Goal_Set(1,GOAL_Action,9,,,,,'PrsoCrAlAA0',FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Talk(Sound'S2_2_2Voice.Play_22_34_05', 1, , TRUE, 0);
    Close();
    End();
HostageBBark:
    Log("HostageBBark");
    Goal_Set(1,GOAL_Action,9,,,,,'PrsoCrAlBB0',FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Wait,8,,,,,'WaitCrAlFd0',FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Talk(Sound'S2_2_2Voice.Play_22_34_06', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();

}

