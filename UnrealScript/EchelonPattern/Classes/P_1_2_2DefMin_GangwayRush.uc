//=============================================================================
// P_1_2_2DefMin_GangwayRush
//=============================================================================
class P_1_2_2DefMin_GangwayRush extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('PlayerSeen');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('PlayerSeen');
            break;
        case AI_SEE_INTERROGATION:
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
        if (P.name == 'EGeorgianSoldier6')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier7')
            Characters[2] = P.controller;
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
    Log("MilestoneGangwayRush");
    Teleport(1, 'GangwayRushSpawnOne');
    Teleport(2, 'PostpatrolNikoOne');
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'DownShaft',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'DownShaft',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'GWayA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'GWayB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Guard,7,,'EFocusPointRoofA','EFocusPointRoofA','GWayA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Guard,7,,'EFocusPointRoofA',,'GWayB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Speech(Localize("P_1_2_2DefMin_GangwayRush", "Speech_0003L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_58_01', 1, 0, TR_NPCS, 0, false);
    Close();
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Sleep(16);
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).ThreesomeAlerted,FALSE,'Stealth');
    Goal_Set(1,GOAL_MoveTo,9,,,,'UnStealthGangWayPatrolA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Patrol,8,,,,'UnStealthGangWayPatrolA',,FALSE,,MOVE_Search,,MOVE_Search);
    Jump('SecondGuy');
Stealth:
    Goal_Set(1,GOAL_MoveTo,9,,,,'RushInNikoOffOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'EmergencyStaitFaaa','EmergencyStaitFaaa','RushInNikoOffOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
SecondGuy:
    Goal_Set(2,GOAL_MoveTo,9,,,,'CombatNodeForRandomNikA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,'EmergencyStaitFaaa','EmergencyStaitFaaa','CombatNodeForRandomNikA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
PlayerSeen:
    Log("PlayerSeen");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).GangWayAlerted,TRUE);
    SetExclusivity(FALSE);
End:
    End();

}

