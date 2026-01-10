//=============================================================================
// V0_0_3_Training
//=============================================================================
class V0_0_3_Training extends EVariable;

var int ShootBurstActive;
var int ShootFinished;
var int ShootGenActive;
var int ShootNormalActive;
var int ShootSnipeActive;


function PostBeginPlay()
{
    ShootBurstActive = 0;
    ShootFinished = 0;
    ShootGenActive = 1;
    ShootNormalActive = 0;
    ShootSnipeActive = 0;
}

