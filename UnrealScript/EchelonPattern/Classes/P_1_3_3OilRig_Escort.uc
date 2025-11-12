//=============================================================================
// P_1_3_3OilRig_Escort
//=============================================================================
class P_1_3_3OilRig_Escort extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bHubDoor1Opened;
var int BridgeTrigger;
var int Check1;
var int Check1Adam;
var int Check1Maynard;
var int Check1Piotr;
var int Check2;
var int Check2Adam;
var int Check2Maynard;
var int Check2Piotr;
var int Check3;
var int Check3Adam;
var int Check3Maynard;
var int Check3Piotr;
var int Check4Adam;
var int Check4Maynard;
var int Check4Piotr;
var int Check5Adam;
var int Check5Maynard;
var int Check5Piotr;
var int Check6;
var int Check6Adam;
var int Check6Maynard;
var int Check6Piotr;
var int CookingWithSausage;
var int DonkeyTown;
var int FirstTimeWarning;
var int KitchenPosition;
var int OverGame;
var int SecondTimeWarning;
var int SpecCase;
var int SpeechRun;
var int Started;
var int TeleportHack;
var int ThirdTimeWarning;
var int WhatWasThat;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('GameOverMan');
            break;
        case AI_GRABBED:
            EventJump('GameOverMan');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('WhatWasThat');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('WhatWasThat');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('GameOverMan');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GameOverMan');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GameOverMan');
            break;
        case AI_UNCONSCIOUS:
            EventJump('GameOverMan');
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
        if (P.name == 'EMercenaryTechnician0')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier0')
            Characters[2] = P.controller;
        if (P.name == 'EGeorgianSoldier1')
            Characters[3] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger24')
            SoundActors[0] = A;
        if (A.name == 'ESoundTrigger27')
            SoundActors[1] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    bHubDoor1Opened=0;
    BridgeTrigger=0;
    Check1=0;
    Check1Adam=0;
    Check1Maynard=0;
    Check1Piotr=0;
    Check2=0;
    Check2Adam=0;
    Check2Maynard=0;
    Check2Piotr=0;
    Check3=0;
    Check3Adam=0;
    Check3Maynard=0;
    Check3Piotr=0;
    Check4Adam=0;
    Check4Maynard=0;
    Check4Piotr=0;
    Check5Adam=0;
    Check5Maynard=0;
    Check5Piotr=0;
    Check6=0;
    Check6Adam=0;
    Check6Maynard=0;
    Check6Piotr=0;
    CookingWithSausage=0;
    DonkeyTown=0;
    FirstTimeWarning=0;
    KitchenPosition=0;
    OverGame=0;
    SecondTimeWarning=0;
    SpecCase=0;
    SpeechRun=0;
    Started=0;
    TeleportHack=0;
    ThirdTimeWarning=0;
    WhatWasThat=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BoatDock:
    Log("And so, it begins.");
    SetFlags(Started,TRUE);
    SendPatternEvent('HOSERS','Boat');
    Teleport(1, 'PiotrTele');
    Teleport(2, 'ATele');
    Teleport(3, 'BTele');
    SendPatternEvent('JustinAI','FortySixnTwo');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Piotr_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'Piotr_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,2,,,);
    Goal_Set(2,GOAL_MoveTo,8,,,,'Maynard_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,7,,,,'Maynard_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,3.25,,,);
    Goal_Set(3,GOAL_MoveTo,8,,,,'Adam_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,7,,,,'Adam_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Timer:
    Log("Time this byatch!!!");
    Sleep(96);
    SetFlags(FirstTimeWarning,TRUE);
    SendPatternEvent('LambertAI','Hurry');
    Sleep(55);
    SetFlags(SecondTimeWarning,TRUE);
    SendPatternEvent('LambertAI','HurryDeux');
    Sleep(33);
    SetFlags(ThirdTimeWarning,TRUE);
    SendPatternEvent('LambertAI','TimeOut');
    End();
BridgeZone:
    Log("Bridgezone - volume trigger sets this flag.");
    CheckFlags(BridgeTrigger,TRUE,'Null');
    SetFlags(BridgeTrigger,TRUE);
    CheckFlags(Check1,TRUE,'SassySassquatch');
    End();
Check1Maynard:
    Log("Slide a mile six inches at a time (Maynard C1)");
    SetFlags(Check1Maynard,TRUE);
    Jump('Check1Filter');
    End();
Check1Piotr:
    Log("Piotr C1- Check it, check it.");
    SetFlags(Check1Piotr,TRUE);
    Jump('Check1Filter');
    End();
Check1Adam:
    Log("What you want and what you need don't mean a thing to me (Adam C1)");
    SetFlags(Check1Adam,TRUE);
    Jump('Check1Filter');
    End();
Check1Filter:
    Log("Processing Check1 flags..");
    CheckFlags(Check1Adam,FALSE,'Null');
    CheckFlags(Check1Maynard,FALSE,'Null');
    CheckFlags(Check1Piotr,FALSE,'Null');
    SendPatternEvent('DispatcherHackerAI','Check1');
    Jump('Sassquatch');
    End();
Sassquatch:
    Log("SASSY");
    SetFlags(Check1,TRUE);
    CheckFlags(BridgeTrigger,FALSE,'Timer');
SassySassquatch:
    Log("Super sassy!");
    CheckFlags(Check1Adam,FALSE,'Null');
    CheckFlags(Check1Maynard,FALSE,'Null');
    CheckFlags(Check1Piotr,FALSE,'Null');
    SendUnrealEvent('Check1');
    End();
Jets:
    Log("What we need is jets.  We can't hope to take down a monkey of that size without jets.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,7.5,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,7.5,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,7.5,,,);
    End();
LookOut:
    Log("Incoming US attack.");
    SendUnrealEvent('FirstExplosion');
    SendPatternEvent('USCorpse','FirstExplosion');
    SendPatternEvent('JustinAI','Explosion');
    ShakeCamera(640, 16000, 3000);
    Goal_Set(1,GOAL_Action,9,,,,,'ReacStNmBB0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,9,,,,,'ReacStNmFd0',FALSE,,,,);
    Goal_Set(3,GOAL_Action,9,,,,,'ReacStAlFd0',FALSE,,,,);
    SendPatternEvent('TopDudes','Incoming');
    ChangeGroupState('s_alert');
    Talk(Sound'S1_3_3Voice.Play_13_35_01', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S1_3_3Voice.Play_13_35_02', 2, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S1_3_3Voice.Play_13_35_03', 1, , TRUE, 0);
    Sleep(0.01);
    Talk(Sound'S1_3_3Voice.Play_13_35_04', 2, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Check2Maynard:
    Log("Kinda like the way you're breathing, kinda like the way you're looking away (Maynard C2)");
    SetFlags(Check2Maynard,TRUE);
    Jump('Check2Filter');
    End();
Check2Piotr:
    Log("Piotr C2- Check it, check it.");
    SetFlags(Check2Piotr,TRUE);
    Jump('Check2Filter');
    End();
Check2Adam:
    Log("Like phosphorescent desert buttons, singing one familiar song (Adam C2)");
    SetFlags(Check2Adam,TRUE);
    Jump('Check2Filter');
    End();
Check2Filter:
    Log("Processing Check2 flags..");
    CheckFlags(Check2Adam,FALSE,'Null');
    CheckFlags(Check2Maynard,FALSE,'Null');
    CheckFlags(Check2Piotr,FALSE,'Null');
    SendUnrealEvent('Check2');
    SendPatternEvent('DispatcherHackerAI','Check2');
    End();
Check2Trigger:
    Log("SAM's 2nd checkpoint.");
    SetFlags(Check2,TRUE);
    Jump('Check3Filter');
    End();
Check3Maynard:
    Log("Find a comfortable space, that's not only comfortable, but vulnerable (Maynard C3)");
    SetFlags(Check3Maynard,TRUE);
    Jump('Check3Filter');
    End();
Check3Piotr:
    Log("Piotr C3- Check it, check it.");
    SetFlags(Check3Piotr,TRUE);
    Jump('Check3Filter');
    End();
Check3Adam:
    Log("Jesus won't you fucking whistle, something but the past and done (Adam C3)");
    SetFlags(Check3Adam,TRUE);
    Jump('Check3Filter');
    End();
Check3Filter:
    Log("Processing Check3 flags..");
    CheckFlags(Check3Adam,FALSE,'Null');
    CheckFlags(Check3Maynard,FALSE,'Null');
    CheckFlags(Check3Piotr,FALSE,'Null');
    CheckFlags(Check2,FALSE,'Check3Timer');
    SendUnrealEvent('Check3');
    SendPatternEvent('DispatcherHackerAI','Check3');
    SendUnrealEvent('MachiDistractEnableZoneAI');
    SendPatternEvent('BoomTimerAI','BoomTimerTwoThree');
    End();
Check3Timer:
    Log("Sloth timer for the second checkpoint.");
    Sleep(33);
    CheckFlags(FirstTimeWarning,TRUE,'C3T2');
    SetFlags(FirstTimeWarning,TRUE);
    SendPatternEvent('LambertAI','Hurry');
    Sleep(25);
C3T2:
    Log("First timer warning already played, skipping to next.");
    CheckFlags(SecondTimeWarning,TRUE,'C3T3');
    SetFlags(SecondTimeWarning,TRUE);
    SendPatternEvent('LambertAI','HurryDeux');
    Sleep(33);
C3T3:
    Log("Second timer warning already played, skipping to next.");
    Sleep(5);
    SendPatternEvent('LambertAI','TimeOut');
    End();
Tense:
    Log("Plays the tension creating anim.");
    SendUnrealEvent('VisionHackVol');
    Goal_Set(3,GOAL_Action,9,,,,,'LookStNmRt2',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,'endeth');
    Goal_Set(1,GOAL_Action,9,,,,,'LookStNmLt2',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,'endeth');
endeth:
    SendUnrealEvent('VisionHackVol');
    End();
Check4Maynard:
    Log("And I want you to go there, and we'll meet you on the other side... (Maynard C4)");
    SetFlags(Check4Maynard,TRUE);
    ePawn(Characters[2].Pawn).Bark_Type = BARK_NormalGreeting;
    Talk(ePawn(Characters[2].Pawn).Sounds_Barks, 2, 0, false);
    Jump('Check4Filter');
    End();
Check4Piotr:
    Log("Piotr C4- Check it, check it.");
    SetFlags(Check4Piotr,TRUE);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_NormalGreeting;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Jump('Check4Filter');
    End();
Check4Adam:
    Log("I have found some kind of sanity in this, sh!t blood and cum on my hands (Adam C4)");
    SetFlags(Check4Adam,TRUE);
    Jump('Check4Filter');
    End();
Check4Filter:
    Log("Processing Check4 flags..");
    CheckFlags(Check4Adam,FALSE,'Null');
    CheckFlags(Check4Maynard,FALSE,'Null');
    CheckFlags(Check4Piotr,FALSE,'Null');
    CheckFlags(Check3,FALSE,'Check4Timer');
    SendUnrealEvent('Check4');
    SendPatternEvent('DispatcherHackerAI','Check4');
    SendPatternEvent('BoomTimerAI','BoomTimerThreeFour');
    End();
Check3Trigger:
    Log("SAM's 3rd checkpoint.");
    SetFlags(Check3,TRUE);
    Jump('Check4Filter');
    End();
Check4Timer:
    Log("Sloth timer for the third checkpoint.");
    Sleep(22);
    CheckFlags(FirstTimeWarning,TRUE,'C4T2');
    SetFlags(FirstTimeWarning,TRUE);
    SendPatternEvent('LambertAI','Hurry');
    Sleep(22);
C4T2:
    Log("First timer warning already played, skipping to next.");
    CheckFlags(SecondTimeWarning,TRUE,'C4T3');
    SetFlags(SecondTimeWarning,TRUE);
    SendPatternEvent('LambertAI','HurryDeux');
    Sleep(20);
C4T3:
    Log("Second timer warning already played, YOU'RE SCREWED, BYATCH!!");
    Sleep(5);
    SendPatternEvent('LambertAI','TimeOut');
    End();
Check5Maynard:
    Log("Shrouding all the ground around me is this holy crow above me (Maynard C5)");
    CheckFlags(SpeechRun,TRUE,'SpecCase');
    SetFlags(Check5Maynard,TRUE);
    Jump('Check5Filter');
    End();
Check5Piotr:
    Log("Piotr C5- Check it, check it.");
    CheckFlags(SpeechRun,TRUE,'SpecCase');
    SetFlags(Check5Piotr,TRUE);
    Jump('Check5Filter');
    End();
Check5Adam:
    Log("I just want to start this over (Adam C5)");
    CheckFlags(SpeechRun,TRUE,'SpecCase');
    SetFlags(Check5Adam,TRUE);
    Jump('Check5Filter');
    End();
Check5Filter:
    Log("Processing Check5 flags..");
    CheckFlags(Check5Adam,FALSE,'Null');
    CheckFlags(Check5Maynard,FALSE,'Null');
    CheckFlags(Check5Piotr,FALSE,'Null');
    SetFlags(KitchenPosition,TRUE);
    SendPatternEvent('DispatcherHackerAI','Check5');
    SendPatternEvent('BoomTimerAI','BoomTimerFourFive');
    Jump('ArriveAtDeadEnd');
    End();
ArriveAtDeadEnd:
    Log("When the group arrives at the dead end.");
    SetFlags(CookingWithSausage,TRUE);
    CheckFlags(DonkeyTown,TRUE,'Inroom');
    Jump('NotThere');
    End();
NotThere:
    Log("Uh oh Sam, you're too slow..");
    Sleep(33);
    CheckFlags(FirstTimeWarning,TRUE,'natchtwo');
    SetFlags(FirstTimeWarning,TRUE);
    SendPatternEvent('LambertAI','Hurry');
    Sleep(25);
natchtwo:
    CheckFlags(SecondTimeWarning,TRUE,'natchthree');
    SetFlags(SecondTimeWarning,TRUE);
    SendPatternEvent('LambertAI','HurryDeux');
    Sleep(20);
natchthree:
    Sleep(3);
    SetFlags(ThirdTimeWarning,TRUE);
    SendPatternEvent('LambertAI','TimeOut');
    End();
Inroom:
    Log("When Samuel Sophocles Fisher enters the room.");
    SetFlags(DonkeyTown,TRUE);
    CheckFlags(CookingWithSausage,FALSE,'Null');
    CheckFlags(KitchenPosition,TRUE,'DeadEndSpeech');
DeadEndSpeech:
    Log("Runs the dead end speech pattern, and sends the group back from whence they came.");
    SetFlags(SpeechRun,TRUE);
    SendPatternEvent('BoomTimerAI','DelayedPK');
    Talk(Sound'S1_3_3Voice.Play_13_30_01', 2, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_30_02', 3, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_30_03', 2, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_30_04', 1, , TRUE, 0);
    Talk(Sound'S1_3_3Voice.Play_13_30_05', 2, , TRUE, 0);
    SendUnrealEvent('Check5');
    Talk(Sound'S1_3_3Voice.Play_13_30_06', 3, , TRUE, 0);
    Close();
    End();
SpecCase:
    Log("Special event for fuck up of dead end dialog.");
    CheckFlags(SpecCase,TRUE,'Null');
    SetFlags(SpecCase,TRUE);
    SendUnrealEvent('Check5');
    End();
    Log("Into the hub.  Hakuna matada.");
Check6Maynard:
    Log("");
    SetFlags(Check6Maynard,TRUE);
    Jump('Check6Filter');
    End();
Check6Piotr:
    Log("");
    SetFlags(Check6Piotr,TRUE);
    Jump('Check6Filter');
    End();
Check6Adam:
    Log("");
    SetFlags(Check6Adam,TRUE);
    Jump('Check6Filter');
    End();
Check6Filter:
    Log("");
    CheckFlags(Check6Adam,FALSE,'Null');
    CheckFlags(Check6Maynard,FALSE,'Null');
    CheckFlags(Check6Piotr,FALSE,'Null');
    SendUnrealEvent('Check6');
    SendPatternEvent('DispatcherHackerAI','Check6');
    CheckFlags(bHubDoor1Opened,TRUE,'Null');
    SetFlags(bHubDoor1Opened,TRUE);
    SendUnrealEvent('HubDoor1');
    End();
Skipper:
    Log("Skip trigger activated.");
    CheckFlags(Started,TRUE,'Null');
Slam:
    Log("Sheh de doh!");
    SendPatternEvent('escort2AI','KitchenFlag');
    SendUnrealEvent('HubDoor1');
    ShakeCamera(1200, 17000, 3000);
	SoundActors[0].    PlaySound(Sound'DestroyableObjet.Play_ExplosionBridge', SLOT_SFX);
    Log("Energize.");
    Teleport(1, 'TexasSwitch1');
    Teleport(2, 'TexasSwitch2');
    Teleport(3, 'TexasSwitch3');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,0,,,,'TexasSwitch1',,FALSE,,,,);
    Goal_Default(2,GOAL_Guard,0,,,,'TexasSwitch2',,FALSE,,,,);
    Goal_Default(3,GOAL_Guard,0,,,,'TexasSwitch3',,FALSE,,,,);
    SendUnrealEvent('JedDisable');
    SendPatternEvent('escort2AI','PostHub');
    SendPatternEvent('Merctech2AI','RunAway');
    Sleep(0.2);
	SoundActors[1].    PlaySound(Sound'DestroyableObjet.Play_BarrilExplosion', SLOT_SFX);
    Sleep(2.75);
    SendPatternEvent('LambertAI','TechniCase');
    End();
GameOverMan:
    Log("We just got our asses kicked back there pal!");
    DisableMessages(TRUE, TRUE);
    CheckFlags(OverGame,TRUE,'Null');
ReallyOver:
    Log("Redundancy check completed.");
    SetExclusivity(FALSE);
    ePawn(Characters[2].Pawn).Bark_Type = BARK_SeePlayer;
    Talk(ePawn(Characters[2].Pawn).Sounds_Barks, 2, 0, false);
    ePawn(Characters[3].Pawn).Bark_Type = BARK_SeePlayer;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    SetFlags(OverGame,TRUE);
    SendPatternEvent('LambertAI','Over');
    End();
Null:
    Log("Null.");
    End();
WhatWasThat:
    Log("Escort group has heard something, pausing the mojo.");
    CheckFlags(WhatWasThat,TRUE,'Null');
    SetFlags(WhatWasThat,TRUE);
    SendPatternEvent('HOSERS','EscortTimer');
    ePawn(Characters[3].Pawn).Bark_Type = BARK_HeardFoot;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    JumpRandom('TierOne', 0.50, 'TierTwo', 1.00, , , , , ,); 
    End();
TierOne:
    Log("WhatWasThat Stop Randomizer Tier 1.");
    JumpRandom('WWTSCOne', 0.20, 'WWTSCTwo', 0.40, 'WWTSCThree', 0.60, 'WWTSCFour', 0.80, 'WWTSCFive', 1.00); 
    End();
WWTSCOne:
    Log("WhatWasThat Stop Config 1.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,3,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,4,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,1,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,7,,,);
    End();
WWTSCTwo:
    Log("WhatWasThat Stop Config 2.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,2,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,5,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.4,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.6,,,);
    Goal_Set(3,GOAL_Stop,9,,'PLAYER','PLAYER',,,FALSE,7,,,);
    End();
WWTSCThree:
    Log("WhatWasThat Stop Config 3.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,1,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,2,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,5,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,1.5,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,5.5,,,);
    End();
WWTSCFour:
    Log("WhatWasThat Stop Config 4.");
    Goal_Set(1,GOAL_Action,9,,,,,'PrsoStNmBB0',FALSE,,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.5,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.75,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.25,,,);
    Goal_Set(3,GOAL_Stop,9,,'PLAYER','PLAYER',,,FALSE,7,,,);
    End();
WWTSCFive:
    Log("WhatWasThat Stop Config 5.");
    Goal_Set(1,GOAL_Action,9,,'PLAYER','PLAYER',,'LookStNmFd0',FALSE,,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.5,,,);
    Goal_Set(2,GOAL_Stop,9,,'PLAYER','PLAYER',,,FALSE,7,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,1,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6,,,);
    End();
WWTSC2One:
    Log("WhatWasThat Stop Tier 2 Config 1.");
    Goal_Set(1,GOAL_Wait,9,,,,,'PrsoCrAlCC0',FALSE,,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.25,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.75,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,1.69,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,5.31,,,);
    End();
WWTSC2Two:
    Log("WhatWasThat Stop Tier 2 Config 2.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,0.75,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.25,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.5,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.5,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,0.25,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.75,,,);
    End();
WWTSC2Three:
    Log("WhatWasThat Stop Tier 2 Config 3.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,0.4,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.6,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.1,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.9,,,);
    Goal_Set(3,GOAL_Stop,9,,,,,,FALSE,0.35,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.65,,,);
    End();
WWTSC2Four:
    Log("WhatWasThat Stop Tier 2 Config 4.");
    Goal_Set(1,GOAL_Action,9,,,,,'PrsoStNmAA0',FALSE,,,,);
    Goal_Set(1,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,7,,,);
    Goal_Set(2,GOAL_Action,9,,,,,'FireStAlEd0',FALSE,,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,7,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,7,,,);
    End();
WWTSC2Five:
    Log("WhatWasThat Stop Tier 2 Config 5.");
    Goal_Set(1,GOAL_Stop,8,,,,,,FALSE,7,,,);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.69,,,);
    Goal_Set(2,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,6.31,,,);
    Goal_Set(3,GOAL_Stop,8,,'PLAYER','PLAYER',,,FALSE,7,,,);
    End();
TierTwo:
    Log("WhatWasThat Stop Randomizer Tier 1.");
    JumpRandom('WWTSC2One', 0.20, 'WWTSC2Two', 0.40, 'WWTSC2Three', 0.60, 'WWTSC2Four', 0.80, 'WWTSC2Five', 1.00); 
    End();
CancelStop:
    Log("Breaks the escort out of stop.");
    SetFlags(WhatWasThat,FALSE);
    ResetGroupGoals();
    End();

}

