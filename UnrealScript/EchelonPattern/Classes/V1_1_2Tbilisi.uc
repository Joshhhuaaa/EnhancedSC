//=============================================================================
// V1_1_2Tbilisi
//=============================================================================
class V1_1_2Tbilisi extends EVariable;

var int BodyFound;
var int GateOpen;
var int GotTape;
var int OneCiviDead;


function PostBeginPlay()
{
    BodyFound = 0;
    GateOpen = 0;
    GotTape = 0;
    OneCiviDead = 0;
}

