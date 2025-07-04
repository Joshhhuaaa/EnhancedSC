//=============================================================================
// P_3_1_1_Ship_DamageCamera
//=============================================================================
class P_3_1_1_Ship_DamageCamera extends EPattern;

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
        if(P.name == 'spetsnaz46')
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
DamageCamera:
    Log("lvl4 guard talk about the damage camera");
    Speech(Localize("P_3_1_1_Ship_DamageCamera", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(8);
    Close();
    End();

}

defaultproperties
{
}
