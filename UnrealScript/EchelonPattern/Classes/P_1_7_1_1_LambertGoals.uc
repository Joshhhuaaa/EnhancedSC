//=============================================================================
// P_1_7_1_1_LambertGoals
//=============================================================================
class P_1_7_1_1_LambertGoals extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S3_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int SurfacedDone;


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
    local EGameplayObject EGO;
    local ECamera XboxCamera;
    local Rotator RealNeutralRot;
    local EAlarm Alarm;
    local EAlarmLight AlarmLight;

    Super.InitPattern();

    // Joshua - Adding the camera that is missing in the PC version
    if (!bInit)
    {
        XboxCamera = Spawn(class'ECamera', , , vect(7424, -7198.5, 204), rot(0, 49152, 0)); // Y = -7192.5 / DrawScale = 1.0
        XboxCamera.SetDrawScale(1.25f);
        XboxCamera.AmbientPlaySound = Sound'Electronic.Play_CameraScan';
        XboxCamera.AmbientStopSound = Sound'Electronic.Stop_CameraScan';
        XboxCamera.PatrolAngle = 60;
        XboxCamera.PatrolSpeed = 3;
        XboxCamera.VisibilityMaxDistance = 500.0;
        XboxCamera.TriggerPatternJustOnce = false;
        XboxCamera.NeutralRotation.PitchDegreeModifier = -25;
        XboxCamera.NeutralRotation.YawDegreeModifier = 0;
        XboxCamera.NeutralRotation.RollDegreeModifier = 0;

        // Apply NeutralRotation modifier
        if (XboxCamera.NeutralRotation.PitchDegreeModifier != 0)
            RealNeutralRot.Pitch = 65535 / (360 / float(XboxCamera.NeutralRotation.PitchDegreeModifier));

        if (XboxCamera.NeutralRotation.YawDegreeModifier != 0)
            RealNeutralRot.Yaw = 65535 / (360 / float(XboxCamera.NeutralRotation.YawDegreeModifier));

        if (XboxCamera.NeutralRotation.RollDegreeModifier != 0)
            RealNeutralRot.Roll = 65535 / (360 / float(XboxCamera.NeutralRotation.RollDegreeModifier));

        // Keep starting rotation
        XboxCamera.InitialRotation = XboxCamera.Rotation + RealNeutralRot;
        XboxCamera.CurrentRotation = XboxCamera.InitialRotation;

        // Place head at neutral rotation
        XboxCamera.SetSensorRotation(XboxCamera.InitialRotation);

        // Rotation from "sec for a turn" into 65535 base
        if (XboxCamera.PatrolSpeed != 0)
        {
            XboxCamera.RealRotationSpeed = 65535 / XboxCamera.PatrolSpeed;
        }

        // Angle from degree to 65535 base
        if (XboxCamera.PatrolAngle != 0)
        {
            XboxCamera.RealPatrolAngle = 65535 / (360 / float(XboxCamera.PatrolAngle));
        }

        // Adding a new Alarm light as the Cafeteria camera has none assigned
        AlarmLight = Spawn(class'EAlarmLight', , , vect(9694, -3696.6, -634.5), rot(0, 0, 0));
        AlarmLight.SetDrawScale(0.70f);

        ForEach AllActors(class'EAlarm', Alarm)
        {
            if (Alarm.name == 'EAlarm0')
            {
                Alarm.AlarmObjects[0] = AlarmLight;
                AlarmLight.Alarm = Alarm;
            }
        }

        ForEach DynamicActors(class'EGameplayObject', EGO)
        {
            if (EGO.name == 'ECeilingCamera1')
            {
                XboxCamera.Alarm = EGO.Alarm;
                XboxCamera.GroupAI = EGO.GroupAI;
                XboxCamera.JumpLabel = EGO.JumpLabel;
            }
        }
    }

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    SurfacedDone=0;
    }

}

// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneLambertGoals:
    Log("MilestoneLambertGoals");
    IgnoreAlarmStage(FALSE); // Joshua - Enhanced change: Enabling alarm stages for Vselka
    Sleep(1);
    SendUnrealEvent('ControlRoomDoors');
    AddGoal('BOB', "", 10, "", "P_1_7_1_1_LambertGoals", "Goal_0001L", "Localization\\P_1_7_1_1VselkaInfiltration", "P_1_7_1_1_LambertGoals", "Goal_0002L", "Localization\\P_1_7_1_1VselkaInfiltration");
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0003L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_05_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0004L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_05_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0005L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_05_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(4.5);
    SendUnrealEvent('SubWareDoors');
    End();
SubmarineInfiltrateLambertGoals:
    Log("SubmarineInfiltrateLambertGoals");
    SendUnrealEvent('SaveOne');
    GoalCompleted('BOB');
    AddGoal('SUB', "", 9, "", "P_1_7_1_1_LambertGoals", "Goal_0006L", "Localization\\P_1_7_1_1VselkaInfiltration", "P_1_7_1_1_LambertGoals", "Goal_0007L", "Localization\\P_1_7_1_1VselkaInfiltration");
    Sleep(1.5);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0008L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_34_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0009L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_34_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0010L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_34_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(12);
    AddGoal('CONTROL', "", 8, "", "P_1_7_1_1_LambertGoals", "Goal_0011L", "Localization\\P_1_7_1_1VselkaInfiltration", "P_1_7_1_1_LambertGoals", "Goal_0012L", "Localization\\P_1_7_1_1VselkaInfiltration");
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0013L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_25_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0030L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_2Voice.Play_31_41_04', 0, 0, TR_CONVERSATION, 0, false);
    Close();
    SendUnrealEvent('GPSvol');
    SendUnrealEvent('DecompressorBlock');
    End();
PreSurfacedLambertGoals:
    Log("PreSurfacedLambertGoals");
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0014L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_38_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0015L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_38_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0016L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_38_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
SurfacedLambertGoals:
    Log("SurfacedLambertGoals");
    CheckFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).BobDone,FALSE,'End');
    CheckFlags(SurfacedDone,TRUE,'End');
    SetFlags(SurfacedDone,TRUE);
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    SendUnrealEvent('UpstairsTrigger');
    SendUnrealEvent('LastGameVol');
    SendPatternEvent('WindowLone','TelWindowLone');
    SendPatternEvent('IntroDocks','TelDocksIntro');
    SendPatternEvent('walking','TelWalking');
    SendPatternEvent('Downstairs','TelDownstairs');
    SendPatternEvent('Follow','TelFollow');
    SendPatternEvent('Captain','TelCaptain');
    SendPatternEvent('Dormitory','TelDormitory');
    SendPatternEvent('HellsKitchen','TelHellsKitchen');
    SendPatternEvent('NVCRoom','CSNVCRoom');
    SendUnrealEvent('DisableFirst');
    CinCamera(0, 'CScamPos', 'CScamFoc',);
    Sleep(10);
    CinCamera(1, , ,);
    SendPatternEvent('NVCRoom','MilestoneNVCRoom');
    GoalCompleted('CONTROL');
    DisableMessages(FALSE, FALSE);
    Sleep(0.75);
    SendUnrealEvent('SaveTwo');
    Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0017L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S3_1_1Voice.Play_31_32_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
CompleteLambertGoals:
    Log("CompleteLambertGoals");
    Close();
    PlayerMove(false);
    //Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0031L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S4_3_2Voice.Play_43_50_01', 1, 0, TR_HEADQUARTER, 0, true);
    //Speech(Localize("P_1_7_1_1_LambertGoals", "Speech_0032L", "Localization\\P_1_7_1_1VselkaInfiltration"), Sound'S4_3_2Voice.Play_43_55_04', 0, 0, TR_NPCS, 0, true);
    Close();
    GoalCompleted('SUB');
    LevelChange("1_7_1_2Vselka");
    End();
End:
    End();

}

defaultproperties
{
}
