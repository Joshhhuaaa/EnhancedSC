//=============================================================================
// P_4_3_0_RestaurantCook
//=============================================================================
class P_4_3_0_RestaurantCook extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_0Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int bDisturbed;
var int CookAlreadyPatrolling;
var int PatternAlreadyStarted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Disturbed');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Disturbed');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('Disturbed');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Disturbed');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Disturbed');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Disturbed');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Disturbed');
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
        if (P.name == 'ECook0')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier12')
            Characters[2] = P.controller;
        if (P.name == 'EChineseSoldier9')
            Characters[3] = P.controller;
        if (P.name == 'EChineseSoldier0')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    bDisturbed=0;
    CookAlreadyPatrolling=0;
    PatternAlreadyStarted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ComingFromFrontDoor:
    Log("ComingFromFrontDoor");
    SendUnrealEvent('BackDoorVolume');
    Jump('CookAndSoldiers');
ComingFromBackDoor:
    Log("ComingFromBackDoor");
    SendUnrealEvent('FrontDoorVolume');
    Jump('CookAndSoldiers');
CookAndSoldiers:
    Log("CookAndSoldiers");
    CheckIfIsDead(2,'AlreadyStarted');
    CheckIfIsDead(3,'AlreadyStarted');
    CheckFlags(PatternAlreadyStarted,TRUE,'AlreadyStarted');
    CheckFlags(bDisturbed,TRUE,'AlreadyStarted');
    Talk(Sound'S4_3_0Voice.Play_43_06_01', 2, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_06_02', 3, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_06_03', 2, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_06_04', 3, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_06_05', 2, , TRUE, 0);
    Talk(Sound'S4_3_0Voice.Play_43_06_06', 3, , TRUE, 0);
    Close();
AlreadyStarted:
    End();
CookPatrol:
    Log("CookPatrol");
    CheckFlags(CookAlreadyPatrolling,TRUE,'AlreadyStarted');
    SetFlags(CookAlreadyPatrolling,TRUE);
    Goal_Default(1,GOAL_Patrol,9,,,,'Cook_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
AppartmentSoldierPatrol:
    Log("AppartmentSoldierPatrol");
    Goal_Default(4,GOAL_Patrol,9,,,,'AppartmentPatrol_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Disturbed:
    Log("Guards were disturbed.");
    SetFlags(bDisturbed,TRUE);
    End();
ReachedRooftop:
    SetFlags(V4_3_0ChineseEmbassy(Level.VarObject).LambertKeypadReady,TRUE); // Joshua - Notify LambertComms that the keypad is ready for dialogue
    End();

}

