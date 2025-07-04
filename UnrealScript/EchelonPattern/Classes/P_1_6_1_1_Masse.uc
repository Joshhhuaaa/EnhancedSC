//=============================================================================
// P_1_6_1_1_Masse
//=============================================================================
class P_1_6_1_1_Masse extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Electronic.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CSplayed;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Death');
            break;
        case AI_UNCONSCIOUS:
        // Joshua - The player must kill Masse to complete the mission, a knockout will no longer complete the objective
            EventJump('UnconsciousMasse');
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
        if(P.name == 'EMasse0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKill = true;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if(P.name == 'spetsnaz13')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'ECompSonyClv2')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    CSplayed=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneMasse:
    Log("MilestoneMasse");
    Sleep(7);
    Goal_Set(1,GOAL_Action,9,,'Nikolai',,,'TalkStNmAA0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,8,,'Nikolai',,,'LstnStNmCC0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,7,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_46_01', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_46_02', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'Nikolai',,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_46_03', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_46_04', 2, , TRUE, 0);
    Goal_Set(2,GOAL_MoveTo,9,,,,'BaffoonG',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'BaffoonG',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
MasseCS:
    Log("MasseCS");
    ToggleGroupAI(TRUE, 'MasseGroup', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    CheckFlags(CSplayed,TRUE,'End');
    SetFlags(CSplayed,TRUE);
    Sleep(0.50);
    CinCamera(0, 'MasseCinTestA', 'MasseCinTestB',);
	SoundActors[0].PlaySound(Sound'Electronic.Play_Sq_ComputerKeyBoard', SLOT_SFX);
    Sleep(3.50);
	SoundActors[0].PlaySound(Sound'Electronic.Stop_Sq_ComputerKeyBoard', SLOT_SFX);
    CinCamera(1, , ,);
    ResetGoals(1);
    Goal_Default(1,GOAL_Patrol,9,,,,'MasseA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Jump('MilestoneMasse');
    End();
Bark:
    Log("Bark");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_BegForLife;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();
Death:
    Log("Death");
    CheckIfIsDead(1,'MasseDeath');
    // Joshua - We don't want to go to MasseDeath for unconscious state anymore
    End();
MasseDeath:
    Log("MasseDeath");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).PCObj,FALSE,'TooSoon');
    CheckIfIsDead(1,'KillIsDone');
    // Joshua - Only completing the objective if Masse is actually dead, not just unconscious
    End();
KillIsDone:
    Log("KillIsDone");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).KillObj,TRUE,'End');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).KillObj,TRUE);
    GoalCompleted('Kill');
    SendPatternEvent('GroupIntroCall','ExtractionGoal');
    End();
TooSoon:
    Log("TooSoon");
    SetProfileDeletion();
    GameOver(false, 6);
    End();
UnconsciousMasse:
    Log("UnconsciousMasse");
    CheckIfIsUnconscious(1,'MasseDeath');
    End();
NikolaiAttack:
    Log("NikolaiAttack");
    ResetGoals(2);
    ChangeState(2,'s_alert');
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'NikolaiSpotA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'MrMasse',,'NikolaiSpotA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
NikolaiSearch:
    Log("NikolaiSearch");
    ResetGoals(2);
    ChangeState(2,'s_default');
    ChangeState(2,'s_investigate');
    Goal_Set(2,GOAL_MoveTo,9,,,,'RushOneBall',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Search,8,,,,'RushOneBall',,FALSE,,MOVE_Search,,MOVE_Search);
End:
    End();

}

defaultproperties
{
}
