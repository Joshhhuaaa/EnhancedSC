//=============================================================================
// P_1_3_3OilRig_TopDudes
//=============================================================================
class P_1_3_3OilRig_TopDudes extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Vehicules.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Incoming;
var int Skip;


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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'EGeorgianSoldier11')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EAnimatedObject3')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Incoming=0;
    Skip=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Incoming:
    Log("The start of the US attack.");
    Sleep(5);
    SendPatternEvent('LambertAI','Attack');
    End();
IncomingDeux:
    Log("For checkpoint mojoooo.");
    Goal_Set(1,GOAL_MoveTo,9,,,,'Hezekiah_0',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,'RJump');
    Goal_Set(1,GOAL_Attack,8,,'IntheSky','IntheSky',,,TRUE,28,,,);
    WaitForGoal(1,GOAL_Attack,);
RJump:
    CheckIfAllMembersDead('DoNothing');
    SetFlags(Skip,TRUE);
    JumpRandom('SOne', 0.18, 'STwo', 0.34, 'COne', 0.56, 'CTwo', 0.78, 'CThree', 1.00); 
DoNothing:
    End();
SOne:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'IntheSkyTwo','IntheSkyTwo',,,TRUE,5,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(1,GOAL_Attack,);
    Jump('RJump');
    End();
STwo:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'IntheSky','IntheSky',,,TRUE,10,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(1,GOAL_Attack,);
    Jump('RJump');
    End();
COne:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'IntheSky','IntheSky',,,TRUE,5,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_Attack,);
    Jump('RJump');
    End();
CTwo:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'IntheSkyTwo','IntheSkyTwo',,,TRUE,10,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_Attack,);
    Jump('RJump');
    End();
CThree:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'IntheSky','IntheSky',,,TRUE,15,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_Attack,);
    Jump('RJump');
    End();
Relay:
    Log("Intercepted Enemy Communication 13_31 -  Incoming Airplanes");
    SendUnrealEvent('RelayVolumes');
    CheckFlags(Incoming,TRUE,'DoNothing');
    SetFlags(Incoming,TRUE);
    Speech(Localize("P_1_3_3OilRig_TopDudes", "Speech_0007L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_31_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
RelayAlert:
    Log("Incoming airplanes cinematic.");
    CheckFlags(Skip,TRUE,'DoNothing');
    SetFlags(Skip,TRUE);
    DisableMessages(TRUE, TRUE);
    SendUnrealEvent('WindStuff');
    SendUnrealEvent('USFightersAExhaust');
    SendUnrealEvent('USFightersBExhaust');
    SendUnrealEvent('USFightersCExhaust');
    SendUnrealEvent('JetCineDisable');
    SendUnrealEvent('USFightersC');
    Sleep(0.169);
    SendUnrealEvent('USFightersB');
    Sleep(0.12);
    SendUnrealEvent('USFightersA');
    CinCamera(0, 'FighterACam', 'FighterAFoc',);
    ShakeCamera(30, 15000, 0);
	SoundActors[0].PlaySound(Sound'Vehicules.Play_BattleJetCutScene', SLOT_SFX);
    Sleep(8);
    ShakeCamera(50, 14000, 1);
    Sleep(0.6);
    CinCamera(1, , ,);
    SendUnrealEvent('WindStuff');
    SendUnrealEvent('USFightersAExhaust');
    SendUnrealEvent('USFightersBExhaust');
    SendUnrealEvent('USFightersCExhaust');
    SendUnrealEvent('JetCineEnable');
    DisableMessages(FALSE, FALSE);
    End();
    Speech(Localize("P_1_3_3OilRig_TopDudes", "Speech_0001L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_37_01', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    Close();
    End();
Nevermind:
    Log("Forget the jets.");
    End();
AttackDeux:
    Log("Intercepted comm 13_53");
    Speech(Localize("P_1_3_3OilRig_TopDudes", "Speech_0002L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_37_02', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    ShakeCamera(700, 20000, 4444);
    SendUnrealEvent('HeavyDamageToSound');
    SendPatternEvent('BoomShakalaAI','Boom');
    Close();
    Sleep(13);
    Speech(Localize("P_1_3_3OilRig_TopDudes", "Speech_0003L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_37_03', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    Close();
    End();
    Log("This is inactive.  Here for semi-historical purpose only.  Look kiddies!!");
    Speech(Localize("P_1_3_3OilRig_TopDudes", "Speech_0005L", "Localization\\P_1_3_3CaspianOilRefinery"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(2.1);
    Close();
    Sleep(5);
    SendPatternEvent('LambertAI','Attack');
    End();
GoodEyeOpen:
    Log("Awakens the TopDude from his witnessing of the chopper explosion.");
    SetFlags(Skip,TRUE);
    Sleep(2.5);
    DisableMessages(FALSE, FALSE);
    Jump('RJump');
    End();
GoodEyeClosed:
    Log("Blinds the TopDude from his witnessing of the chopper explosion.");
    DisableMessages(TRUE, FALSE);
    End();
JerkOff:
    Log("We will systematically remove them like you would any termite or roach.");
    KillNPC(1, FALSE, FALSE);
    End();
EarlyChop:
    Log("TopDude alerted thanks to early chop explosion.");
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,3,,,);
    End();

}

