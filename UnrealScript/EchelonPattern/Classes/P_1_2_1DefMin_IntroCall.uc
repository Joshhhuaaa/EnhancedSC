//=============================================================================
// P_1_2_1DefMin_IntroCall
//=============================================================================
class P_1_2_1DefMin_IntroCall extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

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
    local ESoundVolume SoundVolume;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    // Joshua - Defense Ministry requires 1 bullet to shoot a unavoidable camera for Elite mode
    if (!bInit && EchelonGameInfo(Level.Game).bEliteMode && EPlayerController(Characters[0]) != None && EPlayerController(Characters[0]).HandGun != None)
    {
        if (EPlayerController(Characters[0]).HandGun.Ammo == 0 && EPlayerController(Characters[0]).HandGun.ClipAmmo == 0 && EPlayerController(Characters[0]).playerStats.BulletFired == 0)
        {
            EPlayerController(Characters[0]).HandGun.Ammo = 1;
            EPlayerController(Characters[0]).HandGun.ClipAmmo = 1;
        }
    }

    // Joshua - Fixes sound volume that has incorrect sound slot assigned
    if (!bInit)
    {
        ForEach AllActors(class'ESoundVolume', SoundVolume)
        {
            if (SoundVolume.name == 'ESoundVolume4')
                SoundVolume.m_eSoundSlot = SLOT_SFX;
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
Milestone:
    Log("MilestoneIntroCall");
    //SetAlarmStage(3); // Joshua - Using new bOneAlarmLevel flag instead
    Sleep(0.50);
    AddRecon(class 'EReconMapMinistry');
    AddRecon(class 'EReconPicGrinko');
    AddRecon(class 'EReconFullTextGrinko');
    SendUnrealEvent('BogusElevator');
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_10_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0007L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_10_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0008L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_10_03', 1, 1, TR_HEADQUARTER, 0, false);
    AddNote("", "P_1_2_1DefMin_IntroCall", "Note_0019L", "Localization\\P_1_2_1DefenseMinistry");
    AddNote("", "P_1_2_1DefMin_IntroCall", "Note_0020L", "Localization\\P_1_2_1DefenseMinistry");
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0009L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_10_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0010L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_10_05', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('1_2_1', "", 8, "", "P_1_2_1DefMin_IntroCall", "Goal_0021L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_IntroCall", "Goal_0022L", "Localization\\P_1_2_1DefenseMinistry");
    AddGoal('1_2_2', "", 9, "", "P_1_2_1DefMin_IntroCall", "Goal_0023L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_IntroCall", "Goal_0024L", "Localization\\P_1_2_1DefenseMinistry");
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0011L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_10_06', 0, 0, TR_CONVERSATION, 0, false);
    Close();
    Sleep(1);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).WestWingFastDone,TRUE,'FistGoalAlreadyCompleted');
    Sleep(0.50);
JumpHere:
    Log("JumpHere");
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0012L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_11_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0013L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_11_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_IntroCall", "Speech_0014L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_11_03', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('1_2_11', "", 10, "", "P_1_2_1DefMin_IntroCall", "Goal_0025L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_IntroCall", "Goal_0026L", "Localization\\P_1_2_1DefenseMinistry");
    Close();
    End();
FistGoalAlreadyCompleted:
    Log("FistGoalAlreadyCompleted");
    GoalCompleted('1_2_1');
    Sleep(0.50);
    Jump('JumpHere');
End:
    End();

}

