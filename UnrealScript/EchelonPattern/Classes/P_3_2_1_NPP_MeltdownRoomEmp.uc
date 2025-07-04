//=============================================================================
// P_3_2_1_NPP_MeltdownRoomEmp
//=============================================================================
class P_3_2_1_NPP_MeltdownRoomEmp extends EPattern;

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
        case AI_GRABBED:
            EventJump('Damage');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Damage');
            break;
        case AI_UNCONSCIOUS:
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
        if(P.name == 'EPowerPlantEmployee4')
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
Broadway:
    Log("Sam is dangerously close to Broadway, release the winged monkeys.");
    Goal_Set(1,GOAL_MoveTo,9,,'FocusHolioooo','FocusHolioooo','Maynard_400',,FALSE,,,,);
    Goal_Set(1,GOAL_Stop,8,,'FocusHolioooo','FocusHolioooo','Maynard_400',,FALSE,120,,,);
    End();
Damage:
    Log("Power plant employee killed or messed with.");
    SendPatternEvent('LambertAI','EmployeeHurt');
    End();

}

defaultproperties
{
}
