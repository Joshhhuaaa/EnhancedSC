//=============================================================================
// V3_4_2Severonickel
//=============================================================================
class V3_4_2Severonickel extends EVariable;

var int DishDone; 
var int GennyOn; 
var int Interrogated; 
var int OkToKOVasilii; 
var int SafeAlarm; 
var int UPSOff; 


function PostBeginPlay()
{
    DishDone = 0;
    GennyOn = 0;
    Interrogated = 0;
    OkToKOVasilii = 0;
    SafeAlarm = 1;
    UPSOff = 0;
}

defaultproperties
{
}
