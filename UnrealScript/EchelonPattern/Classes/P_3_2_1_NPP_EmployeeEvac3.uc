//=============================================================================
// P_3_2_1_NPP_EmployeeEvac3
//=============================================================================
class P_3_2_1_NPP_EmployeeEvac3 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'EPowerPlantEmployee16')
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
Evacuate:
    Log("Beam out pattern 3.");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Teleport(1, 'TeleOut3');
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
