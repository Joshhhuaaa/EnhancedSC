//=============================================================================
// P_4_2_2_Abt_BasePatrolC
//=============================================================================
class P_4_2_2_Abt_BasePatrolC extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_SOMETHING:
            EventJump('BasePatrolC');
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
        if (P.name == 'EGeorgianSoldier26')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier27')
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
BasePatrolC:
    Log("Starting patrol behaviour");
    Goal_Default(1,GOAL_Patrol,9,,,,'EGeorgianSoldier26_100',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,9,,,,'EGeorgianSoldier27_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
NikOut:
    Log("Start talking");
    CheckIfIsDead(1,'GetToDefaut');
    CheckIfIsUnconscious(1,'GetToDefaut');
    CheckIfIsDead(2,'GetToDefaut');
    CheckIfIsUnconscious(2,'GetToDefaut');
    Talk(Sound'S4_2_2Voice.Play_42_11_01', 1, , TRUE, 0);
    Log("passed first line");
    Talk(Sound'S4_2_2Voice.Play_42_11_02', 2, , TRUE, 0);
    Log("passed second line");
    Talk(Sound'S4_2_2Voice.Play_42_11_03', 1, , TRUE, 0);
    Log("passed third line");
    Talk(Sound'S4_2_2Voice.Play_42_11_04', 2, , TRUE, 0);
    Log("passed last line, ending conversation");
    End();
GetToDefaut:
    Log("Going to default beahviour");
    SetExclusivity(FALSE);
    End();

}

