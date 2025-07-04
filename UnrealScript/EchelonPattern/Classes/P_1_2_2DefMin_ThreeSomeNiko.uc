//=============================================================================
// P_1_2_2DefMin_ThreeSomeNiko
//=============================================================================
class P_1_2_2DefMin_ThreeSomeNiko extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('PlayerSeen');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('PlayerSeen');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('PlayerSeen');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('PlayerSeen');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('PlayerSeen');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('PlayerSeen');
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
        if(P.name == 'EGeorgianSoldier3')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianSoldier4')
            Characters[2] = P.controller;
        if(P.name == 'EGeorgianSoldier5')
            Characters[3] = P.controller;
        if(P.name == 'EGrinko0')
            Characters[4] = P.controller;
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
    Log("MilestoneThreeSomeNiko");
    DisableMessages(TRUE, FALSE);
    Sleep(2);
    Teleport(1, 'ThirdAlarmPointBB');
    Teleport(2, 'SpawnSecondRushTreesome');
    Teleport(3, 'SpawnThirdRushTreesome');
    Goal_Set(1,GOAL_MoveTo,9,,,,'PatrolNearNikoOff_100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'NikoDoor','NikoDoor','PatrolNearNikoOff_100',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(1);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RushToNikoOffTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,'NikoDoor','NikoDoor','RushToNikoOffTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1);
    Goal_Set(3,GOAL_MoveTo,9,,,,'InPositionA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,'NikoDoor','NikoDoor','InPositionA',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    End();
AfterCPUFiles:
    Log("AfterCPUFiles");
    Sleep(1);
    Speech(Localize("P_1_2_2DefMin_ThreeSomeNiko", "Speech_0006L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_56_01', 4, 0, TR_NPCS, 0, false);
    Sleep(0.50);
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,'NikoDoor','NikoDoor',,'RdioStNmNt0',FALSE,,,,);
    Speech(Localize("P_1_2_2DefMin_ThreeSomeNiko", "Speech_0001L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_57_01', 1, 0, TR_NPCS, 0, false);
    Close();
    LockDoor('NikoDoor', FALSE, TRUE);
    DisableMessages(FALSE, FALSE);
    ResetGoals(1);
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'RushInNikoOffOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'Bleee',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_MoveAndAttack,7,,,,'Bleiieiei',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_MoveAndAttack,6,,,,'NearWindowTwo',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Attack,5,,'SamSearchWinPanA','SamSearchWinPanA','NearWindowTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'OptMovementttHa',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,8,,,,'RushInNikoOffTwo',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveAndAttack,7,,,,'CombatNodeForRandomNikA',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Default(2,GOAL_Attack,6,,'WindowPanicA','WindowPanicA','CombatNodeForRandomNikA',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).NikoLight,TRUE,'SkipLightInteract');
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'RushInNikoOffThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_InteractWith,8,,,,'ELightSwitchNiko',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,7,,'BigChairS','BigChairS','Lightswichnnik',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_CombArea;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();
SkipLightInteract:
    Log("SkipLightInteract");
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'RushInNikoOffThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'BigChairS','BigChairS','RushInNikoOffThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
TriggerForInside:
    Log("TriggerForInside");
    Sleep(7);
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_default');
    Goal_Set(1,GOAL_MoveTo,9,,,,'CheckPowerBoxOptA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'StairwayToHeavenA','StairwayToHeavenA','CheckPowerBoxOptA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RoofCheckPowerF',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'RoofCheckPowerF',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'RoofCheckPowerC',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Patrol,8,,,,'RoofCheckPowerC',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
PlayerSeen:
    Log("PlayerSeen");
    SetExclusivity(FALSE);
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).ThreesomeAlerted,TRUE);
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).NikoLight,TRUE,'End');
    CheckIfIsDead(3,'FindSomeOneElseForLight');
    End();
FindSomeOneElseForLight:
    Log("FindSomeone else to flick the switch because member 3 is dead");
    CheckIfIsDead(1,'Memb1Dead');
    Goal_Set(1,GOAL_InteractWith,9,,,,'ELightSwitchNiko',,FALSE,1.0,MOVE_JogAlert,,MOVE_JogAlert);
Memb1Dead:
    Log("Member one is dead, try with member 2");
    CheckIfIsDead(2,'End');
    Goal_Set(2,GOAL_InteractWith,9,,,,'ELightSwitchNiko',,FALSE,1.0,MOVE_CrouchJog,,MOVE_CrouchJog);
End:
    End();

}

