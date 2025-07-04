//=============================================================================
// P_1_3_3OilRig_MachiDistract
//=============================================================================
class P_1_3_3OilRig_MachiDistract extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int InPosition;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Ditch');
            break;
        case AI_GRABBED:
            EventJump('Ditch');
            break;
        case AI_PLAYER_CLOSE:
            EventJump('Ditch');
            break;
        case AI_PLAYER_FAR:
            EventJump('Ditch');
            break;
        case AI_PLAYER_VERYCLOSE:
            EventJump('Ditch');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Ditch');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Ditch');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Ditch');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Ditch');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Ditch');
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
        if(P.name == 'EGeorgianSoldier17')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianSoldier5')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    InPosition=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Machi:
    Log("Heeere machi machi!");
    CheckFlags(InPosition,FALSE,'Skip');
    ChangeGroupState('s_investigate');
    SetFlags(InPosition,FALSE);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Abbott_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Default(2,GOAL_Wait,2,,,,,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'Abbott','Abbott',,'TalkStNmBB0',FALSE,,,,);
    Goal_Set(1,GOAL_Stop,4,,'Abbott','Abbott',,,FALSE,10,,,);
    Talk(Sound'S1_3_3Voice.Play_13_29_01', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,'Costello','Costello','Abbott_0','TalkStNmAA0',FALSE,,,,);
    Goal_Set(2,GOAL_Stop,4,,'Costello','Costello','Abbott_0',,FALSE,7,,,);
    Talk(Sound'S1_3_3Voice.Play_13_29_02', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'Abbott','Abbott',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S1_3_3Voice.Play_13_29_03', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,'Costello','Costello',,'ReacStNmAA0',FALSE,,,,);
    Talk(Sound'S1_3_3Voice.Play_13_29_04', 2, , TRUE, 0);
    Sleep(1);
    Close();
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'wha',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Stop,8,,'AnotherFocus','AnotherFocus',,,FALSE,8,,,);
    Goal_Set(1,GOAL_Stop,7,,'Abbott','Abbott',,,FALSE,2,,,);
    Goal_Set(2,GOAL_MoveTo,8,,'Costello','Costello','Poopeynode',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_MoveTo,6,,'Costello','Costello','whawhawha',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_Stop,5,,'AnotherFocus','AnotherFocus',,,FALSE,6.9,,,);
    ChangeGroupState('s_default');
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SearchFailedOther;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
Skip:
    End();
Character:
    Log("Show some character dammit!");
    Goal_Set(1,GOAL_Action,9,,,,,'PrsoStNmCC2',FALSE,,,,);
    Goal_Set(2,GOAL_Action,9,,,,,'PrsoStNmDD2',FALSE,,,,);
    End();
MachiAlert:
    Log("Switches MachiDistract guards to alert.");
    ChangeGroupState('s_alert');
    End();
MachiDefault:
    Log("Sets the MachiDistract guards to default behaviour (called by failed WaitForGoal).");
    ChangeGroupState('s_default');
    End();
Ditch:
    Log("InPosition has been compromised, ditching the whole pattern.");
    SendPatternEvent('USCorpse','DistanceCheck');
    End();
MojoJojo:
    SetFlags(InPosition,FALSE);
    Jump('Exclu');
    End();
TurnItOff:
    Log("Turns the machine off.");
    Goal_Set(2,GOAL_InteractWith,5,,'MachiSwitch','MachiSwitch','MachiSwitch',,FALSE,,,,);
    Goal_Default(2,GOAL_Patrol,1,,,,'Abbott_0',,FALSE,,,,);
    End();
Exclu:
    Log("Abandons exclusivity.");
    SetExclusivity(FALSE);
    End();
Bogus:
    Log("Evil robots from the future have killed you!!");
    SendPatternEvent('JedediahAI','GameOverMan');
    SetExclusivity(FALSE);
Null:
    End();

}

