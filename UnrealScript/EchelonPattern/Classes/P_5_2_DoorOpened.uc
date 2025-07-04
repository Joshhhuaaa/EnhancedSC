//=============================================================================
// P_5_2_DoorOpened
//=============================================================================
class P_5_2_DoorOpened extends EPattern;

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
        if(P.name == 'EEliteForceCristavi17')
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
Milestone:
    Log("Milestone");
    SetExclusivity(FALSE);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'KitchenSweep5_150',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'CameraFocOne','CameraFocOne','KitchenSweep5_150',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(2);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SendBackup;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();

}

