//=============================================================================
// P_1_1_1_Tbilisi_BGQuarterBack
//=============================================================================
class P_1_1_1_Tbilisi_BGQuarterBack extends EPattern;

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
    Log("This pattern is a governor whose only purpose is to send pattern events to other patterns to move and control the background civilians");
NearingApartment:
    Log("This label sends to civilian AIs behind Blausteins apartment");
    SendPatternEvent('BGAnton','BAnton');
    Sleep(1);
    SendPatternEvent('BGLazar','BLazar');
    Sleep(1);
    SendPatternEvent('BGOsip','BOsip');
    Sleep(1);
    SendPatternEvent('BGTaras','BTaras');
    End();
NearDrunks:
    Log("This label sends to the civilians near the cops and drunk");
    SendPatternEvent('BGAnton','CAnton');
    Sleep(1);
    SendPatternEvent('BGLazar','CLazar');
    Sleep(1);
    SendPatternEvent('BGOsip','COsip');
    Sleep(1);
    SendPatternEvent('BGTaras','CTaras');
    Sleep(1);
    End();
Morevi:
    Log("This label send events for civilians near Morevi Square.");
    SendPatternEvent('BGAnton','DAnton');
    End();
ThruGate:
    Log("Sending event to sniper pattern and to street level civilians");
    SendPatternEvent('LoneCop','LeonBlink');
    SendPatternEvent('BGVenedict','VenedictPat');
    SendPatternEvent('BGTaras','BTaras');
    SendPatternEvent('BGOsip','OsipFinal');
    SendPatternEvent('BGLazar','LazarFinal');
    End();
StationApproach:
    Log("Nearing the police station");
    SendPatternEvent('BGAnton','AntonEnder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

