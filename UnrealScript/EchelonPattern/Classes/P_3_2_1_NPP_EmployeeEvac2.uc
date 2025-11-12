//=============================================================================
// P_3_2_1_NPP_EmployeeEvac2
//=============================================================================
class P_3_2_1_NPP_EmployeeEvac2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Damage');
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
        if (P.name == 'EPowerPlantEmployee15')
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
Evacuate:
    Log("Beam out pattern 2.");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Teleport(1, 'TeleOut2');
    Goal_Set(1,GOAL_Wait,9,,,,,,FALSE,,,,);
    End();
Damage:
    Log("Power plant employee killed or messed with.");
    SendPatternEvent('LambertAI','EmployeeHurt');
    End();

}

defaultproperties
{
}
