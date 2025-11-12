//=============================================================================
// P_1_1_1_Tbilisi_Gurgenidze
//=============================================================================
class P_1_1_1_Tbilisi_Gurgenidze extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_0Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'EBaxter0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is Gurgenidze's conversation pattern.");
    GoalCompleted('CONTACT');
    SetFlags(V1_1_0Tbilisi(Level.VarObject).GoalContact,TRUE);
    SetFlags(V1_1_0Tbilisi(Level.VarObject).GurgCanDie,TRUE);
    Talk(Sound'S1_1_0Voice.Play_11_09_01', 0, , TRUE, 0);
    Goal_Default(1,GOAL_Wait,1,,'PLAYER',,'ContactEnd','TalkDnAlNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_0Voice.Play_11_09_02', 1, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_03', 0, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_04', 1, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_05', 0, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_06', 1, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_07', 0, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_08', 1, , TRUE, 0);
    AddGoal('BLACKBOX', "", 7, "", "P_1_1_1_Tbilisi_Gurgenidze", "Goal_0012L", "Localization\\P_1_1_0Tbilisi", "P_1_1_1_Tbilisi_Gurgenidze", "Goal_0013L", "Localization\\P_1_1_0Tbilisi");
    AddNote("", "P_1_1_1_Tbilisi_Gurgenidze", "Note_0009L", "Localization\\P_1_1_0Tbilisi");
    Talk(Sound'S1_1_0Voice.Play_11_09_09', 0, , TRUE, 0);
    Talk(Sound'S1_1_0Voice.Play_11_09_10', 1, , TRUE, 0);
    SetFlags(V1_1_0Tbilisi(Level.VarObject).GurgCanDie,TRUE);
    KillNPC(1, FALSE, FALSE);
    Close();
    EndConversation();
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

