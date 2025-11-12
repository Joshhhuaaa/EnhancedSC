//=============================================================================
// P_4_3_2_OspreyExtraction
//=============================================================================
class P_4_3_2_OspreyExtraction extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\FireSound.uax
#exec OBJ LOAD FILE=..\Sounds\Gun.uax
#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FireTrapAAlreadyTriggered;
var int FireTrapBAlreadyTriggered;
var int FireTrapCAlreadyTriggered;
var int FireTrapDAlreadyTriggered;
var int FireTrapEAlreadyTriggered;


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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EFeirong0')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'Emitter72')
            SoundActors[0] = A;
        if (A.name == 'ESwingingDoor39')
            SoundActors[1] = A;
        if (A.name == 'ESoundTrigger18')
            SoundActors[2] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    FireTrapAAlreadyTriggered=0;
    FireTrapBAlreadyTriggered=0;
    FireTrapCAlreadyTriggered=0;
    FireTrapDAlreadyTriggered=0;
    FireTrapEAlreadyTriggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FireTrapATrigger:
    Log("Triggers FireTrapA");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).FeirongObjectiveDone,FALSE,'DoNotTrigger');
    SendUnrealEvent('FireTrapA1');
    Sleep(0.5);
    SendUnrealEvent('FireTrapA2');
	SoundActors[2].PlaySound(Sound'FireSound.Play_BigFire2', SLOT_SFX);
    SetFlags(FireTrapAAlreadyTriggered,TRUE);
    SendUnrealEvent('FireTrapAFireVolume');
    SendUnrealEvent('AaaaaaaaaaB');
    SendUnrealEvent('AaaaaaaaaaC');
    Sleep(2);
    SendPatternEvent('Icomms','DocumentFire');
DoNotTrigger:
    End();
FireTrapBTrigger:
    Log("Triggers FireTrapB");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).FeirongObjectiveDone,FALSE,'FeirongObjectiveNotDone');
    CheckFlags(FireTrapBAlreadyTriggered,TRUE,'DoNotTrigger');
    Sleep(0.5);
    SendUnrealEvent('FireTrapB');
    SetFlags(FireTrapBAlreadyTriggered,TRUE);
    End();
FeirongObjectiveNotDone:
    Log("FeirongObjectiveNotDone");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
	SoundActors[1].PlaySound(Sound'Gun.Play_MAKASingleShot', SLOT_SFX);
    Sleep(1);
    GameOver(false, 6);
    End();
FireTrapCTrigger:
    Log("Trigger FireTrapC");
    Sleep(0.5);
    SendUnrealEvent('FireTrapC');
    End();
FireTrapDTrigger:
    Log("Triggers FireTrapD");
    CheckFlags(FireTrapDAlreadyTriggered,TRUE,'DoNotTrigger');
    SendUnrealEvent('FireTrapD');
    Sleep(0.5);
    SendUnrealEvent('Window_Plank');
    SetFlags(FireTrapDAlreadyTriggered,TRUE);
    End();
FireTrapETrigger:
    Log("Triggers FireTrapE");
    CheckFlags(FireTrapEAlreadyTriggered,TRUE,'DoNotTrigger');
    SetFlags(FireTrapEAlreadyTriggered,TRUE);
    SendUnrealEvent('FireTrapE');
	SoundActors[0].PlaySound(Sound'DestroyableObjet.Play_Explosion3Wood', SLOT_SFX);
    End();
OspreyExtraction:
    Log("Osprey Extraction");
    GameOver(true, 0);
    End();

}

