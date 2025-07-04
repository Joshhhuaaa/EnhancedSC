//=============================================================================
// P_2_2_1_Ktech_Communications
//=============================================================================
class P_2_2_1_Ktech_Communications extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MapStartLambertCom:
    Log("First Lambert Communication");
    AddGoal('Infiltrate', "", 1, "", "P_2_2_1_Ktech_Communications", "Goal_0023L", "Localization\\P_2_2_1_Kalinatek", "P_2_2_1_Ktech_Communications", "Goal_0024L", "Localization\\P_2_2_1_Kalinatek");
    AddGoal('FindIvan', "", 6, "", "P_2_2_1_Ktech_Communications", "Goal_0020L", "Localization\\P_2_2_1_Kalinatek", "P_2_2_1_Ktech_Communications", "Goal_0025L", "Localization\\P_2_2_1_Kalinatek");
    AddGoal('FireAlarm', "", 5, "", "P_2_2_1_Ktech_Communications", "Goal_0021L", "Localization\\P_2_2_1_Kalinatek", "P_2_2_1_Ktech_Communications", "Goal_0026L", "Localization\\P_2_2_1_Kalinatek");
    AddRecon(class 'EReconFullTextCall911');
    AddRecon(class 'EReconMapKalinatek');
    Speech(Localize("P_2_2_1_Ktech_Communications", "Speech_0001L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_05_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_1_Ktech_Communications", "Speech_0002L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_05_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_1_Ktech_Communications", "Speech_0003L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_05_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_1_Ktech_Communications", "Speech_0004L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_05_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_1_Ktech_Communications", "Speech_0005L", "Localization\\P_2_2_1_Kalinatek"), Sound'S2_2_1Voice.Play_22_05_05', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
InfiltrateDone:
    Log("When Sam Infiltrates the Kalinatek");
    GoalCompleted('Infiltrate');
    End();
LevelChange:
    Log("Shake the camera then level change");
    SendUnrealEvent('Elevator');
    ShakeCamera(200, 55000, 50);
    Sleep(1.5);
    LevelChange("2_2_2_Kalinatek.unr");
    End();

}

