//=============================================================================
// V1_2_2DefenseMinistry
//=============================================================================
class V1_2_2DefenseMinistry extends EVariable;

var int AlarmSentByWindow;
var int CPUaccessOnce;
var int CPUbeingAccessedFirst;
var int ElevatorAlerted;
var int FilesDownloadDone;
var int GangWayAlerted;
var int LastAlarmFlag;
var int LastParkingGuyState;
var int NikoLight;
var int ThreesomeAlerted;
var int WilkesKikinAss;


function PostBeginPlay()
{
    AlarmSentByWindow = 0;
    CPUaccessOnce = 0;
    CPUbeingAccessedFirst = 0;
    ElevatorAlerted = 0;
    FilesDownloadDone = 0;
    GangWayAlerted = 0;
    LastAlarmFlag = 0;
    LastParkingGuyState = 0;
    NikoLight = 1;
    ThreesomeAlerted = 0;
    WilkesKikinAss = 0;
}

