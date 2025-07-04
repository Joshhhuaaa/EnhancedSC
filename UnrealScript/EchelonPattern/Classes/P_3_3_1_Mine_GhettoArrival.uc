//=============================================================================
// P_3_3_1_Mine_GhettoArrival
//=============================================================================
class P_3_3_1_Mine_GhettoArrival extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
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
        if(P.name == 'spetsnaz5')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz6')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz27')
            Characters[3] = P.controller;
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
    Log("MilestoneGhettoArrival");
    Speech(Localize("P_3_3_1_Mine_GhettoArrival", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_GhettoArrival", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_GhettoArrival", "Speech_0003L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_NPCS, 0, false);
    Sleep(1);
    Close();
    ChangeGroupState('s_investigate');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    SetFlashLight(3, TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpHomer_200',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Patrol,8,,,,'SpHomer_200',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,9,,,,'SpIvan_100',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Patrol,8,,,,'SpIvan_100',,FALSE,,MOVE_Search,,MOVE_Search);
    CheckFlags(V3_3_1MiningTown(Level.VarObject).SecondPlazaAlerted,TRUE,'WasNotStealthPlaza');
WasStealthPlaza:
    Log("WasStealthPlaza");
    Goal_Set(3,GOAL_MoveTo,9,,,,'SquadAA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(3,GOAL_MoveTo,8,,,,'PostGhetPathD',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(3,GOAL_Guard,7,,'SpHomer_0','SpHomer_0','PostGhetPathD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
WasNotStealthPlaza:
    Log("WasNotStealthPlaza");
    Goal_Set(3,GOAL_MoveTo,9,,,,'deadfocus',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(3,GOAL_Patrol,8,,,,'deadfocus',,FALSE,,MOVE_Search,,MOVE_Search);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).GhettoAlerted,TRUE);
    End();

}

defaultproperties
{
}
