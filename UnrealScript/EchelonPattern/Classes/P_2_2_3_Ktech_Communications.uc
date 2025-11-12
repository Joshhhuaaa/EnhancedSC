//=============================================================================
// P_2_2_3_Ktech_Communications
//=============================================================================
class P_2_2_3_Ktech_Communications extends EPattern;

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

    // Joshua - Replace NPC skins for variety
    if (!bInit)
    {
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EMafiaMuscle2' || P.name == 'EMafiaMuscle5' || P.name =='EMafiaMuscle8' || P.name =='EMafiaMuscle12' || P.name == 'EMafiaMuscle16' || P.name == 'EMafiaMuscle19')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Grunt.GruntA", class'Texture'));
            }
            if (P.name == 'EMafiaMuscle6' || P.name == 'EMafiaMuscle10' || P.name == 'EMafiaMuscle14' || P.name == 'EMafiaMuscle18')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Grunt.GruntB", class'Texture'));
            }
        }
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
MapStartGoals:
    Log("Set the goals, notes and recons");
    AddGoal('Infiltrate', "", 1, "", "P_2_2_3_Ktech_Communications", "Goal_0001L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0009L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('FuseBox', "", 8, "", "P_2_2_3_Ktech_Communications", "Goal_0002L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0010L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('FireAlarm', "", 5, "", "P_2_2_3_Ktech_Communications", "Goal_0003L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0011L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('FindIvan', "", 6, "", "P_2_2_3_Ktech_Communications", "Goal_0004L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0012L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('Hostages', "", 2, "", "P_2_2_3_Ktech_Communications", "Goal_0005L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0013L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('HostagesAlive', "", 8, "", "P_2_2_3_Ktech_Communications", "Goal_0006L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0014L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('LeaveIvan', "", 7, "", "P_2_2_3_Ktech_Communications", "Goal_0007L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0015L", "Localization\\P_2_2_3_Kalinatek");
    AddGoal('ClearTheRoof', "", 9, "", "P_2_2_3_Ktech_Communications", "Goal_0008L", "Localization\\P_2_2_3_Kalinatek", "P_2_2_3_Ktech_Communications", "Goal_0016L", "Localization\\P_2_2_3_Kalinatek");
    GoalCompleted('Infiltrate');
    GoalCompleted('FuseBox');
    GoalCompleted('FireAlarm');
    GoalCompleted('FindIvan');
    GoalCompleted('Hostages');
    GoalCompleted('HostagesAlive');
    GoalCompleted('LeaveIvan');
    AddNote("", "P_2_2_3_Ktech_Communications", "Note_0017L", "Localization\\P_2_2_3_Kalinatek");
    AddNote("", "P_2_2_3_Ktech_Communications", "Note_0018L", "Localization\\P_2_2_3_Kalinatek");
    AddRecon(class 'EReconFullTextCall911');
    AddRecon(class 'EReconMapKalinatek');
    End();

}

