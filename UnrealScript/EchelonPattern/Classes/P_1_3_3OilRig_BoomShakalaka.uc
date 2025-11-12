//=============================================================================
// P_1_3_3OilRig_BoomShakalaka
//=============================================================================
class P_1_3_3OilRig_BoomShakalaka extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

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
    local Actor A;

    Super.InitPattern();

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger25')
            SoundActors[0] = A;
        if (A.name == 'ESoundTrigger26')
            SoundActors[1] = A;
        if (A.name == 'ESoundTrigger24')
            SoundActors[2] = A;
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
BoomOne:
    Log("Background explosion one triggered.");
    ShakeCamera(240, 20000, 4000);
	SoundActors[0].PlaySound(Sound'DestroyableObjet.Play_Explosion1', SLOT_SFX);
    End();
BoomTwo:
    Log("Background explosion two triggered.");
    ShakeCamera(240, 20000, 4000);
	SoundActors[1].PlaySound(Sound'DestroyableObjet.Play_Explosion2', SLOT_SFX);
    End();
Boom:
    Log("Explosion generator internal 50/50 random function.");
    JumpRandom('BoomOne', 0.50, 'BoomTwo', 1.00, , , , , ,); 

}

