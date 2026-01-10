//=============================================================================
// V4_2_1_Abattoir
//=============================================================================
class V4_2_1_Abattoir extends EVariable;

var int AlreadySwitched;
var int RoofLightPass;
var int Room1Pass1;
var int SpetzOnRoof;
var int SwitchActive;
var int TowerTeleported;


function PostBeginPlay()
{
    AlreadySwitched = 0;
    RoofLightPass = 0;
    Room1Pass1 = 0;
    SpetzOnRoof = 0;
    SwitchActive = 1;
    TowerTeleported = 0;
}

