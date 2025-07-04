//=============================================================================
// P_3_1_2_Ship_DockAttack
//=============================================================================
class P_3_1_2_Ship_DockAttack extends EPattern;

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
        if(P.name == 'EMafiaMuscle1')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle2')
            Characters[2] = P.controller;
        if(P.name == 'EMafiaMuscle3')
            Characters[3] = P.controller;
        if(P.name == 'EMafiaMuscle4')
            Characters[4] = P.controller;
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
AlertCall:
    Log("Comunication telling. The intruder is located on the dock area.  All unit converge on position.");
    Speech(Localize("P_3_1_2_Ship_DockAttack", "Speech_0001L", "Localization\\P_3_1_2_ShipYard"), None, 2, 0, TR_NPCS, 0);
    Sleep(4);
    Speech(Localize("P_3_1_2_Ship_DockAttack", "Speech_0002L", "Localization\\P_3_1_2_ShipYard"), None, 3, 0, TR_NPCS, 0);
    Sleep(1);
    Speech(Localize("P_3_1_2_Ship_DockAttack", "Speech_0005L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_NPCS, 0);
    Sleep(1);
    Close();
    End();
TEAMaction:
    Log("");
    Close();
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode172',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,,,'PathNode172',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PathNode156',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,,,'PathNode156',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(3);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'PathNode175',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,,,'PathNode175',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveAndAttack,9,,,,'PathNode165',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Guard,8,,,,'PathNode165',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SendPatternEvent('ggDockB','KillSwitch');
JumpFin:
    Log("");
    End();

}

defaultproperties
{
}
