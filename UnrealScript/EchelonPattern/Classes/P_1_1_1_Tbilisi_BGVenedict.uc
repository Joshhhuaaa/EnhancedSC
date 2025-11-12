//=============================================================================
// P_1_1_1_Tbilisi_BGVenedict
//=============================================================================
class P_1_1_1_Tbilisi_BGVenedict extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
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
        if (P.name == 'ERussianCivilian3')
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
    Log("This is the pattern for Background NPC Venedict");
VenedictPat:
    Log("FIFTH AREA");
    CheckIfIsDead(1,'DoNothing');
    ResetGroupGoals();
    ChangeGroupState('s_default');
    Teleport(1, 'Area2ioA');
    Goal_Default(1,GOAL_Patrol,0,,,,'Venedict_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
ManDown:
    Log("Venedict has been killed");
    CheckIfIsDead(1,'DeadVenedict');
    End();
DeadVenedict:
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

