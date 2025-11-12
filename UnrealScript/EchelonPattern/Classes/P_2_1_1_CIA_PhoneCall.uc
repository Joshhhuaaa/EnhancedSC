//=============================================================================
// P_2_1_1_CIA_PhoneCall
//=============================================================================
class P_2_1_1_CIA_PhoneCall extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Over;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_GRABBED:
            EventJump('Hello');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Hello');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Hello');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('Hello');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('Hello');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Hello');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Hello');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Hello');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Hello');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Hello');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ECIAAgent1')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'StaticMeshActor1762')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Over=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("PhStart");
    Goal_Set(1,GOAL_Wait,9,,,,,'CellStNmAA0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,1,,'elecmachinA','elecmachinA','MachinaL',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S2_1_1Voice.Play_21_15_01', 1, , TRUE, 0);
    Close();
    ResetGoals(1);
    SetFlags(Over,TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'CCwait',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'chicolA','chicolA','CCwait',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(13);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'MachinaL',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'elecmachinA','elecmachinA','MachinaL',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
Hello:
    Log("Hello");
    CheckFlags(Over,TRUE,'End');
    Close();
    DisableMessages(TRUE, TRUE);
playit:
    AddOneVoice();
	SoundActors[0].PlaySound(Sound'S2_1_1Voice.Play_21_16_01', SLOT_Voice);
End:
    End();

}

