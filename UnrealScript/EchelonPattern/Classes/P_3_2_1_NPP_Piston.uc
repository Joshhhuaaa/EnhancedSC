//=============================================================================
// P_3_2_1_NPP_Piston
//=============================================================================
class P_3_2_1_NPP_Piston extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CodeAcquired;
var int Foursies;
var int Once;
var int Thrice;
var int Twice;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('TechOut');
            break;
        case AI_UNCONSCIOUS:
            EventJump('TechOut');
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
        if (P.name == 'EMercenaryTechnician0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    CodeAcquired=0;
    Foursies=0;
    Once=0;
    Thrice=0;
    Twice=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Synch:
    Log("Activates the synch of the 2 dudes.");
    SendPatternEvent('PistonEmployee','Connecting');
    Teleport(1, 'CornerNode');
    Sleep(9);
    CinCamera(0, 'Focii2', 'Focus2',);
    Goal_Set(1,GOAL_MoveTo,9,,,,'DoorwaySynch2',,FALSE,,,,);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_MoveTo,8,,'GarthAlgar','GarthAlgar','DoorwaySynch2b',,FALSE,,,,);
    Goal_Set(1,GOAL_Stop,7,,'GarthAlgar','GarthAlgar',,,FALSE,0.1,,,);
    WaitForGoal(1,GOAL_Stop,);
    SendPatternEvent('PistonEmployee','s2');
    Goal_Set(1,GOAL_Wait,1,,'GarthAlgar','GarthAlgar',,,FALSE,,,,);
    End();
TechDiaOne:
    Goal_Set(1,GOAL_Action,9,,'GarthAlgar','GarthAlgar',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_24_02', 1, , FALSE, 0);
    Sleep(3);
    SendPatternEvent('PistonEmployee','EmpDiaOne');
    CinCamera(1, , ,);
    End();
TechDiaTwo:
    Goal_Set(1,GOAL_Action,9,,'GarthAlgar','GarthAlgar',,'ReacStNmAA0',FALSE,,,,);
    Talk(Sound'S3_2_1Voice.Play_32_24_04', 1, , FALSE, 0);
    Sleep(1.25);
    SendPatternEvent('PistonEmployee','EmpDiaTwo');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BythePistons',,FALSE,,,,);
    AddGoal('5', "", 2, "", "P_3_2_1_NPP_Piston", "Goal_0006L", "Localization\\P_3_2_1_PowerPlant", "P_3_2_1_NPP_Piston", "Goal_0023L", "Localization\\P_3_2_1_PowerPlant");
    Goal_Set(1,GOAL_MoveTo,8,,,,'CornerNode2',,FALSE,,,,);
    End();
Tag:
    Log("Ends sequence?");
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,7,,,,'MachineDestination',,FALSE,,,,);
    Goal_Default(1,GOAL_Stop,6,,'MachineFocus','MachineFocus','MachineDestination','kpadStNmNt0',FALSE,,,,);
    End();
TechOut:
    Log("The tech has been killed or knocked out, checking to see if he's spilled the info.");
    CheckFlags(CodeAcquired,TRUE,'Nada');
    SendPatternEvent('LambertAI','Screwed');
Nada:
    End();
CodeAcquired:
    Log("Sets the CodeAcquired flag to TRUE.");
    SetFlags(CodeAcquired,TRUE);
    End();

}

defaultproperties
{
}
