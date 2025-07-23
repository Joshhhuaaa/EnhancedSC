//=============================================================================
// P_2_2_1_Ktech_IntroGuard
//=============================================================================
class P_2_2_1_Ktech_IntroGuard extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'EMafiaMuscle2')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle1')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
IntroGuard:
    Log("First 2 guards coming");
    SendPatternEvent('LambertComms','MapStartLambertComNew'); // Joshua - Lambert dialogue will begin when leaving Wilkes
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'IntroGuardNode01',,TRUE,,MOVE_WalkNormal,,MOVE_WalkRelaxed);
    Sleep(2);
    Goal_Default(1,GOAL_Guard,8,,'IntroGuardFocusNode01',,'IntroGuardNode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'IntroGuardNode02',,FALSE,,MOVE_WalkNormal,,MOVE_WalkRelaxed);
    Sleep(4);
    Goal_Set(2,GOAL_Stop,8,,'IntroGuardFocusNode05',,'IntroGuardNode02',,FALSE,3,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,7,,,,'IntroGuardNode03',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Stop,6,,'IntroGuardFocusNode02',,'IntroGuardNode03',,FALSE,4,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,5,,,,'IntroGuardNode04',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Stop,4,,'IntroGuardFocusNode03',,'IntroGuardNode04',,FALSE,4,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,3,,,,'IntroGuardNode05',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Stop,2,,'IntroGuardFocusNode04',,'IntroGuardNode05',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,1,,'IntroGuardFocusNode05',,'IntroGuardNode02',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,0,,'IntroGuardFocusNode05',,'IntroGuardNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    SendPatternEvent('IntroCinematic','WilkesTeleport');

}

