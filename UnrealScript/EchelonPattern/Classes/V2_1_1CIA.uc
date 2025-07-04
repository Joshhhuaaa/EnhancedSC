//=============================================================================
// V2_1_1CIA
//=============================================================================
class V2_1_1CIA extends EVariable;

var int F2000get; 
var int ServerDone; 


function PostBeginPlay()
{
    F2000get = 0;
    ServerDone = 0;
}

