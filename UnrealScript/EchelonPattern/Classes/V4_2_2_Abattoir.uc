//=============================================================================
// V4_2_2_Abattoir
//=============================================================================
class V4_2_2_Abattoir extends EVariable;

var int DeadA1; 
var int DeadA2; 
var int DeadC1; 
var int DeadC2; 
var int DeadGrinko; 
var int GDstopLambertGoal; 
var int GrinkoCombatEnded; 
var int HostageType; 
var int Room1Pass1; 
var int GrinkoObjectiveTriggered; // Joshua - Keep track if Grinko objective has been added
var int GrinkoSpeechTriggered; // Joshua - Keep track if Grinko already did his speech


function PostBeginPlay()
{
    DeadA1 = 0;
    DeadA2 = 0;
    DeadC1 = 0;
    DeadC2 = 0;
    DeadGrinko = 0;
    GDstopLambertGoal = 0;
    GrinkoCombatEnded = 0;
    HostageType = 0;
    Room1Pass1 = 0;
    GrinkoObjectiveTriggered = 0;
    GrinkoSpeechTriggered = 0;
}

