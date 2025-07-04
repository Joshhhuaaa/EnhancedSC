//=============================================================================
// P_1_1_1_Tbilisi_Clint
//=============================================================================
class P_1_1_1_Tbilisi_Clint extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
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
        if(P.name == 'EMafiaMuscle8')
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
ClintGo:
    Log("This is the pattern for the drop attack mafioso who I've named Clint because I'm running out of good russian names.");
    ChangeGroupState('s_default');
    Teleport(1, 'ClintIn');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,0,,'ClintLooky',,'ClintDiesHere',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

