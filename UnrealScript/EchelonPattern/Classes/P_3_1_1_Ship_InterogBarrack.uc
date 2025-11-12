//=============================================================================
// P_3_1_1_Ship_InterogBarrack
//=============================================================================
class P_3_1_1_Ship_InterogBarrack extends EPattern;

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
        if (P.name == 'EAzeriColonel1')
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
CodeFreezer:
    Log("Interogation of officer in barrack section.  give freezer code");
    CheckIfGrabbed(1,'talk1');
    End();
talk1:
    Log("give freezer code");
    CheckFlags(pass1,TRUE,'talk2');
    SetFlags(pass1,TRUE);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0005L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0006L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0007L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0008L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0009L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0010L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0011L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0012L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0013L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0014L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0015L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0016L", "Localization\\P_3_1_1_ShipYard"), None, 1, 1, TR_CONVERSATION, 0, false);
    Sleep(2);
    AddNote("", "P_3_1_1_Ship_InterogBarrack", "Note_0002L", "Localization\\P_3_1_1_ShipYard");
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0017L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    SendPatternEvent('EGroupAI21','Start');
    End();
talk2:
    Log("thats all I know");
    CheckFlags(pass2,TRUE,'talk3');
    SetFlags(pass2,TRUE);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Close();
    End();
talk3:
    Log("");
    CheckFlags(pass3,TRUE,'talk4');
    SetFlags(pass3,TRUE);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0018L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0019L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(5);
    Close();
    End();
talk4:
    Log("");
    Speech(Localize("P_3_1_1_Ship_InterogBarrack", "Speech_0020L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Close();
    End();

}

defaultproperties
{
}
