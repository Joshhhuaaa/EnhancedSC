//=============================================================================
// P_1_1_1_Tbilisi_GrinkosMen
//=============================================================================
class P_1_1_1_Tbilisi_GrinkosMen extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_1Voice.uax

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
        if(P.name == 'EMafiaMuscle4')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle5')
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
    Log("This is the pattern for the mafiosos at Blausteins apartment.");
PhoneCall:
    Log("One of the mafiosos talks to Grinko on the phone.");
    Goal_Default(1,GOAL_Guard,0,,'KetevanLookOut',,'KetevanGuard',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,9,,'KetevanLookOut',,,'RdioStNmBg0',FALSE,,,,);
    Goal_Set(1,GOAL_Stop,8,,'KetevanLookOut',,,'RdioStNmNt0',FALSE,29,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_1Voice.Play_11_10_01', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Action,7,,'KetevanLookOut',,'KetevanGuard','RdioStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Close();
    End();
Entree:
    Log("Sam has reached the doors of Blausteins apartment. Starting interior mafioso pattern");
    Goal_Default(2,GOAL_Patrol,0,,,,'Makar_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,'Ketevan','Ketevan','MakarLooks',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
    CheckIfIsDead(1,'WhereDidHeGo');
    CheckIfIsUnconscious(1,'WhereDidHeGo');
    CheckIfGrabbed(1,'WhereDidHeGo');
    Goal_Set(2,GOAL_MoveTo,8,,'Ketevan','Ketevan','MakarChat',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Stop,7,,'Ketevan','Ketevan','MakarChat',,FALSE,16,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S1_1_1Voice.Play_11_15_01', 1, , TRUE, 0);
    Talk(Sound'S1_1_1Voice.Play_11_15_02', 2, , TRUE, 0);
    Talk(Sound'S1_1_1Voice.Play_11_15_03', 1, , TRUE, 0);
    Talk(Sound'S1_1_1Voice.Play_11_15_04', 2, , TRUE, 0);
    Talk(Sound'S1_1_1Voice.Play_11_15_05', 1, , TRUE, 0);
    ResetGroupGoals();
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
WhereDidHeGo:
    Log("Makar is suspicious because Ketevan is missing.");
    ChangeState(2,'s_investigate');
    Goal_Default(2,GOAL_Patrol,0,,,,'Makar_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Search,9,,,,'PathNode',,FALSE,0,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
MakarMedicine:
    Log("Makar searches the shelf");
    Goal_Set(2,GOAL_Action,9,,'MakMed','MakMed','Makar_1800','MineStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Wait,8,,'MakMed','MakMed','MakMed','MineStNmNt0',FALSE,8,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,7,,'MakMed','MakMed','Makar_1800','MineStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
MakarCupboard:
    Log("Makar searches the cupboards");
    Goal_Set(2,GOAL_Action,9,,'MakMicro','MakMicro','Makar_1100','MineCrNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_Wait,8,,'MakMicro','MakMicro','MakMicro','MineCrNmNt0',FALSE,8,MOVE_WalkNormal,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_Action,7,,'MakMicro','MakMicro','Makar_1100','MineCrNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_CrouchWalk);
    End();
MakarShelf:
    Log("Makar searches the medicine cabinet");
    Goal_Set(2,GOAL_Action,9,,'MakarSearch','MakarSearch','Makar_500','MineStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Wait,8,,'MakarSearch','MakarSearch','MakarSearch','MineStNmNt0',FALSE,8,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,7,,'MakarSearch','MakarSearch','Makar_500','MineStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

