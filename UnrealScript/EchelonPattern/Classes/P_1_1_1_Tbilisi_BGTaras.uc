//=============================================================================
// P_1_1_1_Tbilisi_BGTaras
//=============================================================================
class P_1_1_1_Tbilisi_BGTaras extends EPattern;

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
        if (P.name == 'ERussianCivilian5')
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
    Log("This is the pattern for Background NPC Taras..");
    Log("no first area pattern for Taras");
BTaras:
    Log("SECOND AREA");
    CheckIfIsDead(1,'DoNothing');
    ResetGroupGoals();
    ChangeGroupState('s_default');
    Teleport(1, 'Taras_0');
TarasBloop:
    Goal_Default(1,GOAL_Patrol,0,,,,'Taras_100',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
CTaras:
    Log("THIRD AREA");
    CheckIfIsDead(1,'DoNothing');
    Log("Removing Taras from the Civilian group");
    Teleport(1, 'BGTarasKey');
    ResetNPC(1,FALSE);
    ChangeGroupState('s_default');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,0,,,,'BGTarasKey',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
    Log("FOURTH AREA no fourth area for Taras");
    End();
    Log("FIFTH AREA");
    End();
ManDown:
    Log("Checking if Taras is dead");
    CheckIfIsDead(1,'DeadTaras');
    End();
DeadTaras:
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

