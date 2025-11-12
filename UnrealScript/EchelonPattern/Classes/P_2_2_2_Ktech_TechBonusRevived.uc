//=============================================================================
// P_2_2_2_Ktech_TechBonusRevived
//=============================================================================
class P_2_2_2_Ktech_TechBonusRevived extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'EMercenaryTechnician7')
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
RevivingTech:
    Log("RevivingTech");
    ResetNPC(1,TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkDnAlBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Default(1,GOAL_Wait,9,,,,,'TalkDnAlNt0',FALSE,,,,);
    End();

}

