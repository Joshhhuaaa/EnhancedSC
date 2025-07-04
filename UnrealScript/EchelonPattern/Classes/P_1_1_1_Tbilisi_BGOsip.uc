//=============================================================================
// P_1_1_1_Tbilisi_BGOsip
//=============================================================================
class P_1_1_1_Tbilisi_BGOsip extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
    Log("SECOND AREA");
BOsip:
    Log("");
    CheckIfIsDead(1,'DoNothing');
    ResetNPC(1,FALSE);
    ResetGroupGoals();
    ChangeGroupState('s_default');
Dispatch:
    JumpRandom('BLoop', 0.50, 'CLoop', 1.00, , , , , , ); 
BLoop:
    Log("");
    Teleport(1, 'Area2ioA');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Area2ioB',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Dispatch');
CLoop:
    Log("");
    Teleport(1, 'Area2ioB');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Area2ioA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Dispatch');
    End();
    Log("THIRD AREA");
COsip:
    Log("Removing Osip from the public area");
    CheckIfIsDead(1,'DoNothing');
    Teleport(1, 'BGOsipKey');
    ResetNPC(1,FALSE);
    ChangeGroupState('s_default');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,0,,,,'BGOsipKey',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
    Log("FOURTH AREA no fourth area for Osip");
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

