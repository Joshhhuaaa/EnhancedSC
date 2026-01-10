//=============================================================================
// V4_3_1ChineseEmbassy
//=============================================================================
class V4_3_1ChineseEmbassy extends EVariable;

var int BasementDataDone;
var int BothKeypadADied;
var int ColonelOnRetinal;
var int DestroyFeirongComputer;
var int DoorPassed;
var int FeirongSawSam;
var int KeypadAColonelSwitch;
var int KeypadASoldierSwitch;
var int KeypadExpiredToggle;
var int KeypadWasUsed;
var int RetinalColonelSwitch;
var int RetinalSoldierSwitch;
var int SamSwitch;
var int ThermalKeypadADoorClosed;


function PostBeginPlay()
{
    BasementDataDone = 0;
    BothKeypadADied = 0;
    ColonelOnRetinal = 0;
    DestroyFeirongComputer = 0;
    DoorPassed = 0;
    FeirongSawSam = 0;
    KeypadAColonelSwitch = 0;
    KeypadASoldierSwitch = 0;
    KeypadExpiredToggle = 0;
    KeypadWasUsed = 0;
    RetinalColonelSwitch = 0;
    RetinalSoldierSwitch = 0;
    SamSwitch = 0;
    ThermalKeypadADoorClosed = 1;
}

