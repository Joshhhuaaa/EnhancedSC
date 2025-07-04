//=============================================================================
// P_2_2_1_Ktech_MetalDetectorAmbush
//=============================================================================
class P_2_2_1_Ktech_MetalDetectorAmbush extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyTeleported;


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
        if(P.name == 'EMafiaMuscle8')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle14')
            Characters[2] = P.controller;
        if(P.name == 'EMafiaMuscle10')
            Characters[3] = P.controller;
        if(P.name == 'EMafiaMuscle9')
            Characters[4] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    AlreadyTeleported=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MetalDetectorSpawnA:
    Log("MetalDetectorSpawnA");
    CheckFlags(AlreadyTeleported,TRUE,'NoTeleport');
    SetFlags(AlreadyTeleported,TRUE);
    Teleport(1, 'MetalDetectorSpawn01');
    Teleport(2, 'WelcomePartyPAPointTag1');
    ResetGroupGoals();
    Sleep(0.1);
    StartAlarm('MetalDetectorAlarm',1);
NoTeleport:
    End();

}

