//=============================================================================
// V1_2_1DefenseMinistry
//=============================================================================
class V1_2_1DefenseMinistry extends EVariable;

var int CookOneDead; 
var int CooksAlerted; 
var int CookTwoDead; 
var int FirstNPCAlerted; 
var int HallwayAlerted; 
var int HamletAlerted; 
var int InterroDone; 
var int LambertPostLaserSpoken; 
var int LaserDown; 
var int LaserMicDone; 
var int TooFastLaserMic; 
var int WestWingFastDone; 


function PostBeginPlay()
{
    CookOneDead = 0;
    CooksAlerted = 0;
    CookTwoDead = 0;
    FirstNPCAlerted = 0;
    HallwayAlerted = 0;
    HamletAlerted = 0;
    InterroDone = 0;
    LambertPostLaserSpoken = 0;
    LaserDown = 0;
    LaserMicDone = 0;
    TooFastLaserMic = 0;
    WestWingFastDone = 0;
}

