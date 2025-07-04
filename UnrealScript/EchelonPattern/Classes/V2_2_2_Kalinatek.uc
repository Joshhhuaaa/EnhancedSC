//=============================================================================
// V2_2_2_Kalinatek
//=============================================================================
class V2_2_2_Kalinatek extends EVariable;

var int BarkA; 
var int BarkB; 
var int ConversationA; 
var int DefuseBombDone; 
var int FindIvanDone; 
var int FireAlarmDone; 
var int FirstWallMine; 
var int FuseBoxDone; 
var int HostagesDone; 
var int MafiosoKill; 
var int MafiosoKilledHostages; 
var int SecondWallMine; 
var int TechDyingFirstConversation; 
var int WallMinesOff; 


function PostBeginPlay()
{
    BarkA = 0;
    BarkB = 0;
    ConversationA = 0;
    DefuseBombDone = 0;
    FindIvanDone = 0;
    FireAlarmDone = 0;
    FirstWallMine = 0;
    FuseBoxDone = 0;
    HostagesDone = 0;
    MafiosoKill = 0;
    MafiosoKilledHostages = 0;
    SecondWallMine = 0;
    TechDyingFirstConversation = 0;
    WallMinesOff = 0;
}

