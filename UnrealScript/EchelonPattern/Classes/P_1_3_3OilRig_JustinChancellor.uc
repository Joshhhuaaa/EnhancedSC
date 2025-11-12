//=============================================================================
// P_1_3_3OilRig_JustinChancellor
//=============================================================================
class P_1_3_3OilRig_JustinChancellor extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bEscortStarted;
var int bSearchStarted;
var int EscortClear;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Nooge');
            break;
        case AI_GRABBED:
            EventJump('Nooge');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Nooge');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Heard');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Nooge');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Nooge');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Nooge');
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
        if (P.name == 'EGeorgianSoldier3')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger28')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    bEscortStarted=0;
    bSearchStarted=0;
    EscortClear=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FortySixnTwo:
    Log("Step into the shadow.. coming out the other side.");
    Goal_Set(1,GOAL_MoveTo,8,,,,'NoneShallPass',,FALSE,,,,);
    Goal_Set(1,GOAL_Wait,7,,'Piotr','Piotr',,,FALSE,,,,);
    Goal_Default(1,GOAL_Guard,1,,'Check2FocusAdam',,'Kyuss',,FALSE,,,,);
    End();
StinkFist:
    Log("Elbow deep within the borderline, this may hurt a little..");
    SetFlags(bEscortStarted,TRUE);
    ResetGoals(1);
    ChangeState(1,'s_investigate');
    SetExclusivity(TRUE);
    Goal_Set(1,GOAL_MoveTo,8,,'OutThereFocus','OutThereFocus','PreKyuss',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,'Kyuss');
Kyuss:
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,7,,'Check2FocusAdam','Check2FocusAdam','Kyuss',,FALSE,,,,);
    Goal_Default(1,GOAL_Wait,4,,'Check2FocusAdam',,'Kyuss',,FALSE,,,,);
    End();
Jets:
    Log("Danny-  What we need is jets.  We can't hope to take down a monkey without jets.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,7.5,,,);
    End();
SwampSong:
    Log("Wander in and wandering, noone even invited you in.  But still you stumble in stumbling, so suffocate, or get out while you can. ");
    SetFlags(EscortClear,TRUE);
    ResetGoals(1);
    Goal_Default(1,GOAL_Patrol,5,,,,'Justin_0',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    End();
JerkOff:
    Log("I should play god and just.. shoot you myself!!");
    SetFlags(EscortClear,TRUE);
    KillNPC(1, FALSE, FALSE);
    End();
Explosion:
    Log("BOOM SYAH");
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'ReacStAlFd0',FALSE,,,,);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_Wait,5,,'Check2FocusAdam','Check2FocusAdam',,,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(0.69);
	SoundActors[0].    PlaySound(Sound'S1_3_3Voice.VolIn_BattleAmbiance', SLOT_Ambient);
    End();
Nooge:
    Log("Somebody's messing with Justin, is the group clear?");
    CheckFlags(EscortClear,TRUE,'Null');
    SetExclusivity(FALSE);
    SendPatternEvent('JedediahAI','GameOverMan');
Null:
    End();
Heard:
    Log("Justin heard something. If his escort isn't started, make sure we doesn't break the escort order by going to search downstairs. Make him search upstairs.");
    CheckFlags(bEscortStarted,TRUE,'Null');
    CheckFlags(bSearchStarted,TRUE,'Null');
    SetFlags(bSearchStarted,TRUE);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_HeardFoot;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Jump('StinkFist');
    End();

}

