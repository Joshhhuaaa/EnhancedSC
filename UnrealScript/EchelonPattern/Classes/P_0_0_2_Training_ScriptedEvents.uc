//=============================================================================
// P_0_0_2_Training_ScriptedEvents
//=============================================================================
class P_0_0_2_Training_ScriptedEvents extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S0_0_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('GrimDown');
            break;
        case AI_GRABBED:
            EventJump('GrimDown');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GrimDown');
            break;
        case AI_UNCONSCIOUS:
            EventJump('GrimDown');
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
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'EAnna1')
            Characters[2] = P.controller;
        if(P.name == 'ESamNPC0')
            Characters[3] = P.controller;
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
    Log("This pattern controls all of the events between NPC Sam, Player Sam, Lambert and Grimsdottir.");
StartGame:
    Log("Lambert and Sam talk in a cutscene.");
    PlayerMove(false);
    Log("SetUp One. lambert appraoches from down the hall. Low Angle Wide");
    CinCamera(0, 'SetUpOneCam', 'SetUpOneFocus',);
    Goal_Default(1,GOAL_Guard,0,,,,'LambertStartA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
ThruDoor:
    Log("Lambert has opened the door.");
    Goal_Default(1,GOAL_Guard,0,,'ESamNPC',,'LambertStartA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,'SamStartB','SamStartB','LambertStartA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
    Log("SetUpTwo. Lambert enters room. Fisher Cam Right, Lambert Cam Left. CU facing Camera, OTS on Lambert.");
    CinCamera(0, 'SetUpTwoCam', 'SetUpTwoFoc',);
    Sleep(2);
    Goal_Set(1,GOAL_Action,8,,'SamStartA','SamStartA','LambertStartA','LookStNmUp0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_01', 1, , TRUE, 0);
    Goal_Default(1,GOAL_Guard,0,,'ESamNPC',,'LambertStartB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_02', 3, , TRUE, 0);
    Goal_Default(1,GOAL_Guard,0,,'ESamNPC',,'LambertStartB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Log("");
    CinCamera(0, 'SetUpFourCam', 'SetUpFourFoc',);
    Teleport(3, 'SamBlink');
    Goal_Default(3,GOAL_Guard,0,,'SamBFocus','SamBFocus','SamStartB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_03', 1, , TRUE, 0);
    Talk(Sound'S0_0_2Voice.Play_00_15_04', 3, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'SamStartB','SamStartB','LambertStartB','LstnStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_05', 1, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,'SamBFocus','SamBFocus',,'PrsoStAlBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_08', 3, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'SamStartB','SamStartB','LambertStartB','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'SamStartB','SamStartB','LambertStartB','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'SamStartB','SamStartB','LambertStartB','LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_09', 1, , TRUE, 0);
    Log("SetUp Five OTS from Lambert, Left to Sam, Right.");
    CinCamera(0, 'SetUpFiveCam', 'SetUpFiveFoc',);
    Talk(Sound'S0_0_2Voice.Play_00_15_10', 3, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'LambertCFocus','LambertCFocus','LambertStartB','LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'LambertCFocus','LambertCFocus',,'TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_11', 1, , TRUE, 0);
    Talk(Sound'S0_0_2Voice.Play_00_15_12', 3, , TRUE, 0);
    Log("SetUp Six. Lambert moves to head of table. Wider shot, Sam R, Lambert Left");
    CinCamera(0, 'SetUpSixCam', 'SetUpSixFoc',);
    Goal_Default(1,GOAL_Guard,0,,'LambertCFocus','LambertCFocus','LambertStartC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Guard,0,,'SamFinalFocus','SamFinalFocus','SamStartC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Action,9,,'SamBFocus','SamBFocus',,'PrsoStAlAA0',FALSE,0,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,8,,'SamFinalFocus','SamFinalFocus','SamStartC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_13', 1, , TRUE, 0);
    WaitForGoal(3,GOAL_MoveTo,);
    Log("SetUp Seven OTS from Lambert to Sam.");
    CinCamera(0, 'SetUpSevenCam', 'SetUpSevenFoc',);
    Talk(Sound'S0_0_2Voice.Play_00_15_14', 3, , TRUE, 0);
    Talk(Sound'S0_0_2Voice.Play_00_15_15', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,'LambertCFocus','LambertCFocus','LambertStartC','LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_16', 3, , TRUE, 0);
    Log("Using SetUp Nine OTS Sam, to Lambert");
    CinCamera(0, 'SetUpNineCam', 'SetUpNineFoc',);
    Goal_Set(1,GOAL_Action,9,,'LambertCFocus','LambertCFocus','LambertStartC','LookStNmUp0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'LambertCFocus','LambertCFocus','LambertStartC','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'LambertCFocus','LambertCFocus','LambertStartC','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_17', 1, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,'SamFinalFocus','SamFinalFocus',,'PrsoStAlBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_18', 3, , TRUE, 0);
    Log("SetUp Eight ECU on Lambert as he makes his point, then turns to exit.");
    CinCamera(0, 'SetUpEightCam', 'SetUpEightFoc',);
    Log("StartAnim 1");
    Goal_Set(1,GOAL_Action,9,,'LambertCFocus','LambertCFocus','LambertStartC','TalkStNmAA0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'LambertCFocus','LambertCFocus','LambertStartC','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'LambertCFocus','LambertCFocus','LambertStartC','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,6,,'LambertCFocus','LambertCFocus','LambertStartC','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_2Voice.Play_00_15_19', 1, , TRUE, 0);
    Goal_Default(1,GOAL_Guard,0,,'LambertStartB','LambertStartB','LambertStartB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Close();
    CinCamera(1, , ,);
    Teleport(0, 'PlayerEnter');
    SendPatternEvent('Communications','LookExp');
    End();
Grim:
    Log("Sam has gotten to the observation room and can chat with Grim.");
    Goal_Default(2,GOAL_Guard,0,,'ChattyFoc','ChattyFoc','GrimChat',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
GrimReturn:
    Log("");
    Goal_Default(2,GOAL_Guard,0,,'GrimFocus',,'GrimWait',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
GrimDown:
    Log("Grim has been killed or knocked out");
    SetProfileDeletion();
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Sleep(1);
    Speech(Localize("P_0_0_2_Training_ScriptedEvents", "Speech_0041L", "Localization\\P_0_0_2_Training"), Sound'S0_0_Voice.Play_00_17_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 0);
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

