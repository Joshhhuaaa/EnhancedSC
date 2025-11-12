//=============================================================================
// P_4_1_2_CEmb_FrancesCasualty
//=============================================================================
class P_4_1_2_CEmb_FrancesCasualty extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_TAKE_DAMAGE:
            EventJump('DeadRinger');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadRinger');
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
        if (P.name == 'EFrances0')
            Characters[1] = P.controller;
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
DeadRinger:
    Log("DeadRinger");
    SendPatternEvent('LambertBogus','ImportantMemberDied');
    End();
FrancesSpawn:
    Log("Makes Frances Spawn after the objective is completed");
    Teleport(1, 'Frances');
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,9,,'FrancesFocus',,'FrancesSpawn',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

