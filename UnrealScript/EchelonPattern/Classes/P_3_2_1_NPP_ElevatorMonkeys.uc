//=============================================================================
// P_3_2_1_NPP_ElevatorMonkeys
//=============================================================================
class P_3_2_1_NPP_ElevatorMonkeys extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Damage');
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
        if (P.name == 'EPowerPlantEmployee0')
            Characters[1] = P.controller;
        if (P.name == 'EPowerPlantEmployee1')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Perch:
    Log("Sam is on top of the elevator.");
    SendUnrealEvent('TopDoor');
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,9,,'Billy','Billy','InElevatorTop1',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,9,,'Bubba','Bubba','InElevatorTop2',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Wait,8,,'Billy','Billy',,,FALSE,,,,);
    Goal_Set(2,GOAL_Wait,8,,'Bubba','Bubba',,,FALSE,,,,);
    Goal_Set(1,GOAL_Action,9,,'Billy','Billy',,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_01', 1, , TRUE, 0);
    Sleep(0.1);
    Goal_Set(2,GOAL_Action,9,,'Bubba','Bubba',,'ReacStNmAA0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_02', 2, , TRUE, 0);
    Sleep(0.1);
    Goal_Set(1,GOAL_Action,9,,'Billy','Billy',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_03', 1, , TRUE, 0);
    Sleep(0.1);
    Goal_Set(2,GOAL_Action,9,,'Bubba','Bubba',,'TalkStNmDD0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_04', 2, , TRUE, 0);
    Sleep(0.1);
    Goal_Set(1,GOAL_Action,9,,'Billy','Billy',,'ReacStNmAA0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_05', 1, , TRUE, 0);
    Sleep(0.1);
    Goal_Set(2,GOAL_Action,9,,'Bubba','Bubba',,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_06', 2, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
GoingDown:
    Log("The elevator has reached the bottom floor.");
    Sleep(1.5);
    SendUnrealEvent('BottomDoor');
    Sleep(1.5);
    ResetGroupGoals();
    Goal_Set(2,GOAL_MoveTo,9,,'Billy','Billy','LobbyNode2',,FALSE,,,,);
    Goal_Set(2,GOAL_Wait,8,,'Billy','Billy',,,FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,9,,'Bubba','Bubba','LobbyMidwayNode',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_MoveTo,8,,'Bubba','Bubba','LobbyNode1',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,);
Synched:
    Log("Power plant employees are synched.");
    ResetGroupGoals();
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,'Billy','Billy','BathroomNode1',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,9,,'Bubba','Bubba','BathroomNode2',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Stop,8,,'Billy','Billy',,,FALSE,6,,,);
    Goal_Set(2,GOAL_Stop,8,,'Bubba','Bubba',,,FALSE,6,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_07', 2, , TRUE, 0);
    Sleep(0.1);
    Goal_Set(1,GOAL_Action,9,,'Bubba','Bubba',,'ReacStNmAA0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_21_08', 1, , TRUE, 0);
    Sleep(2);
    Close();
    Goal_Default(1,GOAL_MoveTo,7,,,,'TeleportOutNode',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,7,,'THEUrinal','THEUrinal','Pissnode',,FALSE,,,,);
    Goal_Set(2,GOAL_Stop,6,,'THEUrinal','THEUrinal',,,FALSE,69,,,);
    Goal_Set(2,GOAL_Wait,5,,,,'SinkNode',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(2);
    Goal_Default(1,GOAL_Guard,6,,,,'TeleportOutNode',,FALSE,3,,,);
    End();
Evacuate:
    Log("Two elevator monkeys to beam up.");
    Teleport(1, 'TeleOut15');
    Teleport(2, 'TeleOut16');
    ResetGroupGoals();
    Goal_Set(1,GOAL_Wait,9,,,,,,FALSE,,,,);
    Goal_Set(2,GOAL_Wait,9,,,,,,FALSE,,,,);
    End();
Damage:
    Log("Power plant employee killed or messed with.");
    SendPatternEvent('LambertAI','EmployeeHurt');
    End();

}

defaultproperties
{
}
