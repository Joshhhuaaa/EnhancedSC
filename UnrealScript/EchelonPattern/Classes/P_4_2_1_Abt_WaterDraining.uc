//=============================================================================
// P_4_2_1_Abt_WaterDraining
//=============================================================================
class P_4_2_1_Abt_WaterDraining extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('ResteCam');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('ResteCam');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('ResteCam');
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
        if(P.name == 'EGeorgianSoldier6')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianSoldier5')
            Characters[2] = P.controller;
        if(P.name == 'EGeorgianSoldier7')
            Characters[3] = P.controller;
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
WaterDrain:
    Log("npc invertigate the court1 water draining");
ChekTwoDead:
    Log("chek if there is still at least two guards");
    SendPatternEvent('EGroupAI30','Start');
    End();
Speach:
    Log("");
    SendUnrealEvent('MoverWater');
    CinCamera(0, 'EFocusPoint10', 'EFocusPoint3',);
    Sleep(1.5);
    Talk(None, 1, , TRUE, 0);
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint1',,'PathNode243',,FALSE,,MOVE_WalkNormal,,);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint1',,'PathNode243',,FALSE,,MOVE_WalkNormal,,);
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint5',,'PathNode244',,FALSE,,MOVE_WalkNormal,,);
    Goal_Default(2,GOAL_Guard,8,,'EFocusPoint5',,'PathNode244',,FALSE,,MOVE_WalkNormal,,);
    Goal_Set(3,GOAL_MoveTo,9,,'EFocusPoint0',,'PathNode29',,FALSE,,MOVE_WalkAlert,,);
    Goal_Default(3,GOAL_Guard,8,,'EFocusPoint0',,'PathNode29',,FALSE,,MOVE_WalkAlert,,);
    Sleep(2);
    Close();
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint6',,'PathNode27',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint25',,'PathNode27',,FALSE,,MOVE_WalkNormal,,MOVE_CrouchWalk);
    Sleep(2);
    Talk(Sound'S4_2_1Voice.Play_42_04_01', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint25',,'EGeorgianSoldier7_150',,FALSE,,MOVE_WalkNormal,,);
    Goal_Default(2,GOAL_Guard,8,,'EFocusPoint25',,'EGeorgianSoldier7_150',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
    Talk(Sound'S4_2_1Voice.Play_42_04_02', 2, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_04_03', 1, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint0',,'PathNode243',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint0',,'PathNode243',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
    Close();
    CinCamera(1, , ,);
BacktoGuard:
    Log("Guard get back to guards and patrol");
    ResetGoals(3);
    Goal_Default(3,GOAL_Patrol,9,,,,'EGeorgianSoldier7_0',,FALSE,,MOVE_WalkNormal,,);
    Sleep(1);
    ResetGoals(1);
    Goal_Default(1,GOAL_Patrol,9,,,,'EGeorgianSoldier6_100',,FALSE,,MOVE_WalkNormal,,);
    ResetGoals(2);
    Goal_Default(2,GOAL_Patrol,9,,,,'EGeorgianSoldier5_0',,FALSE,,MOVE_WalkNormal,,);
    End();
Jumpfin:
    Log("");
    End();
ResteCam:
    Log("");
    CinCamera(1, , ,);
    End();
JustCine:
    Log("");
    SendUnrealEvent('MoverWater');
    CinCamera(0, 'EFocusPoint10', 'EFocusPoint3',);
    Sleep(3);
    CinCamera(1, , ,);
    End();

}

