//=============================================================================
// P_0_0_3_Training_ScriptedEvents
//=============================================================================
class P_0_0_3_Training_ScriptedEvents extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
        if (P.name == 'EWilkes0')
            Characters[2] = P.controller;
        if (P.name == 'ESamNPC1')
            Characters[3] = P.controller;
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
    Log("This pattern controls the scripted events between Lambert, Wilkes and NPC Sam.");
FinaleStart:
    Log("Setting finale characters to their start points");
    Teleport(0, 'SamOut');
    Log("Sam enters the room. SetUp 1");
    CinCamera(0, 'Finale01Cam', 'Finale01Foc',);
    PlayerMove(false);
    Teleport(1, 'LambertINFinal');
    Teleport(2, 'WilkesINFinal');
    Teleport(3, 'SamINFinal');
    Sleep(0.1);
    SendUnrealEvent('FinaleDoor');
    Goal_Default(1,GOAL_Guard,0,,'LambertFocus','LambertFocus','LambertChatFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,0,,'WilkesFocus','WilkesFocus','WilkesChatFinal','waitstnmfd0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(3,GOAL_Guard,0,,'SamFocus','SamFocus','SamChatFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,'WilkesFocus','WilkesFocus','SamFocus',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_Action,9,,'WilkesFocus','WilkesFocus','SamFocus','LookStNmFd0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Log("Sam OTS as Lambert and Wilkes enter. SetUp 2.");
    CinCamera(0, 'Finale02Cam', 'Finale02Foc',);
    Talk(Sound'S0_0_3Voice.Play_00_30_01', 2, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,'SamFocus','SamFocus','SamChatFinal','PrsoStAlAA0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Stop,9,,'LambertFocus','LambertFocus','LambertChatFinal',,FALSE,1.5,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'LambertFocus','LambertFocus','LambertChatFinal','LstnStNmCC0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S0_0_3Voice.Play_00_30_02', 1, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_30_03', 3, , TRUE, 0);
    Log("Wilkes and Fisher shake hands SetUp 3");
    CinCamera(0, 'Finale03Cam', 'Finale03Foc',);
    Goal_Set(2,GOAL_Action,8,,'WilkesFocus','WilkesFocus','WilkesChatFinal','TalkStNmCC0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S0_0_3Voice.Play_00_30_04', 2, , TRUE, 0);
    Goal_Set(2,GOAL_Action,7,,'WilkesFocus','WilkesFocus','WilkesChatFinal','LookStNmLt0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,9,,'LambertFocus','LambertFocus','LambertChatFinal','TalkStNmBB0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S0_0_3Voice.Play_00_30_05', 1, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_30_06', 3, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'WilkesFocus','WilkesFocus','WilkesChatFinal','LookStNmUp0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S0_0_3Voice.Play_00_30_07', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,8,,'LambertFocus','LambertFocus','LambertChatFinal','LookStNmRt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'LambertFocus','LambertFocus','LambertChatFinal','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_3Voice.Play_00_30_08', 1, , TRUE, 0);
    Log("Back to setUp2");
    CinCamera(0, 'Finale02Cam', 'Finale02Foc',);
    Goal_Set(1,GOAL_Action,6,,'LambertFocus','LambertFocus','LambertChatFinal','LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_3Voice.Play_00_30_09', 3, , TRUE, 0);
    Goal_Set(2,GOAL_Action,5,,'WilkesFocus','WilkesFocus','WilkesChatFinal','LstnStNmCC0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S0_0_3Voice.Play_00_30_10', 2, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,'SamFocus','SamFocus','SamChatFinal','PrsoStAlBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkRelaxed);
    Talk(Sound'S0_0_3Voice.Play_00_30_11', 3, , TRUE, 0);
    Goal_Set(1,GOAL_Action,5,,'LambertFocus','LambertFocus','LambertChatFinal','LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,4,,'WilkesFocus','WilkesFocus','WilkesChatFinal','waitstnmfd0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Action,3,,'WilkesFocus','WilkesFocus','WilkesChatFinal','PrsoStNmEE0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_3Voice.Play_00_30_12', 2, , TRUE, 0);
    Log("Back to Set Up 3");
    CinCamera(0, 'Finale03Cam', 'Finale03Foc',);
    Goal_Set(1,GOAL_Action,4,,'LambertFocus','LambertFocus','LambertChatFinal','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,3,,'LambertFocus','LambertFocus','LambertChatFinal','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'WilkesFocus','WilkesFocus','WilkesChatFinal','LookStNmLt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,8,,'WilkesFocus','WilkesFocus','WilkesChatFinal','PrsoStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,7,,'WilkesFocus','WilkesFocus','WilkesChatFinal','LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Action,6,,'WilkesFocus','WilkesFocus','WilkesChatFinal','LstnStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_3Voice.Play_00_30_13', 1, , TRUE, 0);
    Talk(Sound'S0_0_3Voice.Play_00_30_14', 3, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'LambertFocus','LambertFocus','LambertChatFinal','LstnStNmCC0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,8,,'LambertFocus','LambertFocus','LambertChatFinal','TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'LambertFocus','LambertFocus','LambertChatFinal','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S0_0_3Voice.Play_00_30_15', 1, , TRUE, 0);
    GameOver(true, 0);
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

