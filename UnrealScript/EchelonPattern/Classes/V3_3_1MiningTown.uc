//=============================================================================
// V3_3_1MiningTown
//=============================================================================
class V3_3_1MiningTown extends EVariable;

var int BridgeAlerted; 
var int DormitoryAlerted; 
var int FirstHousesAlerted; 
var int GhettoAlerted; 
var int InsideHQAlerted; 
var int InterroAlerted; 
var int LeadTechDone; 
var int OneNoKillDone; 
var int OutsideHQAlerted; 
var int PowerHouseAlerted; 
var int SecondPlazaAlerted; 


function PostBeginPlay()
{
    BridgeAlerted = 0;
    DormitoryAlerted = 0;
    FirstHousesAlerted = 0;
    GhettoAlerted = 0;
    InsideHQAlerted = 0;
    InterroAlerted = 0;
    LeadTechDone = 0;
    OneNoKillDone = 0;
    OutsideHQAlerted = 0;
    PowerHouseAlerted = 0;
    SecondPlazaAlerted = 0;
}

defaultproperties
{
}
