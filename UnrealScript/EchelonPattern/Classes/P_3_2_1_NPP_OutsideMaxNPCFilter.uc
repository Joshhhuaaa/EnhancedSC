//=============================================================================
// P_3_2_1_NPP_OutsideMaxNPCFilter
//=============================================================================
class P_3_2_1_NPP_OutsideMaxNPCFilter extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Alarm;
var int OneDown;
var int TwoDown;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Alarm');
            break;
        case AI_DEAD:
            EventJump('OneDown');
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
        if(P.name == 'EFalseRussianSoldier4')
            Characters[1] = P.controller;
        if(P.name == 'EFalseRussianSoldier2')
            Characters[2] = P.controller;
        if(P.name == 'EFalseRussianSoldier1')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Alarm=0;
    OneDown=0;
    TwoDown=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
DeathInTheFamily:
    Log("Alarm has been triggered or NPC killed, checking for dead NPCs.");
    CheckFlags(Alarm,FALSE,'Nada');
    CheckFlags(OneDown,FALSE,'Nada');
    Log("Sending call to Reinforce 1");
    SendPatternEvent('Reinforcements1','Send');
    CheckFlags(TwoDown,FALSE,'Nada');
    SendPatternEvent('Reinforcements1','Send');
    End();
Nada:
    Log("Nothingness lasts forever (NPCMaxFilter Null).");
    End();
OneDown:
    Log("One guard is dead.  Flag it so.");
    CheckFlags(OneDown,TRUE,'TwoDown');
    SetFlags(OneDown,TRUE);
    CheckFlags(Alarm,TRUE,'DeathInTheFamily');
    End();
TwoDown:
    Log("Two guards are dead.  Flag it so.");
    SetFlags(TwoDown,TRUE);
    Jump('DeathInTheFamily');
    End();
Alarm:
    Log("Sets the Alarm flag TRUE.");
    SetFlags(Alarm,TRUE);
    Jump('DeathInTheFamily');
    End();

}

defaultproperties
{
}
