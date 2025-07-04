//=============================================================================
// P_1_1_1_Tbilisi_Firemen
//=============================================================================
class P_1_1_1_Tbilisi_Firemen extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Vehicules.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FadeiDone;
var int FedotDone;
var int FinogenDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('TakingFire');
            break;
        case AI_UNCONSCIOUS:
            EventJump('TakingFire');
            break;
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
        if(P.name == 'EMafiaMuscle1')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle2')
            Characters[2] = P.controller;
        if(P.name == 'EMafiaMuscle3')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    FadeiDone=0;
    FedotDone=0;
    FinogenDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Firehehehe:
    Log("This is the pattern for the mafiosos fleeing the fire.");
    Goal_Default(1,GOAL_MoveTo,0,,'Mafioso1TeleportExit',,'Mafioso1TeleportExit',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(0.25);
    Goal_Default(2,GOAL_MoveTo,0,,'Mafioso2TeleportExit',,'Mafioso2TeleportExit',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(0.25);
    Goal_Default(3,GOAL_MoveTo,0,,'Mafioso3TeleportExit',,'Mafioso3TeleportExit',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SendPatternEvent('LambertAI','ItsOnFire');
    End();
FinogenAtVan:
    Log("Finogen has reached his point");
    Teleport(1, 'FinogenOut');
    SetFlags(FinogenDone,TRUE);
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,0,,,,'FinogenOut',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Jump('AllAboard');
    End();
FedotAtVan:
    Log("Fedot has reached his point");
    Teleport(2, 'FadeiOut');
    SetFlags(FedotDone,TRUE);
    ResetGoals(2);
    Goal_Default(2,GOAL_Guard,0,,,,'FedotOut',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Jump('AllAboard');
    End();
FadeiAtVan:
    Log("Fadei has reached his point");
    Teleport(3, 'FedotOut');
    SetFlags(FadeiDone,TRUE);
    ResetGoals(3);
    Goal_Default(3,GOAL_Guard,0,,,,'FadeiOut',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Jump('AllAboard');
    End();
TakingFire:
    Log("This is the jump label if they are attacked");
    CheckIfIsDead(1,'FinogenEnd');
    CheckIfIsUnconscious(1,'FinogenEnd');
    CheckIfIsDead(2,'FedotEnd');
    CheckIfIsUnconscious(2,'FedotEnd');
    CheckIfIsDead(3,'FadeiEnd');
    CheckIfIsUnconscious(3,'FadeiEnd');
    End();
FinogenEnd:
    Log("Finogen is either in the van, dead or unconcious.");
    SetFlags(FinogenDone,TRUE);
    Jump('AllAboard');
    End();
FedotEnd:
    Log("Fedot is either in the van, dead or unconcious.");
    SetFlags(FedotDone,TRUE);
    Jump('AllAboard');
    End();
FadeiEnd:
    Log("Fadei is either in the van, dead or unconcious.");
    SetFlags(FadeiDone,TRUE);
    Jump('AllAboard');
    End();
AllAboard:
    Log("Checking to see if all members are dead or in the van so it can leave.");
    CheckFlags(FinogenDone,TRUE,'FedotCheck');
    End();
FedotCheck:
    Log("Finogen is done, checking Fedot.");
    CheckFlags(FedotDone,TRUE,'FadeiCheck');
    End();
FadeiCheck:
    Log("Fedot is done, checking Fadei.");
    CheckFlags(FadeiDone,TRUE,'ReadyToRoll');
    End();
ReadyToRoll:
    Log("All three flags are set, sending Unreal Event now.");
    SendUnrealEvent('Getaway');
	PlaySound(Sound'Vehicules.Play_EchelonVanStart', SLOT_Ambient);
    Sleep(0.5);
    SendUnrealEvent('VanBlocker');
    End();

}

