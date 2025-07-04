//=============================================================================
// P_3_3_1_Mine_GeeksSleeping
//=============================================================================
class P_3_3_1_Mine_GeeksSleeping extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('KillDone');
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
        if(P.name == 'EMercenaryTechnician5')
            Characters[1] = P.controller;
        if(P.name == 'EMercenaryTechnician1')
            Characters[2] = P.controller;
        if(P.name == 'ELambert1')
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
KillDone:
    Log("KillDone");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE,'TooMuchKill');
    SetFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE);
    Speech(Localize("P_3_3_1_Mine_GeeksSleeping", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
TooMuchKill:
    Log("TooMuchKill");
    SetProfileDeletion();
    Speech(Localize("P_3_3_1_Mine_GeeksSleeping", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
    End();

}

defaultproperties
{
}
