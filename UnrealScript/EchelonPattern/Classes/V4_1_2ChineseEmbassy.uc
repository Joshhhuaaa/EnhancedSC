//=============================================================================
// V4_1_2ChineseEmbassy
//=============================================================================
class V4_1_2ChineseEmbassy extends EVariable;

var int GateGuardInPosition;
var int GatePosition;
var int LaserMicCompleted;
var int LastMikDone;
var int LimoAtFrontGate;


function PostBeginPlay()
{
    GateGuardInPosition = 0;
    GatePosition = 0;
    LaserMicCompleted = 0;
    LastMikDone = 0;
    LimoAtFrontGate = 0;
}

