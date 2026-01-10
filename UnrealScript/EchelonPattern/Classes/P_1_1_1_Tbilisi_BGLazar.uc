//=============================================================================
// P_1_1_1_Tbilisi_BGLazar
//=============================================================================
class P_1_1_1_Tbilisi_BGLazar extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'ERussianCivilian0')
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
    Log("This is the pattern for Background NPC Lazar");
    Log("SECOND AREA");
BLazar:
    Log("");
    CheckIfIsDead(1,'DeadLazar');
    ResetNPC(1,FALSE);
    ResetGroupGoals();
    ChangeGroupState('s_default');
LazarSwitch:
    JumpRandom('DRoute', 0.50, 'ERoute', 1.00, , , , , ,);
DRoute:
    Log("");
    Teleport(1, 'LazAgainPt');
    Goal_Set(1,GOAL_MoveTo,9,,,,'LazPtio',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('LazarSwitch');
ERoute:
    Log("");
    Teleport(1, 'LazPt2io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'LazAgainPt',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('LazarSwitch');
    End();
    Log("THIRD AREA");
CLazar:
    Log("Sending Lazar into the area with the Cops and Drunk");
    CheckIfIsDead(1,'DoNothing');
    ResetNPC(1,FALSE);
    ChangeGroupState('s_default');
    ResetGroupGoals();
Map:
    JumpRandom('AStreet', 0.34, 'BStreet', 0.67, 'CStreet', 1.00, , , ,);
AStreet:
    Log("");
    Teleport(1, 'Lazar10Pattern');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Lazar20Pattern',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Map');
BStreet:
    Log("");
    Teleport(1, 'Lazar20Pattern');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Lazar10Pattern',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Map');
CStreet:
    Log("");
    Teleport(1, 'Lazar10Apartment');
    Goal_Default(1,GOAL_Guard,0,,'Laz2Looky',,'Lazar30Apartment',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(12);
    Goal_Default(1,GOAL_Guard,0,,,,'Lazar20Apartment',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(8);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Lazar10Apartment',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Map');
    End();
    Log("FOURTH AREA no fourth area for Lazar.");
    End();
LazarFinal:
    Log("FIFTH AREA");
    CheckIfIsDead(1,'DoNothing');
    ResetNPC(1,FALSE);
    ResetGroupGoals();
    ChangeGroupState('s_default');
LazarUS:
    JumpRandom('BldgA', 0.34, 'BldgB', 0.68, 'ToChurch', 0.84, 'FromChurch', 1.00, ,);
BldgA:
    Log("Lazar in building A");
    Teleport(1, 'LazarioX');
    Goal_Default(1,GOAL_Guard,0,,,,'A1Build',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(10);
    Goal_Default(1,GOAL_Guard,0,,,,'A2Build',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(8);
    Goal_Set(1,GOAL_MoveTo,9,,,,'LazarioX',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('LazarUS');
    End();
BldgB:
    Log("Lazar in Bldg B");
    Teleport(1, 'LazarioW');
    Goal_Default(1,GOAL_Guard,0,,,,'B1Build',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(12);
    Goal_Default(1,GOAL_Guard,0,,,,'B2Build',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(8);
    Goal_Set(1,GOAL_MoveTo,9,,,,'LazarioW',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('LazarUS');
    End();
ToChurch:
    Log("Lazar to church yard");
    Teleport(1, 'LazarioZ');
    Goal_Set(1,GOAL_MoveTo,9,,,,'LazarioY',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('LazarUS');
    End();
FromChurch:
    Log("Lazar leaves church yard");
    Teleport(1, 'LazarioY');
    Goal_Set(1,GOAL_MoveTo,9,,,,'LazarioZ',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('LazarUS');
    End();
ManDown:
    Log("Checking if Lazar is Dead");
    CheckIfIsDead(1,'DeadLazar');
    End();
DeadLazar:
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

