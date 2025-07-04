//=============================================================================
// P_3_2_2_NPP_InventoryTech
//=============================================================================
class P_3_2_2_NPP_InventoryTech extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Eight;
var int Eleven;
var int Five;
var int Four;
var int Nine;
var int One;
var int Seven;
var int Six;
var int Ten;
var int Thirteen;
var int Three;
var int Twelve;
var int Two;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_GRABBED:
            EventJump('Grabbed');
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

    if( !bInit )
    {
    bInit=TRUE;
    Eight=0;
    Eleven=0;
    Five=0;
    Four=0;
    Nine=0;
    One=0;
    Seven=0;
    Six=0;
    Ten=0;
    Thirteen=0;
    Three=0;
    Twelve=0;
    Two=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Grabbed:
    Log("Tim's been grabbed in a bad place!!  Oh no!!!");
    CheckIfGrabbed(1,'Interrogate');
    End();
Interrogate:
    Log("Interrogating Tim.");
    CheckFlags(One,TRUE,'One');
    SetFlags(One,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_01', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_02', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_03', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_04', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_05', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_06', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_07', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_08', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_09', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_10', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_11', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_12', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_13', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_14', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    SendPatternEvent('LambertAI','Inventory');
    End();
One:
    Log("Sam is prodding the Inventory tech.");
    CheckFlags(Two,TRUE,'Two');
    SetFlags(Two,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_15', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_2_2Voice.Play_32_35_16', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Two:
    Log("Sam has prodded the Inventory tech 2 times.");
    CheckFlags(Three,TRUE,'Three');
    SetFlags(Three,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_17', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Three:
    Log("Sam has prodded the Inventory tech 3 times.");
    CheckFlags(Four,TRUE,'Four');
    SetFlags(Four,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_18', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Four:
    Log("Sam has prodded the Inventory tech 4 times.");
    CheckFlags(Five,TRUE,'Five');
    SetFlags(Five,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_17', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Five:
    Log("Sam has prodded the Inventory tech 5 times.");
    CheckFlags(Six,TRUE,'Six');
    SetFlags(Six,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_18', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Six:
    Log("Sam has prodded the Inventory tech 6 times.");
    CheckFlags(Seven,TRUE,'Seven');
    SetFlags(Seven,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_17', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Seven:
    Log("Sam has prodded the Inventory tech 7 times.");
    CheckFlags(Eight,TRUE,'Eight');
    SetFlags(Eight,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_18', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Eight:
    Log("Sam has prodded the Inventory tech 8 times.");
    CheckFlags(Nine,TRUE,'Nine');
    SetFlags(Nine,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_17', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Nine:
    Log("Sam has prodded the Inventory tech 9 times.");
    CheckFlags(Ten,TRUE,'Ten');
    SetFlags(Ten,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_18', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Ten:
    Log("Sam has prodded the Inventory tech 10 times.");
    CheckFlags(Eleven,TRUE,'Eleven');
    SetFlags(Eleven,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_17', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Eleven:
    Log("Sam has prodded the Inventory tech 11 times.");
    CheckFlags(Twelve,TRUE,'Twelve');
    SetFlags(Twelve,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_18', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Twelve:
    Log("Sam has prodded the Inventory tech 12 times.");
    CheckFlags(Thirteen,TRUE,'Thirteen');
    SetFlags(Thirteen,TRUE);
    Talk(Sound'S3_2_2Voice.Play_32_35_17', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
Thirteen:
    Log("Sam has prodded the Inventory tech 13 times.  LUCKY THIRTEEN!!");
    SetFlags(Three,FALSE);
    SetFlags(Four,FALSE);
    SetFlags(Five,FALSE);
    SetFlags(Six,FALSE);
    SetFlags(Seven,FALSE);
    SetFlags(Eight,FALSE);
    SetFlags(Nine,FALSE);
    SetFlags(Ten,FALSE);
    SetFlags(Eleven,FALSE);
    SetFlags(Twelve,FALSE);
    SetFlags(Thirteen,FALSE);
    Talk(Sound'S3_2_2Voice.Play_32_35_19', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(None, 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();

}

defaultproperties
{
}
