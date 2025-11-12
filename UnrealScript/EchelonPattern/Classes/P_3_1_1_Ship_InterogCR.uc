//=============================================================================
// P_3_1_1_Ship_InterogCR
//=============================================================================
class P_3_1_1_Ship_InterogCR extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


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
        if (P.name == 'EMercenaryTechnician3')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ElevatorCode:
    Log("Code for unlocking 4floor in elevator");
    CheckIfGrabbed(1,'Talk1');
    End();
Talk1:
    Log("Give Elevator code");
    CheckFlags(pass1,TRUE,'Talk2');
    SetFlags(pass1,TRUE);
    Speech(Localize("P_3_1_1_Ship_InterogCR", "Speech_0002L", "Localization\\P_3_1_1_ShipYard"), None, 1, 1, TR_CONVERSATION, 0, false);
    Sleep(6);
    Close();
    AddNote("", "P_3_1_1_Ship_InterogCR", "Note_0001L", "Localization\\P_3_1_1_ShipYard");
    End();
Talk2:
    Log("Thats all I know");
    Speech(Localize("P_3_1_1_Ship_InterogCR", "Speech_0003L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Close();
    End();

}

defaultproperties
{
}
