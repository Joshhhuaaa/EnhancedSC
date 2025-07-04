//=============================================================================
// P_4_1_1_CEmb_CIAContact
//=============================================================================
class P_4_1_1_CEmb_CIAContact extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TalkOnce;
var int TalkThird;
var int TalkTwice;


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
        if(P.name == 'ECIABureaucrat0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    TalkOnce=0;
    TalkThird=0;
    TalkTwice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ConversationWithCIAContact:
    Log("This is the conversation with the CIA contact");
    CheckFlags(TalkOnce,TRUE,'TalkTwo');
    SetFlags(TalkOnce,TRUE);
    Talk(Sound'S4_1_1Voice.Play_41_17_01', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_02', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'PLAYER','PLAYER',,'GiveStNmBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    AddRecon(class 'EReconMap4_1');
    Goal_Set(1,GOAL_Action,9,,'PLAYER','PLAYER',,'GiveStNmNt0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,'PLAYER','PLAYER',,'GiveStNmEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Default(1,GOAL_Guard,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    GoalCompleted('4_1_1');
    Talk(Sound'S4_1_1Voice.Play_41_17_03', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_04', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_05', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_06', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_07', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_08', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_09', 1, , TRUE, 0);
    AddGoal('4_1_3', "", 10, "", "P_4_1_1_CEmb_CIAContact", "Goal_0022L", "Localization\\P_4_1_1ChineseEmbassy", "P_4_1_1_CEmb_CIAContact", "Goal_0023L", "Localization\\P_4_1_1ChineseEmbassy");
    Talk(Sound'S4_1_1Voice.Play_41_17_10', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_11', 1, , TRUE, 0);
    Close();
    SendPatternEvent('contactonroof','Milestone');
    End();
TalkTwo:
    Log("TalkTwo");
    CheckFlags(TalkTwice,TRUE,'TalkThree');
    SetFlags(TalkTwice,TRUE);
    Talk(Sound'S4_1_1Voice.Play_41_17_12', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_13', 1, , TRUE, 0);
    Close();
    End();
TalkThree:
    Log("TalkThree");
    CheckFlags(TalkThird,TRUE,'LastTalk');
    SetFlags(TalkThird,TRUE);
    Talk(Sound'S4_1_1Voice.Play_41_17_14', 0, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_17_15', 1, , TRUE, 0);
    Close();
    End();
LastTalk:
    Log("LastTalk");
    JumpRandom('lasttalkone', 0.50, 'lasttalktwo', 1.00, , , , , , ); 
    End();
lasttalkone:
    Log("lasttalkone");
    Talk(Sound'S4_1_1Voice.Play_41_17_16', 1, , TRUE, 0);
    Close();
    End();
lasttalktwo:
    Log("lasttalktwo");
    Talk(Sound'S4_1_1Voice.Play_41_17_17', 1, , TRUE, 0);
    Close();
End:
    End();

}

