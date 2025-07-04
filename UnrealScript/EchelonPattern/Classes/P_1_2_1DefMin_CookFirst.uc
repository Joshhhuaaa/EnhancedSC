//=============================================================================
// P_1_2_1DefMin_CookFirst
//=============================================================================
class P_1_2_1DefMin_CookFirst extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Smoking;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Milestone');
            break;
        case AI_GRABBED:
            EventJump('Alerted');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Alerted');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('Alerted');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Alerted');
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
        if(P.name == 'ECook2')
            Characters[1] = P.controller;
        if(P.name == 'ELambert0')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Smoking=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneCookFirst");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).CookTwoDead,TRUE,'BothDead');
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).CookOneDead,TRUE);
    Speech(Localize("P_1_2_1DefMin_CookFirst", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_90_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
BothDead:
    Log("BothDeadCookFirst");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_2_1DefMin_CookFirst", "Speech_0002L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_90_02', 2, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 2);
    End();
WindowPuffing:
    Log("WindowPuffing");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).InterroDone,FALSE,'End');
    DisableMessages(FALSE, TRUE);
    SendUnrealEvent('WindowVolumePreventsBug');
    SendUnrealEvent('KitchenAeration');
    Goal_Default(1,GOAL_Wait,1,,'EFocusPointForFirstCook','EFocusPointForFirstCook','CookInitialPositionA','1220cook2',FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,9,,,,'SniperOptMovesHereA',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    CinCamera(0, 'WindowShortCS', 'WindowShortCSFok',);
    Goal_Set(1,GOAL_Guard,8,,'CigaretteFocus','CigaretteFocus','SniperOptMovesHereA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(2);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'CigaretteFocus','CigaretteFocus',,'CiggStNmBg0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,8,,'CigaretteFocus','CigaretteFocus',,'CiggStNmPf0',FALSE,,,,);
    Sleep(3);
    CinCamera(1, , ,);
    SetExclusivity(FALSE);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,7,,'CigaretteFocus','CigaretteFocus',,'CiggStNmEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'CookInitialPositionA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Guard,8,,'EFocusPointForFirstCook','EFocusPointForFirstCook','CookInitialPositionA',,FALSE,,,,);
    Sleep(1);
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,'EFocusPointForFirstCook','EFocusPointForFirstCook',,'CookStNmAA0',FALSE,,,,);
    SetExclusivity(FALSE);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).CooksAlerted,TRUE);
    SetExclusivity(FALSE);
End:
    End();

}

