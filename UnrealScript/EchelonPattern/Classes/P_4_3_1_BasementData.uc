//=============================================================================
// P_4_3_1_BasementData
//=============================================================================
class P_4_3_1_BasementData extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DestroyedByNPC;
var int InCombat;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('AISeePlayer');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AISeePlayer');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AISeePlayer');
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
        if(P.name == 'EChineseSoldier5')
        {            
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if(P.name == 'EChineseSoldier4')
        {            
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
        if(P.name == 'EChineseSoldier11')
        {            
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bBlockDetection = true;
            EAIController(Characters[3]).bWasFound = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    DestroyedByNPC=0;
    InCombat=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
4320:
    Log("Scripted Event 43_20 Destroying data");
    CheckFlags(InCombat,TRUE,'AlreadyDone');
    Goal_Default(2,GOAL_Guard,9,,'BasementSoldier01',,,,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Attack,9,,,'Computer1Group','BasementDataNode01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_Attack,);
    ChangeState(1,'s_investigate');
    Goal_Default(1,GOAL_Guard,9,,'BasementSoldier02',,,,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Talk(Sound'S4_3_1Voice.Play_43_20_01', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_20_02', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_20_03', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_20_04', 1, , TRUE, 0);
    Close();
    Jump('DestroyingComputers');
    End();
DestroyingComputers:
    Log("DestroyingComputers");
    ResetGroupGoals();
    Goal_Set(1,GOAL_Attack,9,,,'Computer3Group','BasementDataAttackNode03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,8,,'Computer6GroupFocus',,'BasementDataNode03',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,7,,'Computer6GroupFocus',,'Computer6GroupFocus','KbrdStNmBg0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,6,,'Computer6GroupFocus',,'Computer6GroupFocus','KbrdStNmNt0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,5,,'Computer6GroupFocus',,'Computer6GroupFocus','KbrdStNmBg0',FALSE,-1,,,);
    Goal_Set(1,GOAL_MoveTo,4,,,,'BasementDataAttackNode03',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Attack,3,,,'Computer6Group','BasementDataAttackNode03',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,9,,,,'BasementDataNode04',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,8,,'Computer4GroupFocus',,'BasementDataNode04','KbrdStNmEd0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,7,,'Computer4GroupFocus',,'BasementDataNode04','KbrdStNmNt0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,6,,'Computer4GroupFocus',,'BasementDataNode04','KbrdStNmBg0',FALSE,-1,,,);
    Goal_Set(2,GOAL_MoveTo,5,,,,'BasementDataNode04Attack',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,4,,,'Computer4Group','BasementDataNode04Attack',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,3,,'Computer5GroupFocus',,'BasementDataNode04A',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(2,GOAL_MoveTo,);
    WaitForGoal(2,GOAL_MoveTo,);
    WaitForGoal(1,GOAL_Attack,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'BasementDataNode02',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,8,,'Computer2GroupFocus',,'Computer2GroupFocus','KbrdStNmBg0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,7,,'Computer2GroupFocus',,'Computer2GroupFocus','KbrdStNmNt0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,6,,'Computer2GroupFocus',,'Computer2GroupFocus','KbrdStNmEd0',FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,5,,'Computer2GroupFocus',,'BasementDataAttackNode02',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Attack,4,,,'Computer2Group','BasementDataAttackNode02','KbrdStNmEd0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,9,,,,'Computer5GroupFocus','KbrdStNmBg0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,8,,,,'Computer5GroupFocus','KbrdStNmNt0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,7,,,,'Computer5GroupFocus','KbrdStNmBg0',FALSE,-1,,,);
    Goal_Set(2,GOAL_MoveTo,6,,,,'BasementDataNode04Attack',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Attack,5,,,'Computer5Group','BasementDataNode04Attack',,FALSE,,,,);
    Goal_Default(2,GOAL_Guard,4,,'Computer2GroupFocus',,'BasementDataNode04Attack',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_Attack,);
    ChangeGroupState('s_default');
    Jump('FeirongComputer');
    End();
FeirongComputer:
    Log("Destroy Feirong Computer (GAME OVER)");
    ResetGroupGoals();
    Goal_Set(3,GOAL_Attack,9,,,'Computer7Group','BasementDataAttackNode07',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,9,,,,'BasementDataNode08',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'BasementDataNode09',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'FeirongComputer',,'BasementDataNode08',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,8,,'FeirongComputer',,'BasementDataNode09',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(3,GOAL_MoveTo,8,,,,'BasementDataNode10',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(3,GOAL_PlaceWallMine,7,,'WallMineFocus01',,'WallMineNode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(3,GOAL_PlaceWallMine,);
    Goal_Default(3,GOAL_Guard,9,,'FeirongComputer',,'BasementDataNode10',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_3_1Voice.Play_43_20_05', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_20_06', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_20_07', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_20_08', 2, , TRUE, 0);
    Close();
    DisableMessages(FALSE, TRUE);
    Goal_Set(1,GOAL_Attack,9,,'FeirongDataGroup','FeirongDataGroup','BasementDataNode08',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetFlags(DestroyedByNPC,TRUE);
    WaitForGoal(1,GOAL_Attack,);
    SendPatternEvent('LambertComms','BasementDataRetrieveFailed');
    End();
AISeePlayer:
    Log("AISeePlayer");
    SetFlags(InCombat,TRUE);
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Goal_Set(3,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SurprisedByPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    ePawn(Characters[2].Pawn).Bark_Type = BARK_SeePlayer;
    Talk(ePawn(Characters[2].Pawn).Sounds_Barks, 2, 0, false);
    ePawn(Characters[3].Pawn).Bark_Type = BARK_Mystified;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    End();
FeirongComputerDestroyed:
    Log("Check if the computer has been destryed by NPCs or by Sam");
    CheckFlags(DestroyedByNPC,TRUE,'AlreadyDone');
    SendPatternEvent('LambertComms','GenericFail');
AlreadyDone:
    End();
DataRetreived:
    Log("If Sam retrieves the data on the computer");
    Sleep(3);
    // Joshua - After completing objective, reset combat state so we don't hear fight music forever
    ResetGroupGoals();
    ChangeGroupState('s_default');
    Goal_Default(1,GOAL_Guard,9,,'BasementSoldier02',,,,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Guard,9,,'BasementSoldier01',,,,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(3,GOAL_Guard,9,,'FeirongComputer',,'BasementDataNode10',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    // Joshua - End of modify
    DisableMessages(FALSE, TRUE);
    SendPatternEvent('LambertComms','BasementDataRetrieveSuccess');
    End();

}

