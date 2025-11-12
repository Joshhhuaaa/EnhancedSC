//=============================================================================
// P_3_1_1_Ship_InterogBib
//=============================================================================
class P_3_1_1_Ship_InterogBib extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;
var int pass2;
var int pass3;


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
        if (P.name == 'EMercenaryTechnician0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    pass2=0;
    pass3=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ElevatorCode:
    Log("");
    CheckIfGrabbed(1,'Talk1');
    End();
Talk1:
    Log("");
    CheckFlags(pass1,TRUE,'Talk2');
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 0, 1, TR_CONVERSATION, 0, false);
    Sleep(5);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0005L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0006L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0007L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0008L", "Localization\\P_3_1_1_ShipYard"), None, 1, 1, TR_CONVERSATION, 0, false);
    Sleep(4);
    AddNote("", "P_3_1_1_Ship_InterogBib", "Note_0003L", "Localization\\P_3_1_1_ShipYard");
    AddNote("", "P_3_1_1_Ship_InterogBib", "Note_0014L", "Localization\\P_3_1_1_ShipYard");
    SetFlags(pass1,TRUE);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0009L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0010L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Talk2:
    Log("");
    CheckFlags(pass2,TRUE,'talk3');
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0011L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0002L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    SetFlags(pass2,TRUE);
    Close();
    End();
talk3:
    Log("");
    CheckFlags(pass3,TRUE,'talk4');
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0012L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    SetFlags(pass3,TRUE);
    Close();
    End();
talk4:
    Log("");
    Speech(Localize("P_3_1_1_Ship_InterogBib", "Speech_0013L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Close();
    End();

}

defaultproperties
{
}
