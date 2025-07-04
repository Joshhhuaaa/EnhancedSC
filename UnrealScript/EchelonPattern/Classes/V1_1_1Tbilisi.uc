//=============================================================================
// V1_1_1Tbilisi
//=============================================================================
class V1_1_1Tbilisi extends EVariable;

var int GoalBlackBox; 
var int GoalFollow; 
var int GoalStreets; 
var int OKtoKODrunk; 


function PostBeginPlay()
{
    GoalBlackBox = 0;
    GoalFollow = 0;
    GoalStreets = 0;
    OKtoKODrunk = 0;
}

