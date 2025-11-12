//=============================================================================
// P_4_3_1_GuardSleeping
//=============================================================================
class P_4_3_1_GuardSleeping extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\SoundEvent.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyHeard;
var int SamCheckFlagA;
var int SamCheckFlagB;
var int SamCheckFlagC;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('GuardWakeUp');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('GuardWakeUp');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GuardWakeUp');
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
        if (P.name == 'EChineseSoldier6')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier18')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'EChineseSoldier6')
            SoundActors[0] = A;
        if (A.name == 'EChineseSoldier18')
            SoundActors[1] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    AlreadyHeard=0;
    SamCheckFlagA=0;
    SamCheckFlagB=0;
    SamCheckFlagC=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
GuardWakeUp:
    Log("GuardWakeUp");
	SoundActors[0].PlaySound(Sound'SoundEvent.Stop_Sq_HumanSnore', SLOT_SFX);
	SoundActors[1].PlaySound(Sound'SoundEvent.Stop_Sq_HumanSnore', SLOT_SFX);
    SetExclusivity(FALSE);
    End();

}

