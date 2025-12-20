//=============================================================================
// P_1_1_0_Tbilisi_ShakeRattleNRoll
//=============================================================================
class P_1_1_0_Tbilisi_ShakeRattleNRoll extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\SoundEvent.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Blocked;


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
    Blocked=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern controls the ambient camera shake and creaking and cracking effects for the burning building");
Shake:
    Log("Effect Number One Triggered");
	PlaySound(Sound'SoundEvent.Play_BigwoodCreak1', SLOT_Ambient);
    ShakeCamera(400, 6000, 900);
    End();
Rattle:
    Log("Effect number two triggered");
	PlaySound(Sound'SoundEvent.Play_BigwoodCreak5', SLOT_Ambient);
    ShakeCamera(300, 7000, 1100);
    End();
Roll:
    Log("Effect Number 3 triggered");
	PlaySound(Sound'SoundEvent.Play_BigwoodCreak4', SLOT_Ambient);
    ShakeCamera(200, 8000, 1000);
    End();
BlockadeRunner:
    Log("");
    CheckFlags(Blocked,TRUE,'DoNothing');
    SendUnrealEvent('BlockPath');
    ShakeCamera(1000, 17000, 4000);
    SetFlags(Blocked,TRUE);
    End();
FreezeGameOver:
    Log("This section of this pattern is used to freeze Sam if he goes down on the streets because the Lambert Pattern may still be running.");
    PlayerMove(false);
    SendPatternEvent('LambertAI','SamOnStreets');
    End();
DoNothing:
    Log("Doing nothing");

}

