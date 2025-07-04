//=============================================================================
// P_2_2_2_Ktech_Communications
//=============================================================================
class P_2_2_2_Ktech_Communications extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_2Voice.uax

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
    local ETimer Timer; // Joshua - Adjusting timer for Elite mode

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'ECIABureaucratF0')
            Characters[2] = P.controller;
    }

    // Joshua - Adjusting timer for Elite mode
    if(IsEliteMode())
    {
        ForEach AllActors(class'ETimer', Timer)
        {
            if(Timer.Name == 'ETimer0')
                Timer.TimerDelay = 100.0; // 150.0
        }
    }

    // Joshua - Replace NPC skins for variety
    if (!bInit)
    {
        ForEach DynamicActors(class'Pawn', P)
        {
            if(P.name == 'EMafiaMuscle5' || P.name == 'EMafiaMuscle11' || P.name =='EMafiaMuscle13')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Grunt.GruntA", class'Texture'));
            }
            if(P.name == 'EMafiaMuscle8' || P.name == 'EMafiaMuscle12' || P.name == 'EMafiaMuscle17')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Grunt.GruntB", class'Texture'));
            }
            if(P.name == 'EMercenaryTechnician7')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.MercTech.MercTechB", class'Texture'));
            }
        }
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
HostagesRescue:
    Log("Communicator 22_25  'Hostages'");
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0001L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_25_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0020L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_25_02', 2, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0019L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_25_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0024L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_25_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0025L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_25_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
HostageKilled:
    Log("Communicator 22_28 'Dead Hostage Failure'");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0046L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_28_01', 1, 0, TR_HEADQUARTER, 0, true);
    GameOver(false, 0);
    End();
DefuseBomb:
    Log("Communicator 22_29 'Storage room Bomb'");
    Sleep(2);
    AddGoal('DefuseBomb', "", 3, "", "P_2_2_2_Ktech_Communications", "Goal_0033L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_Communications", "Goal_0061L", "Localization\\P_2_2_2_Kalinatek");
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0034L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_29_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0035L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_29_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0036L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_29_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    SendUnrealEvent('3rdFloorTimer');
    SendUnrealEvent('TimeBomb');
    End();
DefuseBombDone:
    Log("Communicator 22_22 'Fire door breaker'");
    SetFlags(V2_2_2_Kalinatek(Level.VarObject).DefuseBombDone,TRUE);
    SendUnrealEvent('3rdFloorTimer');
    SendUnrealEvent('TimeBombSaveGame');
    Sleep(2);
    Sleep(2);
    GoalCompleted('DefuseBomb');
    AddGoal('FuseBox', "", 4, "", "P_2_2_2_Ktech_Communications", "Goal_0041L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_Communications", "Goal_0062L", "Localization\\P_2_2_2_Kalinatek");
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0042L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_22_01', 1, 0, TR_HEADQUARTER, 0, false);
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).FuseBoxDone,TRUE,'FuseBoxAlreadyDone');
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0039L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_22_02', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0040L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_22_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
FuseBoxAlreadyDone:
    Log("FuseBoxAlreadyDone");
    Close();
    AddGoal('FuseBox', "", 4, "", "P_2_2_2_Ktech_Communications", "Goal_0065L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_Communications", "Goal_0066L", "Localization\\P_2_2_2_Kalinatek");
    GoalCompleted('FuseBox');
    End();
DefuseBombFailed:
    Log("Communicator 22_32 'Time Up'");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    ShakeCamera(200, 55000, 50);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0037L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_32_01', 1, 0, TR_HEADQUARTER, 0, true);
    GameOver(false, 0);
    End();
BombExploded:
    Log("If Sam shoots the bomb, game over");
    SetProfileDeletion();
    PlayerMove(false);
    Sleep(1);
    GameOver(false, 0);
    End();
FireDoorOpen:
    Log("Communicator 22_35 'Fire Doors Down'");
    GoalCompleted('FireAlarm');
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0007L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_35_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
LeaveIvan:
    Log("Communicator 22_40 'Leave Ivan'");
    AddGoal('LeaveIvan', "", 10, "", "P_2_2_2_Ktech_Communications", "Goal_0054L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_Communications", "Goal_0063L", "Localization\\P_2_2_2_Kalinatek");
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0047L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_40_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0048L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_40_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0049L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_40_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
IvanSuccess:
    Log("When you get the encryption key");
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).DefuseBombDone,FALSE,'BombNotDefused');
    SendUnrealEvent('ElevatorPowerON');
BombNotDefused:
    Log("BombNotDefused");
    Sleep(2);
    GoalCompleted('FindIvan');
    AddGoal('ClearTheRoof', "", 7, "", "P_2_2_2_Ktech_Communications", "Goal_0050L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_Communications", "Goal_0064L", "Localization\\P_2_2_2_Kalinatek");
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0051L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_55_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0052L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_55_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0053L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_55_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
IvanIsDead:
    Log("Communicator 22_52 'Dead Ivan Failure'");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0043L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_52_01', 1, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0044L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_52_02', 0, 0, TR_HEADQUARTER, 0, true);
    Speech(Localize("P_2_2_2_Ktech_Communications", "Speech_0045L", "Localization\\P_2_2_2_Kalinatek"), Sound'S2_2_2Voice.Play_22_52_03', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
LevelChange:
    Log("LevelChange");
    GoalCompleted('LeaveIvan');
    GoalCompleted('HostagesAlive');
    LevelChange("2_2_3_Kalinatek.unr");
    End();
DisableEverything:
    Log("DisableEverything");
    DisableMessages(TRUE, TRUE);
    End();

}

