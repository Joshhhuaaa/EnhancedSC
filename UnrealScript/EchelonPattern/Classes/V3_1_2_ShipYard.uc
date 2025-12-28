//=============================================================================
// V3_1_2_Shipyard
//=============================================================================
class V3_1_2_Shipyard extends EVariable;

var int CRtrapPass1; 
var int ElevCamDanger; 
var int ElevGuard; 
var int HNGpsrlPass1; 


function PostBeginPlay()
{
    CRtrapPass1 = 0;
    ElevCamDanger = 0;
    ElevGuard = 0;
    HNGpsrlPass1 = 0;
}

defaultproperties
{
}
