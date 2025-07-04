//=============================================================================
// P_4_1_2_CEmb_FollowTruck
//=============================================================================
class P_4_1_2_CEmb_FollowTruck extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Vehicules.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int ClosingGate;


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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EAnimatedObject1')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    ClosingGate=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Events:
    Log("Events");
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_ChineseVanStart', SLOT_SFX);
    SendUnrealEvent('minivi');
    SendPatternEvent('Group1112','Milestone');
    Sleep(1.50);
    SendUnrealEvent('WarehouseGate');
    End();
ClosingGate:
    Log("When the truck pass the booth");
    CheckFlags(ClosingGate,TRUE,'AlreadyClosed');
    SetFlags(ClosingGate,TRUE);
    DisableMessages(TRUE, TRUE);
    SendUnrealEvent('EmbassyGatePost');
    Sleep(1.5);
    SendUnrealEvent('EmbassyGate');
    Sleep(2);
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_ChineseVanStart', SLOT_SFX);
    SendUnrealEvent('minivi');
    Sleep(1);
    SendPatternEvent('BogusGateAI','GateClosed');
AlreadyClosed:
    End();

}

