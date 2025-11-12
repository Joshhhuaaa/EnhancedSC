//=============================================================================
// P_2_2_2_Ktech_InterceptedComms
//=============================================================================
class P_2_2_2_Ktech_InterceptedComms extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
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
IComm22_21_2:
    Log("Intercepted Enemy Communication 22_21 (2nd Call)");
    Speech("We have a report or an intruder on a lower level of the building. Everybody to full alert.", None, 1, 0, TR_NPCS);
    Sleep(5);
    Close();
    End();
IComm22_21_3:
    Log("Intercepted Enemy Communication 22_21 (3rd Call)");
    Speech("Somebody just reported intruders. We don't know how many, everybody to full alert.", None, 1, 0, TR_NPCS);
    Sleep(5);
    Close();
    End();

}

