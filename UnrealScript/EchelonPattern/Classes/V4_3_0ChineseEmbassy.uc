//=============================================================================
// V4_3_0ChineseEmbassy
//=============================================================================
class V4_3_0ChineseEmbassy extends EVariable;

// Joshua - New variables to prevent Lambert communication from getting interrupted
var int LambertIntroDone; 
var int LambertKeypadReady; 
var int LambertKeypadStarted;


function PostBeginPlay()
{
    LambertIntroDone = 0;
    LambertKeypadReady = 0;
    LambertKeypadStarted = 0;
}

