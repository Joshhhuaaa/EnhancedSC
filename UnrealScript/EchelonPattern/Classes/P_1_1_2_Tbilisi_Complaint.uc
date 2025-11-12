//=============================================================================
// P_1_1_2_Tbilisi_Complaint
//=============================================================================
class P_1_1_2_Tbilisi_Complaint extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyCheckedHim;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('SomeoneDead');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Panic');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Panic');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Panic');
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
        if (P.name == 'ERussianCivilian19')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianCop9')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    AlreadyCheckedHim=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Complain:
    Log("A Civilian enters the police station to make a complaint with the desk sergeant");
    Goal_Default(1,GOAL_Wait,0,,'CivilEndFoc',,'CivilianChair','WaitChNmFdA',FALSE,,MOVE_WalkNormal,,MOVE_Sit);
    Goal_Set(1,GOAL_MoveTo,1,,'ComplaintOneFocus',,'ComplaintPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Action,2,,'PLAYER','PLAYER','ComplaintOneFocus','PrsoStNmDD0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Guard,1,,'ComplaintOneFocus','PLAYER','ComplaintPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_01', 1, , TRUE, 0);
    Goal_Set(2,GOAL_MoveTo,9,,,,'InChairPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,'ComplaintOneFocus',,'AnswerPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,0,,'ComplaintOneFocus',,'AnswerPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_02', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'ComplaintOneFocus','ComplaintOneFocus','ComplaintPoint','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_03', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,8,,'ComplaintOneFocus','ComplaintOneFocus','AnswerPoint','ReacStNmAA0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_04', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,8,,'ComplaintOneFocus','ComplaintOneFocus','ComplaintPoint','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_05', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,7,,'ComplaintOneFocus','ComplaintOneFocus','AnswerPoint','LookStNmLt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_06', 2, , TRUE, 0);
    Talk(Sound'S1_1_2Voice.Play_11_33_07', 1, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_Guard,1,,'ComplaintTwoFocus',,'SecondComp',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(4);
    Goal_Set(1,GOAL_Action,9,,'ComplaintTwoFocus','ComplaintTwoFocus','SecondComp','PrsoStNmAA0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(5);
    Goal_Default(2,GOAL_Guard,0,,'ComplaintTwoFocus',,'Guard2Point',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_08', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'ComplaintTwoFocus','ComplaintTwoFocus','SecondComp','LstnStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_09', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,'ComplaintTwoFocus','ComplaintTwoFocus','Guard2Point','ReacStNmAA0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_10', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,8,,'ComplaintTwoFocus','ComplaintTwoFocus','SecondComp','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_11', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,8,,'ComplaintTwoFocus','ComplaintTwoFocus','Guard2Point','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_12', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,7,,'ComplaintTwoFocus','ComplaintTwoFocus','SecondComp','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_13', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,7,,'ComplaintTwoFocus','ComplaintTwoFocus','Guard2Point','LstnStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_2Voice.Play_11_33_14', 2, , TRUE, 0);
    Close();
    ResetGoals(1);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,'None',,'InChairPoint',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Wait,0,,'None',,'AldoChair','ReadAsNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_Sit);
    Goal_Set(1,GOAL_MoveTo,8,,'ComplaintEndFocus','PLAYER','ComplaintFinalPos',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
SomeoneDead:
    Log("Sam has killed a member of this group.");
    CheckFlags(AlreadyCheckedHim,TRUE,'DoNothing');
    CheckIfIsDead(1,'CiviDead');
    End();
CiviDead:
    SetFlags(AlreadyCheckedHim,TRUE);
    SendPatternEvent('LambertAI','Murder');
    End();
Panic:
    Log("This is the behaviour for the civilian if everything goes to ratshit.");
    Goal_Default(1,GOAL_Guard,0,,,,'CivilPostAttackPoint',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

