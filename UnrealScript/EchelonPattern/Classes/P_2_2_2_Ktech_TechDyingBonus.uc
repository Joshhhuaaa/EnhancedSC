//=============================================================================
// P_2_2_2_Ktech_TechDyingBonus
//=============================================================================
class P_2_2_2_Ktech_TechDyingBonus extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int killingNPC;
var int techdead;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_TAKE_DAMAGE:
            EventJump('TechGotKilled');
            break;
        case AI_UNCONSCIOUS:
            EventJump('TechGotKilled');
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
        if (P.name == 'EMercenaryTechnician7')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    killingNPC=0;
    techdead=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
TechDyingBonus:
    Log("If Sam interacts with the NPC, the conversation starts");
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).TechDyingFirstConversation,TRUE,'TechRevived');
    Jump('FirstConversation');
FirstConversation:
    Log("FirstConversation");
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).TechDyingFirstConversation,TRUE);
    Talk(Sound'S2_2_2Voice.Play_22_30_01', 0, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_30_02', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_30_03', 0, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_30_04', 1, , TRUE, 0);
    Close();
    EndConversation();
    Goal_Set(1,GOAL_Action,9,,,,,'TalkDnAlEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    SendPatternEvent('TechDyingBonus','Disable');
    KillNPC(1, TRUE, FALSE);
    End();
TechRevived:
    Log("TechRevived");
    Talk(Sound'S2_2_2Voice.Play_22_31_01', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_31_02', 0, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_31_03', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_31_04', 0, , TRUE, 0);
    AddNote("", "P_2_2_2_Ktech_TechDyingBonus", "Note_0015L", "Localization\\P_2_2_2_Kalinatek");
    Talk(Sound'S2_2_2Voice.Play_22_31_05', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_31_06', 0, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_31_07', 1, , TRUE, 0);
    Close();
    EndConversation();
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkDnAlEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    SendPatternEvent('TechDyingBonus','Disable');
    KillNPC(1, FALSE, FALSE);
    End();
TechGotKilled:
    Log("TechGotKilled");
    DisableMessages(TRUE, TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkDnAlEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    KillNPC(1, FALSE, FALSE);
DoNothing:
    End();
Disable:
    Log("Disable Messages");
    DisableMessages(TRUE, FALSE);
    End();

}

