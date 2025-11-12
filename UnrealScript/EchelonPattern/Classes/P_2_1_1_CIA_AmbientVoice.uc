//=============================================================================
// P_2_1_1_CIA_AmbientVoice
//=============================================================================
class P_2_1_1_CIA_AmbientVoice extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Pass1;
var int Pass2;
var int Pass3;
var int Position1;
var int Position2;
var int Position3;


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
        if (A.name == 'StaticMeshActor653')
            SoundActors[0] = A;
        if (A.name == 'StaticMeshActor420')
            SoundActors[1] = A;
        if (A.name == 'StaticMeshActor654')
            SoundActors[2] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Pass1=0;
    Pass2=0;
    Pass3=0;
    Position1=0;
    Position2=0;
    Position3=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Pos1:
    Log("");
    SetFlags(Position1,TRUE);
    SetFlags(Position2,FALSE);
    SetFlags(Position3,FALSE);
    Jump('Start');
Pos2:
    Log("");
    SetFlags(Position1,FALSE);
    SetFlags(Position2,TRUE);
    SetFlags(Position3,FALSE);
    Jump('Start');
Pos3:
    Log("");
    SetFlags(Position1,FALSE);
    SetFlags(Position2,FALSE);
    SetFlags(Position3,TRUE);
Start:
    Log("");
    JumpRandom('Occurrence1', 0.34, 'Occurrence2', 0.67, 'Occurrence3', 1.00, , , ,); 
    End();
Occurrence1:
    Log("");
    CheckFlags(Pass1,TRUE,'Start');
    SetFlags(Pass1,TRUE);
    CheckFlags(Position3,TRUE,'o1p3');
    CheckFlags(Position2,TRUE,'o1p2');
o1p1:
    AddOneVoice();
	SoundActors[0].PlaySound(Sound'S2_1_Voice.Play_21_71_01', SLOT_Voice);
    End();
o1p2:
    AddOneVoice();
	SoundActors[1].PlaySound(Sound'S2_1_Voice.Play_21_71_01', SLOT_Voice);
    End();
o1p3:
    AddOneVoice();
	SoundActors[2].PlaySound(Sound'S2_1_Voice.Play_21_71_01', SLOT_Voice);
    End();
Occurrence2:
    Log("");
    CheckFlags(Pass2,TRUE,'Start');
    SetFlags(Pass2,TRUE);
    CheckFlags(Position3,TRUE,'o2p3');
    CheckFlags(Position2,TRUE,'o2p2');
o2p1:
    AddOneVoice();
	SoundActors[0].PlaySound(Sound'S2_1_Voice.Play_21_71_02', SLOT_Voice);
    End();
o2p2:
    AddOneVoice();
	SoundActors[1].PlaySound(Sound'S2_1_Voice.Play_21_71_02', SLOT_Voice);
    End();
o2p3:
    AddOneVoice();
	SoundActors[2].PlaySound(Sound'S2_1_Voice.Play_21_71_02', SLOT_Voice);
    End();
Occurrence3:
    Log("");
    CheckFlags(Pass3,TRUE,'Start');
    SetFlags(Pass3,TRUE);
    CheckFlags(Position3,TRUE,'o3p3');
    CheckFlags(Position2,TRUE,'o3p2');
o3p1:
    AddOneVoice();
	SoundActors[0].PlaySound(Sound'S2_1_Voice.Play_21_71_03', SLOT_Voice);
    End();
o3p2:
    AddOneVoice();
	SoundActors[1].PlaySound(Sound'S2_1_Voice.Play_21_71_03', SLOT_Voice);
    End();
o3p3:
    AddOneVoice();
	SoundActors[2].PlaySound(Sound'S2_1_Voice.Play_21_71_03', SLOT_Voice);
    End();

}

