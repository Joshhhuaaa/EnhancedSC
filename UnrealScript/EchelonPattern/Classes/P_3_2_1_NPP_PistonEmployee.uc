//=============================================================================
// P_3_2_1_NPP_PistonEmployee
//=============================================================================
class P_3_2_1_NPP_PistonEmployee extends EPattern;

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
        if (P.name == 'EPowerPlantEmployee3')
            Characters[1] = P.controller;
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
Connecting:
    Log("Whoop whoop, whoop.");
    Teleport(1, 'yeeshnode');
    Goal_Set(1,GOAL_MoveTo,9,,,,'yeeshnode',,FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,8,,'WayneCampbell','WayneCampbell','DoorwaySynch1b',,FALSE,,,,);
    Goal_Default(1,GOAL_Wait,5,,'WayneCampbell','WayneCampbell',,,FALSE,,,,);
    End();
S2:
    Log("Synch2");
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,8,,'WayneCampbell','WayneCampbell','DoorwaySynch1b',,FALSE,,,,);
    Goal_Set(1,GOAL_Action,9,,'WayneCampbell','WayneCampbell',,'TalkStNmCC0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,9,,'WayneCampbell','WayneCampbell',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_24_01', 1, , FALSE, 0);
    Sleep(5);
    SendPatternEvent('PistonTech','TechDiaOne');
    End();
EmpDiaOne:
    Goal_Set(1,GOAL_Action,9,,'WayneCampbell','WayneCampbell',,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_24_03', 1, , FALSE, 0);
    Sleep(3.5);
    SendPatternEvent('PistonTech','TechDiaTwo');
    End();
EmpDiaTwo:
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'MrRoboto_0',,FALSE,,,,);
    Goal_Default(1,GOAL_Patrol,8,,,,'MrRoboto_0',,FALSE,,,,);
    SetExclusivity(FALSE);
    End();
Damage:
    Log("Power plant employee killed or messed with.");
    SendPatternEvent('LambertAI','EmployeeHurt');
    End();
Evacuate:
    Log("Beam out pattern 5.");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Teleport(1, 'TeleOut5');
    Goal_Set(1,GOAL_Wait,9,,,,,,FALSE,,,,);
    End();

}

defaultproperties
{
}
