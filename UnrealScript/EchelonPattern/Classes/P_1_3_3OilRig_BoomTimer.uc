//=============================================================================
// P_1_3_3OilRig_BoomTimer
//=============================================================================
class P_1_3_3OilRig_BoomTimer extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BoomTimerTwoThree:
    Log("Explosion timer inbetween AI checkpoints 2 and 3.");
    JumpRandom('TwoThreeSOne', 0.33, 'TwoThreeSTwo', 0.67, 'TwoThreeSThree', 1.00, , , ,);
TwoThreeSOne:
    Sleep(25);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
TwoThreeSTwo:
    Sleep(30);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
TwoThreeSThree:
    Sleep(35);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
ExpOne:
    Log("Triggering background explosion one.");
    SendPatternEvent('BoomShakalaAI','BoomOne');
    Jump('Null');
ExpTwo:
    Log("Triggering background explosion two.");
    SendPatternEvent('BoomShakalaAI','BoomTwo');
    Jump('Null');
Null:
    End();
BoomTimerThreeFour:
    Log("Explosion timer inbetween AI checkpoints 3 and 4.");
    JumpRandom('ThreeFourSOne', 0.33, 'ThreeFourSOne', 0.67, 'ThreeFourSThree', 1.00, , , ,);
ThreeFourSOne:
    Sleep(20);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
ThreeFourSTwo:
    Sleep(25);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
ThreeFourSThree:
    Sleep(30);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
BoomTimerFourFive:
    Log("Explosion timer inbetween AI checkpoints 4 and 5.");
    JumpRandom('FourFiveSOne', 0.33, 'FourFiveSTwo', 0.67, 'FourFiveSThree', 1.00, , , ,);
FourFiveSOne:
    Sleep(30);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
FourFiveSTwo:
    Sleep(35);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
FourFiveSThree:
    Sleep(40);
    JumpRandom('ExpOne', 0.50, 'ExpTwo', 1.00, , , , , ,);
PostKitchen:
    Log("Explosion timer after the kitchen, slightly escalated attack before the hub.");
    JumpRandom('PKOne', 0.30, 'PKTwo', 0.55, 'PKThree', 0.80, 'PKFour', 1.00, ,);
PKOne:
    Sleep(7.5);
    JumpRandom('PKExpOne', 0.50, 'PKExpTwo', 1.00, , , , , ,);
PKTwo:
    Sleep(10);
    JumpRandom('PKExpOne', 0.50, 'PKExpTwo', 1.00, , , , , ,);
PKThree:
    Sleep(12.5);
    JumpRandom('PKExpOne', 0.50, 'PKExpTwo', 1.00, , , , , ,);
PKFour:
    Sleep(15);
    JumpRandom('PKExpOne', 0.50, 'PKExpTwo', 1.00, , , , , ,);
PKExpOne:
    Log("Triggering background explosion one.");
    SendPatternEvent('BoomShakalakaAI','BoomOne');
    Jump('PostKitchen');
PKExpTwo:
    Log("Triggering background explosion two.");
    SendPatternEvent('BoomShakalakaAI','BoomTwo');
    Jump('PostKitchen');
DelayedPK:
    Log("Slight delay to not overlap with the dead end dialog.");
    Sleep(10);
    Jump('PostKitchen');

}

