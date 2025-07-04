//=============================================================================
// P_1_2_1DefMin_LambertWantsLaser
//=============================================================================
class P_1_2_1DefMin_LambertWantsLaser extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

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
Milestone:
    Log("MilestoneLambertWantsLaser");
    Sleep(2);
    AddRecon(class 'EReconPicMasse');
    AddRecon(class 'EReconFullTextMasse');
    Speech(Localize("P_1_2_1DefMin_LambertWantsLaser", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_20_01', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('1_2_4', "", 7, "", "P_1_2_1DefMin_LambertWantsLaser", "Goal_0013L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_LambertWantsLaser", "Goal_0014L", "Localization\\P_1_2_1DefenseMinistry");
    Speech(Localize("P_1_2_1DefMin_LambertWantsLaser", "Speech_0006L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_20_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_LambertWantsLaser", "Speech_0007L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_20_03', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('1_2_3', "", 5, "", "P_1_2_1DefMin_LambertWantsLaser", "Goal_0015L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_LambertWantsLaser", "Goal_0016L", "Localization\\P_1_2_1DefenseMinistry");
    AddGoal('1_2_9', "", 6, "", "P_1_2_1DefMin_LambertWantsLaser", "Goal_0017L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_LambertWantsLaser", "Goal_0018L", "Localization\\P_1_2_1DefenseMinistry");
    Close();
    SendUnrealEvent('KitSave');
    End();

}

