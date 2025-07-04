//=============================================================================
// P_4_2_1_Abt_MineGuard
//=============================================================================
class P_4_2_1_Abt_MineGuard extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;
var int pass2;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('JumpFin');
            break;
        case AI_DEAD:
            EventJump('JumpFin');
            break;
        case AI_GRABBED:
            EventJump('JumpFin');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('JumpFin');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('JumpFin');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('JumpFin');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('JumpFin');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('JumpFin');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('JumpFin');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('JumpFin');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('JumpFin');
            break;
        case AI_UNCONSCIOUS:
            EventJump('JumpFin');
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
        if(P.name == 'spetsnaz14')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    pass1=0;
    pass2=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    CheckIfIsDead(1,'JumpFin');
    CheckIfIsUnconscious(1,'JumpFin');
    CheckFlags(pass1,TRUE,'JumpFin');
    DisableMessages(FALSE, TRUE);
    AddNote("", "P_4_2_1_Abt_MineGuard", "Note_0005L", "Localization\\P_4_2_1_Abattoir");
    SetFlags(pass1,TRUE);
    Goal_Set(1,GOAL_Wait,9,,,,,'RdioStNmNt0',FALSE,,,,);
    Goal_Default(1,GOAL_Guard,1,,'BariBaril','BariBaril','badriGa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Speech(Localize("P_4_2_1_Abt_MineGuard", "Speech_0001L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_06_01', 1, 1, TR_NPCS, 0, false);
    Close();
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,'ELaptop0',,'PathNode26',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Action,7,,'ELaptop0',,,'KbrdStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Wait,6,,'ELaptop0',,,'KbrdStNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
JumpFin:
    Log("");
    Close();
    SetExclusivity(FALSE);
    End();

}

