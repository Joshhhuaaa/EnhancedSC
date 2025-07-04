//=============================================================================
// P_1_1_2_Tbilisi_BasementGuard
//=============================================================================
class P_1_1_2_Tbilisi_BasementGuard extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Alarum');
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
        if(P.name == 'EGeorgianCop8')
            Characters[1] = P.controller;
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
AlexGo:
    Log("This pattern simply switches the default goal of the guard in the basement.");
    Goal_Default(1,GOAL_Patrol,0,,,,'Alexei_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    SendPatternEvent('LambertAI','OpenDoor');
    End();
Alarum:
    Log("this is Alexeis alarm response");
    SetExclusivity(TRUE);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','AlexeiDefensePoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','AlexeiDefensePoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
FreeAlex:
    Log("Alex is freed from his alarm pattern");
    ResetGroupGoals();
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_Search,9,,,,'CoronerHide',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'Alexei_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,0,,,,'Alexei_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

