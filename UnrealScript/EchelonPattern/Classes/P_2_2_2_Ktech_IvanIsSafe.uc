//=============================================================================
// P_2_2_2_Ktech_IvanIsSafe
//=============================================================================
class P_2_2_2_Ktech_IvanIsSafe extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int BarkA;
var int BarkB;
var int BarkC;
var int BarkD;
var int ConversationA;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('IvanDied');
            break;
        case AI_UNCONSCIOUS:
            EventJump('IvanKnocked');
            break;
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
        if(P.name == 'EIvan0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    BarkA=0;
    BarkB=0;
    BarkC=0;
    BarkD=0;
    ConversationA=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
IvanIsSafe:
    Log("If the player kills the mafioso (conversation between sam and Ivan)");
    CheckFlags(ConversationA,TRUE,'BarkA');
    SetFlags(ConversationA,TRUE);
    Goal_Default(1,GOAL_Wait,9,,'PLAYER',,,'IvanStAlNtA',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_16', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlPrA',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_17', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_18', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlPrA',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_19', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_20', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlAA0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_21', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_22', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlAA0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_23', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_24', 0, , TRUE, 0);
    Goal_Default(1,GOAL_Wait,9,,,,,'IvanStAlNtB',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_25', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlPrB',FALSE,,MOVE_WalkAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_26', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlBB0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_27', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_28', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'IvanStAlCC0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S2_2_2Voice.Play_22_50_29', 1, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_30', 0, , TRUE, 0);
    Talk(Sound'S2_2_2Voice.Play_22_50_31', 1, , TRUE, 0);
    Close();
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).FindIvanDone,TRUE);
    SendPatternEvent('LambertComms','IvanSuccess');
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,9,,'IvanIsSafeFocus02',,'IvanGoHideNode01',,FALSE,,MOVE_WalkAlert,,MOVE_CrouchWalk);
TryAgain:
    Goal_Set(1,GOAL_MoveTo,9,,,,'IvanGoHideNode01',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(1,GOAL_MoveTo,'TryAgain');
    End();
BarkA:
    Log("");
    CheckFlags(BarkA,TRUE,'BarkB');
    Talk(Sound'S2_2_2Voice.Play_22_51_01', 1, , TRUE, 0);
    SetFlags(BarkA,TRUE);
    Close();
    End();
BarkB:
    Log("");
    CheckFlags(BarkB,TRUE,'BarkC');
    Talk(Sound'S2_2_2Voice.Play_22_51_02', 1, , TRUE, 0);
    Close();
    SetFlags(BarkB,TRUE);
    End();
BarkC:
    Log("");
    Talk(Sound'S2_2_2Voice.Play_22_51_03', 1, , TRUE, 0);
    Close();
    End();
IvanDied:
    Log("If Sam Kills Ivan");
    Sleep(2);
    SendPatternEvent('LambertComms','IvanIsDead');
    End();
IvanKnocked:
    Log("If Ivan is knocked");
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).FindIvanDone,TRUE,'MafiosoKilledIvan');
    Sleep(2);
    SendPatternEvent('LambertComms','IvanIsDead');
    End();
MafiosoKilledIvan:
    End();

}

