//=============================================================================
// P_4_3_2_ThermalKeypadB
//=============================================================================
class P_4_3_2_ThermalKeypadB extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('KeypadBKillNPC');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KeypadBKillNPC');
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
        if(P.name == 'EAzeriColonel1')
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
ThermalKeypadB:
    Log("ThermalKeypadB");
    Goal_Default(1,GOAL_Guard,9,,'Warehousepatrolfocus01',,'ThermalKeypadBNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
KeypadBKillNPC:
    Log("Check If Sam has killed the NPC AFTER the keypad");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).CanKillKeypadB,TRUE,'KillOK');
    SendPatternEvent('LambertComms','KeypadFailedA');
KillOK:
    End();

}

