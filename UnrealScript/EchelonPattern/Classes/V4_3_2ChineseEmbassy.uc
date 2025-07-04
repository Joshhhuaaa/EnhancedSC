//=============================================================================
// V4_3_2ChineseEmbassy
//=============================================================================
class V4_3_2ChineseEmbassy extends EVariable;

var int CanKillKeypadB; 
var int CanKillKeypadC; 
var int FeirongCanDie; 
var int FeirongObjectiveDone; 
var int KeypadBColonelSwitch; 
var int KeypadBDoorClosed; 
var int KeypadBExpiredToggle; 
var int KeypadCColonelSwitch; 
var int KeypadCDoorClosed; 
var int KeypadCExpiredToggle; 
var int KeypadCLastDoorCrossed; 
var int NPCwentInElev; 
var int SamInElevator; 
var int SamSwitch; 
var int SamSwitchC; 
var int TruckObjectiveDone; 


function PostBeginPlay()
{
    CanKillKeypadB = 0;
    CanKillKeypadC = 0;
    FeirongCanDie = 0;
    FeirongObjectiveDone = 0;
    KeypadBColonelSwitch = 0;
    KeypadBDoorClosed = 1;
    KeypadBExpiredToggle = 0;
    KeypadCColonelSwitch = 0;
    KeypadCDoorClosed = 1;
    KeypadCExpiredToggle = 0;
    KeypadCLastDoorCrossed = 0;
    NPCwentInElev = 0;
    SamInElevator = 0;
    SamSwitch = 0;
    SamSwitchC = 0;
    TruckObjectiveDone = 0;
}

