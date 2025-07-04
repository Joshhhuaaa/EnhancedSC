//=============================================================================
// V3_3_2MiningTown
//=============================================================================
class V3_3_2MiningTown extends EVariable;

var int GameplayJunkyardAlerted; 
var int GameplayMaintenanceAlerted; 
var int GameplayMineFirstAlerted; 
var int GameplayOreBottomAlerted; 
var int GameplayServersAlerted; 
var int NoKillOneDone; 


function PostBeginPlay()
{
    GameplayJunkyardAlerted = 0;
    GameplayMaintenanceAlerted = 0;
    GameplayMineFirstAlerted = 0;
    GameplayOreBottomAlerted = 0;
    GameplayServersAlerted = 0;
    NoKillOneDone = 0;
}

defaultproperties
{
}
