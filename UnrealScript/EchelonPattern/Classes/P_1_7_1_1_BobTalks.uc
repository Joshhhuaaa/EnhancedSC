//=============================================================================
// P_1_7_1_1_BobTalks
//=============================================================================
class P_1_7_1_1_BobTalks extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TalkedFourth;
var int TalkedOnce;
var int TalkedThree;
var int TalkedTwice;


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
        if(P.name == 'EBobrov0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    TalkedFourth=0;
    TalkedOnce=0;
    TalkedThree=0;
    TalkedTwice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneBobTalks:
    Log("MilestoneBobTalks");
    SendPatternEvent('Downstairs','KillSoundDownstairs');
    CheckFlags(TalkedOnce,TRUE,'SecondBobTalks');
    SetFlags(TalkedOnce,TRUE);
    Talk(Sound'S3_1_1Voice.Play_31_20_01', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_02', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_03', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_04', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_05', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_06', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_07', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_08', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_09', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_10', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_11', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_12', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_13', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_14', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_15', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_16', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_17', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_18', 1, , TRUE, 0);
    Close();
    AddNote("", "P_1_7_1_1_BobTalks", "Note_0028L", "Localization\\P_1_7_1_1VselkaInfiltration");
    AddNote("", "P_1_7_1_1_BobTalks", "Note_0029L", "Localization\\P_1_7_1_1VselkaInfiltration");
    SetFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).BobDone,TRUE);
    SendUnrealEvent('ControlRoomDoors');
    SendPatternEvent('LambertGoals','SubmarineInfiltrateLambertGoals');
    End();
SecondBobTalks:
    Log("SecondBobTalks");
    CheckFlags(TalkedTwice,TRUE,'ThirdBobTalks');
    SetFlags(TalkedTwice,TRUE);
    Talk(Sound'S3_1_1Voice.Play_31_20_19', 1, , TRUE, 0);
    Close();
    End();
ThirdBobTalks:
    Log("ThirdBobTalks");
    CheckFlags(TalkedThree,TRUE,'FourthBobTalks');
    SetFlags(TalkedThree,TRUE);
    Talk(Sound'S3_1_1Voice.Play_31_20_20', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_21', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_20_22', 1, , TRUE, 0);
    Close();
    End();
FourthBobTalks:
    Log("FourthBobTalks");
    CheckFlags(TalkedFourth,TRUE,'FifthBobTalks');
    SetFlags(TalkedFourth,TRUE);
    Talk(Sound'S3_1_1Voice.Play_31_20_23', 1, , TRUE, 0);
    Close();
    End();
FifthBobTalks:
    Log("FifthBobTalks");
    Talk(Sound'S3_1_1Voice.Play_31_20_24', 1, , TRUE, 0);
    Close();
    EndConversation();
    End();

}

defaultproperties
{
}
