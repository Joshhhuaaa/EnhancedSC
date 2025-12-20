//=============================================================================
// V4_1_1ChineseEmbassy
//=============================================================================
class V4_1_1ChineseEmbassy extends EVariable;

var int GoalAgencyContact; // Joshua - Keep track if the player completed this objective before proceeding to the second part


function PostBeginPlay()
{
    GoalAgencyContact = 0;
}

