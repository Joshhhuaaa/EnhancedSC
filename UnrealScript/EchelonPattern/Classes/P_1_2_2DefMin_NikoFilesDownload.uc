//=============================================================================
// P_1_2_2DefMin_NikoFilesDownload
//=============================================================================
class P_1_2_2DefMin_NikoFilesDownload extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int One;
var int Three;
var int Two;


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
    One=0;
    Three=0;
    Two=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneNikoFilesDownload");
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).FilesDownloadDone,TRUE,'End');
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).CPUbeingAccessedFirst,TRUE,'End');
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).CPUaccessOnce,TRUE,'SecondHack');
    SendPatternEvent('GoalUpdateTemp','LambertCommFiles');
    End();
SecondHack:
    Log("SecondHack");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).FilesDownloadDone,TRUE);
    DisableMessages(TRUE, TRUE);
    LockDoor('ESwingingDoorToGangway', FALSE, TRUE);
    SendUnrealEvent('ExitNiko');
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0006L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_01', 1, 0, TR_HEADQUARTER, 0, false);
    GoalCompleted('1_2_8');
    IgnoreAlarmStage(TRUE);
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0007L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0008L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0009L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0010L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_05', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0011L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_06', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_2DefMin_NikoFilesDownload", "Speech_0012L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_55_07', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('1_2_7', "", 1, "", "P_1_2_2DefMin_NikoFilesDownload", "Goal_0022L", "Localization\\P_1_2_2DefenseMinistry", "P_1_2_2DefMin_NikoFilesDownload", "Goal_0023L", "Localization\\P_1_2_2DefenseMinistry");
    Close();
End:
    End();

}

