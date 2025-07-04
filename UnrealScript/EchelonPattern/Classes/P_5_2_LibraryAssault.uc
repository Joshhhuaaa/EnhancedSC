//=============================================================================
// P_5_2_LibraryAssault
//=============================================================================
class P_5_2_LibraryAssault extends EPattern;

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
        if(P.name == 'EEliteForce3')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if(P.name == 'EEliteForce4')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
        if(P.name == 'EEliteForce6')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bBlockDetection = true;
            EAIController(Characters[3]).bWasFound = true;
        }
        if(P.name == 'EEliteForce2')
        {
            Characters[4] = P.controller;
            EAIController(Characters[4]).bAllowKnockout = true;
            EAIController(Characters[4]).bBlockDetection = true;
            EAIController(Characters[4]).bWasFound = true;
        }
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
    Log("Milestone");
    SendUnrealEvent('SaveElev');
    Sleep(0.50);
    DisableMessages(TRUE, FALSE);
    ChangeGroupState('s_alert');
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SendBackup;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Goal_Set(1,GOAL_MoveAndAttack,7,,'PLAYER','PLAYER','BoxCoverLibraryA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,6,,'PLAYER','PLAYER','BoxCoverLibraryA',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,5,,'PLAYER','PLAYER','BoxCoverLibraryB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,4,,'PLAYER','PLAYER','BoxCoverLibraryB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','OutLesftSideBasA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,8,,'PLAYER','PLAYER','UpLibraryBalA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,7,,'PLAYER','PLAYER','UpLibraryBalA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveAndAttack,7,,'PLAYER','PLAYER','BookCoverAA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,6,,'PLAYER','PLAYER','BookCoverAA',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(22);
    DisableMessages(FALSE, FALSE);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','ElevBlockCoverB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'PLAYER','PLAYER','ElevBlockCoverB',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','ElevBlockCoverA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'PLAYER','PLAYER','ElevBlockCoverA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,'PLAYER','PLAYER','LibraryMassacreStart3',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'PLAYER','PLAYER','LibraryMassacreStart3',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    End();
SimpleJumpReset:
    Log("SimpleJumpReset");
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ResetGoals(4);
    ChangeGroupState('s_default');
    Goal_Default(1,GOAL_Search,9,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Search,9,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(3,GOAL_Search,9,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(4,GOAL_Search,9,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    SetExclusivity(FALSE);
    End();
FakeEliteCrisAttack:
    Log("FakeEliteCrisAttack");
    KillNPC(1, FALSE, FALSE);
    KillNPC(2, FALSE, FALSE);
    KillNPC(3, FALSE, FALSE);
    KillNPC(4, FALSE, FALSE);
    DisableMessages(TRUE, TRUE);
End:
    End();

}

