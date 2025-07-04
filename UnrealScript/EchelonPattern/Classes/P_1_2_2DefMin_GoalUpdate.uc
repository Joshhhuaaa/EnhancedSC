//=============================================================================
// P_1_2_2DefMin_GoalUpdate
//=============================================================================
class P_1_2_2DefMin_GoalUpdate extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_2Voice.uax

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
LambertCommFiles:
    Log("LambertCommFiles");
    LockDoor('FireDoor', FALSE, TRUE);
    SendPatternEvent('SeekAndDestroyFirst','Milestone');
    GoalCompleted('1_2_6');
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).CPUbeingAccessedFirst,TRUE);
    Speech(Localize("P_1_2_2DefMin_GoalUpdate", "Speech_0022L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_50_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_2DefMin_GoalUpdate", "Speech_0023L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_50_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_2DefMin_GoalUpdate", "Speech_0024L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_50_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_2DefMin_GoalUpdate", "Speech_0025L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_50_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_2DefMin_GoalUpdate", "Speech_0026L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_50_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    SendPatternEvent('SeekAndDestroyFirst','AfterCPUFiles');
    Sleep(38);
    AddGoal('1_2_8', "", 3, "", "P_1_2_2DefMin_GoalUpdate", "Goal_0030L", "Localization\\P_1_2_2DefenseMinistry", "P_1_2_2DefMin_GoalUpdate", "Goal_0031L", "Localization\\P_1_2_2DefenseMinistry");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).CPUbeingAccessedFirst,FALSE);
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).CPUaccessOnce,TRUE);
    Speech(Localize("P_1_2_2DefMin_GoalUpdate", "Speech_0027L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_51_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();

}

