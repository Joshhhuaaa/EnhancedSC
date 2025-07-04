//=============================================================================
// P_2_1_1_CIA_CpuRoomBackup
//=============================================================================
class P_2_1_1_CIA_CpuRoomBackup extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Start');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('DropIt');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('DropIt');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('DropIt');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('DropIt');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('DropIt');
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
        if(P.name == 'ECIASecurity14')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if(P.name == 'ECIASecurity15')
            Characters[2] = P.controller;
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
Start:
    Log("");
    Teleport(1, 'Ico_800');
    Teleport(2, 'PathNode171');
    Sleep(0.50);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'LookServerCC',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'ChairServerA','PLAYER','LookServerCC',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'Rodney_400',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'elecUnitOnea','PLAYER','Rodney_400',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_CombArea;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();
DropIt:
    Log("DropIt");
    DisableMessages(TRUE, TRUE);
    Sleep(3);
    SetExclusivity(FALSE);
    End();

}

