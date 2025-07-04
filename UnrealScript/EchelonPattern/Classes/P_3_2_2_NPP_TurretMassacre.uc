//=============================================================================
// P_3_2_2_NPP_TurretMassacre
//=============================================================================
class P_3_2_2_NPP_TurretMassacre extends EPattern;

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

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Commence:
    Log("Activates the reinforcements for the turret gameplay.");
    Sleep(10);
    ChangeGroupState('s_alert');
    Teleport(1, 'TurretTele1');
    Teleport(2, 'TurretTele2');
    Teleport(3, 'TurretTele3');
    Teleport(4, 'TurretTele4');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ChargePoint1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ChargePoint2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ChargePoint3',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ChargePoint4',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}
