//=============================================================================
// P_3_3_2_Mine_Quarry
//=============================================================================
class P_3_3_2_Mine_Quarry extends EPattern;

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
        if(P.name == 'spetsnaz34')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz38')
            Characters[2] = P.controller;
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
    Log("MilestoneQuarry");
    ChangeGroupState('s_alert');
    Teleport(1, 'LastTelPointSpetA');
    Teleport(2, 'LastTelPointSpetB');
    CheckFlags(V3_3_2MiningTown(Level.VarObject).GameplayJunkyardAlerted,TRUE,'FirstMember');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BuaryFoc',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Patrol,8,,,,'BuaryFoc',,FALSE,,MOVE_Search,,MOVE_Search);
    Jump('SecondMember');
FirstMember:
    Goal_Set(1,GOAL_MoveTo,9,,,,'Forrrest',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPointSNJU','EFocusPointSNJU','Forrrest',,FALSE,,MOVE_Search,,MOVE_Search);
    Jump('SecondMember');
SecondMember:
    Goal_Set(2,GOAL_MoveTo,9,,,,'LastJunkPa_0',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Patrol,8,,,,'LastJunkPa_0',,FALSE,,MOVE_Search,,MOVE_Search);
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Sleep(1);
    Talk(None, 2, , TRUE, 0);
    Sleep(1);
    Talk(None, 1, , TRUE, 0);
    Sleep(1);
    Talk(None, 2, , TRUE, 0);
    End();

}

defaultproperties
{
}
