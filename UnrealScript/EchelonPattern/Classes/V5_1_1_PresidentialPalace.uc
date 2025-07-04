//=============================================================================
// V5_1_1_PresidentialPalace
//=============================================================================
class V5_1_1_PresidentialPalace extends EVariable;

var int AlarmOneActivated; 
var int AlarmThreeActivated; 
var int AlarmTwoActivated; 
var int LaptopAccessed; 


function PostBeginPlay()
{
    AlarmOneActivated = 0;
    AlarmThreeActivated = 0;
    AlarmTwoActivated = 0;
    LaptopAccessed = 0;
}

