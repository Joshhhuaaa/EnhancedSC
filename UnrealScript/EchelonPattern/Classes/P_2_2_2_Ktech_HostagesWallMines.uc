//=============================================================================
// P_2_2_2_Ktech_HostagesWallMines
//=============================================================================
class P_2_2_2_Ktech_HostagesWallMines extends EPattern;

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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FirstWallMine:
    Log("FirstWallMine");
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).FirstWallMine,TRUE);
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).SecondWallMine,TRUE,'WallMinesOff');
    End();
SecondWallMine:
    Log("SecondWallMine");
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).SecondWallMine,TRUE);
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).FirstWallMine,TRUE,'WallMinesOff');
    End();
WallMinesOff:
    Log("WallMinesOff");
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).WallMinesOff,TRUE);
    PlayerMove(false);
    Sleep(1.5); // Joshua - Reduced from 5, seem unnecessarily long
    SendUnrealEvent('HostagesSaveGame');
    Sleep(1);
    SendUnrealEvent('WallMineTech03');
    PlayerMove(true);
    End();
AbortComms:
    Log("AbortComms");
    DisableMessages(TRUE, TRUE);
    End();

}

