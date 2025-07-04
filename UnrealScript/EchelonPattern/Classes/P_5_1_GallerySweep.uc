//=============================================================================
// P_5_1_GallerySweep
//=============================================================================
class P_5_1_GallerySweep extends EPattern;

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
        if(P.name == 'EGeorgianPalaceGuard1')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianPalaceGuard2')
            Characters[2] = P.controller;
        if(P.name == 'EGeorgianPalaceGuard3')
            Characters[3] = P.controller;
        if(P.name == 'EGeorgianPalaceGuard4')
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
GallerySweep:
    Log("Palace Guards enter the gallery to perform a routine sweep.");
    Sleep(4);
    ePawn(Characters[4].Pawn).Bark_Type = BARK_CombArea;
    Talk(ePawn(Characters[4].Pawn).Sounds_Barks, 4, 0, false);
    ChangeGroupState('s_investigate');
    SendUnrealEvent('EIRSensorGoOffForPatrol');
    Goal_Set(4,GOAL_InteractWith,9,,,,'ELightSwitchKalgallery',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(4,GOAL_InteractWith,);
    Goal_Set(4,GOAL_MoveTo,8,,,,'gallery4_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(4,GOAL_Patrol,7,,,,'gallery4_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(4);
    Goal_Set(3,GOAL_MoveTo,9,,,,'gallery3_75',,FALSE,,MOVE_WalkNormal,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Patrol,8,,,,'gallery3_75',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    Goal_Set(1,GOAL_MoveTo,9,,,,'NasayNosayA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'FuckShitMotherFuckBa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,7,,'LookThereDumbassAx','LookThereDumbassAx','FuckShitMotherFuckBa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(4);
    Goal_Set(2,GOAL_MoveTo,9,,,,'NasayNosayA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,,,'gallery1_300',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,7,,'galleryworkshop','galleryworkshop','gallery1_300',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

