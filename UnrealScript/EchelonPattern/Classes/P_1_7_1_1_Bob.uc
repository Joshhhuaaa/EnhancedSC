//=============================================================================
// P_1_7_1_1_Bob
//=============================================================================
class P_1_7_1_1_Bob extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('KOorKillBob');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KOorKillBob');
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
        if (P.name == 'EBobrov0')
        {
            Characters[1] = P.controller;
            // Joshua - Set Bobrov as dying so Sam crouches during this conversation
            EPawn(P).bDyingDude = true;
        }
        if (P.name == 'ELambert0')
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
KOorKillBob:
    Log("KOorKillBob");
    CheckFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).BobDone,TRUE,'End');
LambertCallsItOffBob:
    Log("LambertCallsItOffBob");
    SetProfileDeletion();
    PlayerMove(false);
    Speech(Localize("P_1_7_1_1_Bob", "Speech_0001L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_22_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 0);
End:
    End();

}

defaultproperties
{
}
