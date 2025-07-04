//=============================================================================
// P_4_2_1_Abt_Studio
//=============================================================================
class P_4_2_1_Abt_Studio extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int OnBoard;


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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'spetsnaz4')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz7')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz0')
            Characters[3] = P.controller;
        if(P.name == 'spetsnaz2')
            Characters[4] = P.controller;
        if(P.name == 'EGeorgianSoldier35')
            Characters[5] = P.controller;
        if(P.name == 'spetsnaz10')
            Characters[6] = P.controller;
        if(P.name == 'spetsnaz3')
            Characters[7] = P.controller;
        if(P.name == 'EGeorgianSoldier38')
            Characters[8] = P.controller;
        if(P.name == 'EGeorgianSoldier37')
            Characters[9] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'StaticMeshActor294')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    OnBoard=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
NikoladzeOut:
    Log("Get Nikoladze out of here");
setup:
    Log("");
    SendPatternEvent('EGroupAI2','BeamOut');
start:
    Log("");
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.CineStartTrack1FadeOut', SLOT_Ambient);
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.CineStartTrack2FadeIn', SLOT_Ambient);
    Sleep(1);
    CinCamera(0, 'EFocusPoint83', 'EFocusPoint84',);
    ResetGoals(7);
    Goal_Set(7,GOAL_MoveTo,8,,,,'PathNode411',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(7,GOAL_Action,7,,'spetsnaz7',,,'TalkStNmAA0',FALSE,,,,);
    Goal_Default(7,GOAL_Wait,6,,'spetsnaz7',,,'LstnStNmBB0',FALSE,,,,);
    Sleep(2);
    CinCamera(0, 'EFocusPoint88', 'EFocusPoint85',);
    ResetGoals(2);
    Goal_Default(2,GOAL_Wait,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S4_2_1Voice.Play_42_10_01', 7, , TRUE, 0);
    ResetGoals(6);
    Goal_Set(6,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Goal_Set(6,GOAL_Action,8,,,,,'TalkStNmBB0',FALSE,,,,);
    CinCamera(0, 'EFocusPoint86', 'EFocusPoint87',);
    Talk(Sound'S4_2_1Voice.Play_42_10_02', 6, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,8,,,,,'TalkStNmBB0',FALSE,,,,);
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,,,,,FALSE,,,,);
    CinCamera(0, 'EFocusPoint81', 'EFocusPoint87',);
    Talk(Sound'S4_2_1Voice.Play_42_10_03', 2, , FALSE, 0);
    Sleep(1);
    Goal_Set(1,GOAL_Guard,8,,,,,'ReacStNmFd0',FALSE,,,,);
    Sleep(3);
    CinCamera(0, 'EFocusPoint88', 'EFocusPoint87',);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,8,,,,,'TalkStNmCC0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,7,,,,,'TalkStNmCC0',FALSE,,,,);
    Sleep(2);
    ResetGoals(7);
    Goal_Set(7,GOAL_MoveTo,9,,,,'PathNode422',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(7,GOAL_MoveTo,8,,,,'PathNode417',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(7,GOAL_MoveTo,7,,,,'PathNode421',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(7,GOAL_Wait,6,,,,'PathNode421',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(4);
    CinCamera(0, 'EFocusPoint83', 'EFocusPoint87',);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,'EFocusPoint84',,'PathNode416',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(4,GOAL_Wait,8,,'EFocusPoint84','PathNode416',,,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,'EFocusPoint84',,'PathNode395',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Wait,8,,'EFocusPoint84','PathNode395',,,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(6);
    Goal_Set(6,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S4_2_1Voice.Play_42_10_04', 6, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode408',,FALSE,,,,);
    Goal_Set(1,GOAL_Wait,8,,,,'PathNode408',,FALSE,,,,);
    Sleep(1);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PathNode399',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,8,,,,'PathNode402',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Wait,7,,,,'PathNode402',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode397',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode397',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,7,,,,'PathNode403',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'LookStNmLt0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,8,,,,,'PrsoStNmAA0',FALSE,,,,);
    Sleep(1);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,,,'PathNode401',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(4,GOAL_MoveTo,8,,,,'PathNode406',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(4,GOAL_Wait,7,,,,'PathNode406',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(0.5);
    ResetGoals(6);
    Goal_Set(6,GOAL_MoveTo,9,,'spetsnaz7',,'PathNode413',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(6,GOAL_Wait,8,,'spetsnaz7',,'spetsnaz7',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.CineStopTrack1FadeIn', SLOT_Ambient);
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.CineStopTrack2FadeOut', SLOT_Ambient);
    Sleep(0.5);
    CinCamera(1, , ,);
    SendPatternEvent('EGroupAI28','LambertAntenna');
    End();
NikOnboard:
    Log("We have Nikoladze onboard, estimated departure in");
    CheckFlags(OnBoard,TRUE,'JumpFin');
    Speech(Localize("P_4_2_1_Abt_Studio", "Speech_0006L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_10_05', 6, 0, TR_NPCS, 0, false);
    SetFlags(OnBoard,TRUE);
    Close();
setup2:
    Log("");
    ResetGroupGoals();
    Teleport(1, 'PathNode65');
    Goal_Default(1,GOAL_Wait,9,,,,'PathNode65',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(3, 'PathNode458');
    Goal_Default(3,GOAL_Wait,9,,,,'PathNode458',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(4, 'PathNode64');
    Goal_Default(4,GOAL_Wait,9,,,,'PathNode64',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(6, 'PathNode457');
    Goal_Default(6,GOAL_Wait,9,,'PathNode407',,'PathNode457',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(2, 'PathNode219');
    Goal_Default(2,GOAL_Wait,9,,,,'PathNode219',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(5, 'PathNode415');
    Goal_Default(5,GOAL_Wait,9,,,,'EFocusPoint87','RdioStNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(8, 'PathNode202');
    Goal_Default(8,GOAL_Wait,9,,'PathNode201',,,'LstnStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(9, 'PathNode201');
    Goal_Default(9,GOAL_Wait,9,,'PathNode202',,,'TalkStNmBB0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(7, 'PathNode220');
    Goal_Default(7,GOAL_Wait,9,,,,'PathNode220',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Close();
    End();
JumpFin:
    Log("");
    End();
NikHostage:
    Log("");
    Speech(Localize("P_4_2_1_Abt_Studio", "Speech_0016L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_10_06', 1, 0, TR_NPCS, 0, false);
    End();
GoGetHostage:
    Log("Grinko sent squad to get the hostage");
    Sleep(3);
    Speech(Localize("P_4_2_1_Abt_Studio", "Speech_0007L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_30_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_4_2_1_Abt_Studio", "Speech_0017L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_30_02', 8, 0, TR_NPCS, 0, false);
    Sleep(1.5);
    Close();
start2:
    Log("");
    ResetGoals(5);
    Goal_Set(5,GOAL_MoveTo,9,,,,'PathNode203',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(5,GOAL_Wait,7,,,,'PathNode201','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkAlert);
    WaitForGoal(5,GOAL_MoveTo,);
    ResetGoals(8);
    Goal_Default(8,GOAL_Wait,9,,,,'PathNode203',,FALSE,,,,);
    ResetGoals(9);
    Goal_Default(9,GOAL_Wait,9,,,,'PathNode203',,FALSE,,,,);
    Talk(Sound'S4_2_1Voice.Play_42_31_01', 5, , TRUE, 0);
    Sleep(2);
    ResetGoals(5);
    Goal_Default(5,GOAL_Wait,9,,,,'PathNode202',,FALSE,,,,);
    SendPatternEvent('EGroupAI28','StopSoldier');
    End();
BLAM2:
    GameOver(true, 0);
    End();
BeamOut:
    Log("");
    ResetGoals(5);
    Teleport(5, 'PathNode207');
    Goal_Default(5,GOAL_Wait,9,,,,'PathNode207',,FALSE,,,,);
    ResetGoals(8);
    Teleport(8, 'PathNode206');
    Goal_Default(8,GOAL_Wait,9,,,,'PathNode206',,FALSE,,,,);
    ResetGoals(9);
    Teleport(9, 'PathNode208');
    Goal_Default(9,GOAL_Wait,9,,,,'PathNode208',,FALSE,,,,);
    End();

}

