//=============================================================================
// V1_6_1_1KolaCell
//=============================================================================
class V1_6_1_1KolaCell extends EVariable;

var int BigDoorInOpen;
var int BigDoorOutOpen;
var int FirstLazer;
var int KillObj;
var int Lazerz;
var int PCObj;
var int PreServerLazer;
var int RetinalObj;
var int ServerDoorClosed;
var int ServerObj;
var int SweepCancel;


function PostBeginPlay()
{
    BigDoorInOpen = 1;
    BigDoorOutOpen = 0;
    FirstLazer = 1;
    KillObj = 0;
    Lazerz = 1;
    PCObj = 0;
    PreServerLazer = 1;
    RetinalObj = 0;
    ServerDoorClosed = 0;
    ServerObj = 0;
    SweepCancel = 0;
}

defaultproperties
{
}
