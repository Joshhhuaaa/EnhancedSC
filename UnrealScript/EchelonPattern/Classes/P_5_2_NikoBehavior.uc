//=============================================================================
// P_5_2_NikoBehavior
//=============================================================================
class P_5_2_NikoBehavior extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\FisherVoice.uax
#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DontMove;
var int GuysAreHere;
var int LambertHasSpoken;
var int NikoIsTeleported;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('DeadCheck');
            break;
        case AI_RELEASED:
            EventJump('Released');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadCheck');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ENikoladze1')
            Characters[1] = P.controller;
        if(P.name == 'ELambert0')
            Characters[2] = P.controller;
        if(P.name == 'EEliteForceCristavi1')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bBlockDetection = true;
            EAIController(Characters[3]).bWasFound = true;
        }
        if(P.name == 'EEliteForceCristavi4')
        {
            Characters[4] = P.controller;
            EAIController(Characters[4]).bAllowKnockout = true;
            EAIController(Characters[4]).bBlockDetection = true;
            EAIController(Characters[4]).bWasFound = true;
        }
        if(P.name == 'EEliteForceCristavi2')
        {
            Characters[5] = P.controller;
            EAIController(Characters[5]).bAllowKnockout = true;
            EAIController(Characters[5]).bBlockDetection = true;
            EAIController(Characters[5]).bWasFound = true;
        }
        if(P.name == 'EEliteForceCristavi7')
        {
            Characters[6] = P.controller;
            EAIController(Characters[6]).bAllowKnockout = true;
            EAIController(Characters[6]).bBlockDetection = true;
            EAIController(Characters[6]).bWasFound = true;
        }
        if(P.name == 'EEliteForceCristavi3')
        {
            Characters[7] = P.controller;
            EAIController(Characters[7]).bAllowKnockout = true;
            EAIController(Characters[7]).bBlockDetection = true;
            EAIController(Characters[7]).bWasFound = true;
        }
        if(P.name == 'EEliteForceCristavi14')
        {
            Characters[8] = P.controller;
            EAIController(Characters[8]).bAllowKnockout = true;
            EAIController(Characters[8]).bBlockDetection = true;
            EAIController(Characters[8]).bWasFound = true;
        }
        if(P.name == 'EEliteForceCristavi13')
        {
            Characters[9] = P.controller;
            EAIController(Characters[9]).bAllowKnockout = true;
            EAIController(Characters[9]).bBlockDetection = true;
            EAIController(Characters[9]).bWasFound = true;
        }
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EEliteForceCristavi1')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    DontMove=1;
    GuysAreHere=0;
    LambertHasSpoken=0;
    NikoIsTeleported=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    Goal_Set(1,GOAL_Wait,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Goal_Default(1,GOAL_Wait,1,,,,,'ReacStNmFd0',FALSE,,,,);
    Talk(Sound'S5_1_2Voice.Play_51_50_01', 1, , TRUE, 0);
    Close();
    Sleep(3);
    Goal_Set(1,GOAL_Action,9,,'Nbac','Nbac',,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S5_1_2Voice.Play_51_50_02', 1, , TRUE, 0);
    Close();
    Sleep(2);
    Goal_Set(1,GOAL_Action,9,,'NikoCrazyTwo','NikoCrazyTwo',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S5_1_2Voice.Play_51_51_01', 1, , TRUE, 0);
    Close();
    Sleep(1);
    Talk(Sound'S5_1_2Voice.Play_51_51_02', 1, , TRUE, 0);
    Close();
    Sleep(2);
    Goal_Set(1,GOAL_Action,9,,'NA','NA',,'ReacStNmFd0',FALSE,,,,);
    Talk(Sound'S5_1_2Voice.Play_51_51_03', 1, , TRUE, 0);
    Close();
    Sleep(3);
    Talk(Sound'S5_1_2Voice.Play_51_51_04', 1, , TRUE, 0);
    Close();
    Sleep(4);
    Goal_Set(1,GOAL_Action,9,,'Nbac','Nbac',,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S5_1_2Voice.Play_51_51_05', 1, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,,,,'ReacStNmFd0',FALSE,,,,);
    End();
DeadCheck:
    Log("DeadCheck");
    CheckIfIsDead(1,'NikoHasBeenKilledOrKnocked');
    CheckIfIsUnconscious(1,'NikoHasBeenKilledOrKnocked');
    CheckFlags(V5_1_2_PresidentialPalace(Level.VarObject).DarknessVault,TRUE,'End');
    CheckFlags(GuysAreHere,TRUE,'KillNikoAndPlayerBecauseMoved');
    End();
NikoHasBeenKilledOrKnocked:
    Log("NikoHasBeenKilledOrKnocked");
    CheckFlags(NikoIsTeleported,TRUE,'End');
    CheckFlags(GuysAreHere,TRUE,'makeplayerkillhere');
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_5_2_NikoBehavior", "Speech_0003L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_91_01', 2, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_5_2_NikoBehavior", "Speech_0004L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_91_02', 0, 0, TR_CONVERSATION, 0, true);
    Speech(Localize("P_5_2_NikoBehavior", "Speech_0005L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_91_03', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
RetinalWOWSequence:
    Log("RetinalWOWSequence");
    Close();
    SendPatternEvent('testinterroBad','StopTalkInt');
    SendPatternEvent('LibraryMassacre','FakeEliteCrisAttack');
    SendPatternEvent('BeAsIce','Cycle');
    GoalCompleted('Retinal');
    GoalCompleted('Ark');
    SetExclusivity(TRUE);
    SetFlags(GuysAreHere,TRUE);
    ResetGoals(3);
    ResetGoals(6);
    ResetGoals(5);
    ResetGoals(4);
    ResetGoals(7);
    ResetGoals(8);
    ResetGoals(9);
    Teleport(3, 'PathTelOneOfSeven');
    Teleport(6, 'PathTelTwoOfSeven');
    Teleport(5, 'BasementBloodbathStart5');
    Teleport(4, 'EscortServA');
    Teleport(7, 'BasementBloodbathStart3');
    Teleport(8, 'BasementBloodbathStart2');
    Teleport(9, 'BasementBloodbathStart1');
    Goal_Set(3,GOAL_MoveTo,9,,,,'NikoPosition',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,'NikoAfterReleaseAA','NikoAfterReleaseAA','NikoPosition',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(6,GOAL_MoveTo,9,,,,'EscortPosition',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(6,GOAL_Guard,8,,'PLAYER','PLAYER','EscortPosition',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(5,GOAL_MoveTo,9,,,,'NewTelForSecMeat',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(5,GOAL_Guard,8,,'PLAYER','PLAYER','NewTelForSecMeat',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,9,,,,'NewPositionForSix',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Guard,8,,'PLAYER','PLAYER','NewPositionForSix',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(7,GOAL_MoveTo,9,,,,'EscortPositionfrooo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(7,GOAL_Guard,8,,'PLAYER','PLAYER','EscortPositionfrooo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(8,GOAL_MoveTo,9,,,,'CoverSyandBy',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(8,GOAL_Guard,8,,'PLAYER','PLAYER','CoverSyandBy',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(9,GOAL_MoveTo,9,,,,'BetterPosichionA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(9,GOAL_Guard,8,,'PLAYER','PLAYER','BetterPosichionA',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(1);
    Talk(Sound'S5_1_2Voice.Play_51_55_01', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_02', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_03', 3, , TRUE, 0);
    Close();
    End();
Released:
    Log("Released");
    AddNote("", "P_5_2_NikoBehavior", "Note_0033L", "Localization\\P_5_1_2_PresidentialPalace");
	PlaySound(Sound'FisherVoice.Play_Sq_FisherHeartBeat', SLOT_Ambient);
    CheckFlags(GuysAreHere,FALSE,'End');
    SetFlags(V5_1_2_PresidentialPalace(Level.VarObject).NowSurrounded,TRUE);
    ResetGoals(1);
    ChangeState(1,'s_default');
    Goal_Set(1,GOAL_MoveTo,9,,,,'NikoAfterReleaseAA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,8,,,,'BasementBloodbathElite1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
    Talk(Sound'S5_1_2Voice.Play_51_55_04', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_05', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_06', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_07', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_08', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_09', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_10', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_11', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_12', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_13', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_14', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_15', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_16', 3, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_17', 1, , TRUE, 0);
    Talk(Sound'S5_1_2Voice.Play_51_55_18', 3, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'NikoTalking',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'EscortServA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,7,,,,'OhMickeyYouSoFineA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,6,,,,'OhMickeyYouSoFineA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    ResetGoals(3);
    Goal_Default(3,GOAL_Guard,9,,'PLAYER','PLAYER','NikoPosition',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S5_1_2Voice.Play_51_55_19', 3, , TRUE, 0);
    ResetGoals(6);
    Goal_Set(6,GOAL_MoveTo,9,,,,'EscortServA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(6,GOAL_MoveTo,8,,,,'OhMickeyYouSoFineA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(6,GOAL_Guard,7,,,,'OhMickeyYouSoFineA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Close();
    ResetGoals(8);
    Goal_Set(8,GOAL_MoveTo,9,,,,'EscortServA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(8,GOAL_MoveTo,8,,,,'OhMickeyYouSoFineA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(8,GOAL_Guard,7,,,,'OhMickeyYouSoFineA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(2);
    SendUnrealEvent('SaveWhoAreYou');
    Sleep(1);
    Speech(Localize("P_5_2_NikoBehavior", "Speech_0007L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_56_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(2);
    Talk(Sound'S5_1_2Voice.Play_51_57_01', 3, , TRUE, 0);
    Close();
lightsOFF:
    Log("lightsOFF");
    SendUnrealEvent('DARKNESS');
    SendUnrealEvent('ESam');
    SendPatternEvent('BeAsIce','End');
    SetFlags(DontMove,FALSE);
    SetFlags(V5_1_2_PresidentialPalace(Level.VarObject).DarknessVault,TRUE);
    DisableMessages(TRUE, FALSE);
    ePawn(Characters[3].Pawn).Bark_Type = BARK_LightsOut;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    Goal_Set(3,GOAL_Action,9,,,,,'ReacStAlFd0',FALSE,,,,);
    Goal_Set(5,GOAL_Action,9,,,,,'ReacStAlFd0',FALSE,,,,);
    Goal_Set(4,GOAL_Action,9,,,,,'ReacStNmFd0',FALSE,,,,);
    Goal_Set(7,GOAL_Action,9,,,,,'ReacStAlFd0',FALSE,,,,);
    Goal_Set(9,GOAL_Action,9,,,,,'ReacStNmFd0',FALSE,,,,);
    Sleep(4);
	PlaySound(Sound'FisherVoice.Stop_Sq_FisherHeartBeat', SLOT_Ambient);
	SoundActors[0].PlaySound(Sound'FisherEquipement.Play_GoggleRun', SLOT_SFX);
    ResetGoals(3);
    ResetGoals(5);
    ResetGoals(4);
    ResetGoals(7);
    ResetGoals(9);
    ChangeState(3,'s_alert');
    ChangeState(5,'s_alert');
    ChangeState(4,'s_alert');
    ChangeState(7,'s_alert');
    ChangeState(9,'s_alert');
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'CornerVaultCaas',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'PLAYER','PLAYER','CornerVaultCaas',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(5,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','CornerVaultCaas',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(5,GOAL_Attack,8,,'PLAYER','PLAYER','CornerVaultCaas',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveAndAttack,9,,,,'CoverSyandBy',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(4,GOAL_Attack,8,,'PLAYER','PLAYER','CoverSyandBy',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(7,GOAL_MoveAndAttack,9,,,,'CoverExitaassw',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(7,GOAL_MoveAndAttack,8,,,,'WayToLibThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(7,GOAL_Attack,7,,'PLAYER','PLAYER','WayToLibThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(9,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','NikoTalking',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(9,GOAL_Attack,8,,'PLAYER','PLAYER','NikoTalking',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
JumpFromThreeStooges:
    Log("JumpFromThreeStooges");
    Teleport(1, 'TelNPCOFFa');
    SetFlags(NikoIsTeleported,TRUE);
    Teleport(6, 'TelNPCOFFb');
    Teleport(8, 'TelNPCOFFc');
    KillNPC(6, FALSE, FALSE);
    KillNPC(8, FALSE, FALSE);
    KillNPC(1, FALSE, FALSE);
    End();
KillNikoAndPlayerBecauseMoved:
    Log("KillNikoAndPlayerBecauseMoved");
    CheckFlags(V5_1_2_PresidentialPalace(Level.VarObject).DarknessVault,TRUE,'End');
    CheckFlags(GuysAreHere,FALSE,'End');
makeplayerkillhere:
    Log("makeplayerkillhere");
    Close();
    ePawn(Characters[3].Pawn).Bark_Type = BARK_ShootHim;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    ResetGoals(9);
    ResetGoals(8);
    ResetGoals(7);
    ResetGoals(4);
    ResetGoals(5);
    ResetGoals(6);
    ResetGoals(3);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'WayToLibOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Goal_Default(8,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Goal_Default(6,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Goal_Default(5,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Goal_Default(4,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Goal_Default(7,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Goal_Default(9,GOAL_Attack,9,,'PLAYER','PLAYER',,,TRUE,,,,);
    Sleep(1);
    ResetGoals(9);
    ResetGoals(8);
    ResetGoals(7);
    ResetGoals(4);
    ResetGoals(5);
    ResetGoals(6);
    ResetGoals(3);
    Goal_Default(9,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Goal_Default(8,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Goal_Default(7,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Goal_Default(4,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Goal_Default(5,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Goal_Default(6,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Goal_Default(3,GOAL_Attack,9,,'NikoSucks','NikoSucks',,,FALSE,,,,);
    Sleep(0.25);
    KillNPC(0, FALSE, FALSE);
    Sleep(0.50);
    SetExclusivity(FALSE);
    End();
TeleportThreeStooges:
    Log("TeleportThreeStooges");
    DisableMessages(TRUE, TRUE);
    SetExclusivity(TRUE);
    ResetGoals(3);
    ResetGoals(5);
    ResetGoals(4);
    ResetGoals(7);
    ResetGoals(9);
    ChangeGroupState('s_default');
    Goal_Default(3,GOAL_Search,9,,,,'CornerVaultCaas',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(5,GOAL_Search,9,,,,'SearchTestLas',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(4,GOAL_Search,9,,,,'OtherVaultSeercha',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(7,GOAL_Search,9,,,,'NearVaultExcar',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(9,GOAL_Search,9,,,,'BasementBloodbathStart5',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(0.50);
    SetExclusivity(FALSE);
    End();
LambertWantsNikoDead:
    Log("LambertWantsNikoDead");
    CheckFlags(DontMove,TRUE,'End');
    CheckFlags(LambertHasSpoken,TRUE,'End');
    SetFlags(LambertHasSpoken,TRUE);
    SendPatternEvent('GoalBogus','NikoKillOrder');
    Jump('TeleportThreeStooges');
End:
    End();

}

