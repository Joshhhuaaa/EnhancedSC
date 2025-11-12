//=============================================================================
// P_3_2_1_NPP_CatwalkGuards
//=============================================================================
class P_3_2_1_NPP_CatwalkGuards extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Spot');
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
        if (P.name == 'EFalseRussianSoldier18')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier22')
            Characters[2] = P.controller;
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
Spot:
    Log("Spotlight has seen Sam.");
    Speech(Localize("P_3_2_1_NPP_CatwalkGuards", "Speech_0001L", "Localization\\P_3_2_1_PowerPlant"), None, 1, 0, TR_NPCS, 0, false);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Balcony1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Balcony2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER',,,FALSE,,,,);
    Goal_Set(2,GOAL_Attack,8,,'PLAYER','PLAYER',,,FALSE,,,,);
    Sleep(4);
    Close();
    End();

}

defaultproperties
{
}
