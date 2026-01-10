//=============================================================================
// P_1_2_2DefMin_ElevPattern
//=============================================================================
class P_1_2_2DefMin_ElevPattern extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
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
        if (P.name == 'EGeorgianSoldier0')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier8')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
        // Joshua - Replace NPC skins for variety
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EGeorgianSoldier8' || P.name == 'EGeorgianSoldier13' || P.name == 'EGeorgianSoldier9' ||
                P.name == 'EGeorgianSoldier3' || P.name == 'EGeorgianSoldier5')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.GESoldier.GESoldierA", class'Texture'));
            }
        }

        // Joshua - Defense Ministry requires 1 bullet to shoot a unavoidable camera for Elite mode
        if (EchelonGameInfo(Level.Game).bEliteMode && EPlayerController(Characters[0]) != None && EPlayerController(Characters[0]).HandGun != None)
        {
            if (EPlayerController(Characters[0]).HandGun.Ammo == 0 && EPlayerController(Characters[0]).HandGun.ClipAmmo == 0 && EPlayerController(Characters[0]).playerStats.BulletFired == 0)
            {
                EPlayerController(Characters[0]).HandGun.Ammo = 1;
                EPlayerController(Characters[0]).HandGun.ClipAmmo = 1;
            }
        }
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
    Log("MilestoneElevPattern");
    Sleep(1);
    Goal_Set(2,GOAL_MoveTo,9,,,,'InfElevWaitAnode',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'DoorForInfWaitElevF','DoorForInfWaitElevF','InfElevWaitAnode',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,9,,,,'QuickGlanceNoHideA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'InfElevWaitBnode',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,7,,'DoorForInfWaitElevF','DoorForInfWaitElevF','InfElevWaitBnode',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(35);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNodeBegin',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'ALockedDoor','ALockedDoor','PathNodeBegin',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'StratFirstAAA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'StratFirstAAA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).ElevatorAlerted,TRUE);
    End();
WarnCin:
    Log("WarnCin");
    SendUnrealEvent('ButtonFakesInteract');
    Sleep(0.50);
    CinCamera(0, 'ElevComingCinP', 'ElevComingCinF',);
    Sleep(5);
    CinCamera(1, , ,);
    GoalCompleted('North');
    SetExclusivity(FALSE);
End:
    End();

}

