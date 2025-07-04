//=============================================================================
// V1_7_1_1VselkaInfiltration
//=============================================================================
class V1_7_1_1VselkaInfiltration extends EVariable;

var int BobDone; 
var int ContDoorsOpen; 
var int DisableDoor; 


function PostBeginPlay()
{
    BobDone = 0;
    ContDoorsOpen = 1;
    DisableDoor = 0;
}

defaultproperties
{
}
