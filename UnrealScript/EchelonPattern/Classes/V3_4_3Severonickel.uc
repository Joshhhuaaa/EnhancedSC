//=============================================================================
// V3_4_3Severonickel
//=============================================================================
class V3_4_3Severonickel extends EVariable;

var int AlarmStarted;
var int AllSAMActive;
var int OneSAMActive;
var int SafeToKillMasse;
var int ServerActive;
var int TwoSAMActive;


function PostBeginPlay()
{
    AlarmStarted = 0;
    AllSAMActive = 1;
    OneSAMActive = 1;
    SafeToKillMasse = 0;
    ServerActive = 1;
    TwoSAMActive = 1;
}

defaultproperties
{
}
