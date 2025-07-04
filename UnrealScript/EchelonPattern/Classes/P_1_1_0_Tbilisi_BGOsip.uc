//=============================================================================
// P_1_1_0_Tbilisi_BGOsip
//=============================================================================
class P_1_1_0_Tbilisi_BGOsip extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_UNCONSCIOUS:
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
        if(P.name == 'ERussianCivilian34')
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
    Log("This is the pattern for Background NPC Osip.");
    Log("FIRST AREA.");
AOsip:
    Log("");
    ResetGroupGoals();
    ChangeGroupState('s_default');
    Teleport(1, 'Osip20FakePatrol');
OALoop:
    Goal_Default(1,GOAL_Guard,9,,'OFocB',,'Osip10FakePatrol',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(35);
    Goal_Default(1,GOAL_Guard,9,,'OFocA',,'Osip20FakePatrol',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(12);
    Jump('OALoop');
    End();
ManDown:
    Log("Checking if Osip is dead");
    CheckIfIsDead(1,'DeadOsip');
    End();
DeadOsip:
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

