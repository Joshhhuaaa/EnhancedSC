//=============================================================================
// P_3_4_4_Sev_LambertComms
//=============================================================================
class P_3_4_4_Sev_LambertComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FinalePlayed;
var int MoveEmOutPlayed;
var int ServerActive;


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
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    FinalePlayed=0;
    MoveEmOutPlayed=0;
    ServerActive=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("These are the comms received from Lambert in the level");
InitGoals:
    Log("Sams starting state.");
    AddGoal('COOPMASSE', "", 1, "", "P_3_4_4_Sev_LambertComms", "Goal_0023L", "Localization\\P_3_4_4Severonickel", "P_3_4_4_Sev_LambertComms", "Goal_0061L", "Localization\\P_3_4_4Severonickel");
    AddGoal('ALEKS', "", 10, "", "P_3_4_4_Sev_LambertComms", "Goal_0056L", "Localization\\P_3_4_4Severonickel", "P_3_4_4_Sev_LambertComms", "Goal_0062L", "Localization\\P_3_4_4Severonickel");
    SendPatternEvent('TerraHaute','LambertGrimOrders');
    End();
SabotageSAMs:
    Log("Lambert tells Sam he'll need to sabotage the SAM launchers");
    AddGoal('SAMS', "", 3, "", "P_3_4_4_Sev_LambertComms", "Goal_0055L", "Localization\\P_3_4_4Severonickel", "P_3_4_4_Sev_LambertComms", "Goal_0063L", "Localization\\P_3_4_4Severonickel");
    AddRecon(class 'EReconFullTextMissileDesc');
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0050L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_30_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0051L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_30_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0052L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_30_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0053L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_30_04', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0054L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_30_05', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SAMA:
    Log("One SAM has been sabotaged");
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0057L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_32_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SAMB:
    Log("Two SAM's have been sabotaged");
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0058L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_44_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SAMC:
    Log("All three SAM's have been sabotaged checking to see if the server is deactivated yet.");
    CheckFlags(V3_4_4Severonickel(Level.VarObject).ServerActive,TRUE,'ServerStillRemains');
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0059L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_67_02', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    SendPatternEvent('GrandFinale','IsOspreySafe');
    End();
SkippedSAM:
    Log("Sam has skipped a SAM, this label might get cut.");
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0069L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_68_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
ServerStillRemains:
    Log("Lambert reminds Sam to deal with the server.");
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0060L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_69_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
NearDisaster:
    Log("Algorithm Near Disaster");
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0006L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_54_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0007L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_54_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0008L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_54_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
AlgoSuccess:
    Log("Sam has deactivated the server");
    GoalCompleted('SERVER');
    SetFlags(V3_4_4Severonickel(Level.VarObject).ServerActive,FALSE);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0038L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_58_01', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0039L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_58_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0040L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_58_03', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0041L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_58_04', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0042L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_58_05', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Log("Checking to see if a SAM is active.");
    CheckFlags(V3_4_4Severonickel(Level.VarObject).OneSAMActive,TRUE,'GoBackForSAM');
    Jump('DontGoBack');
    End();
GoBackForSAM:
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0043L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_58_06', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
DontGoBack:
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0044L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_65_07', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('RENDEZVOUS', "", 4, "", "P_3_4_4_Sev_LambertComms", "Goal_0045L", "Localization\\P_3_4_4Severonickel", "P_3_4_4_Sev_LambertComms", "Goal_0064L", "Localization\\P_3_4_4Severonickel");
    Close();
    SendPatternEvent('GrandFinale','IsOspreySafe');
    End();
EitherWay:
    Log("Either way we still have to close the camera.");
    Close();
    End();
AlgoFail:
    Log("Sam failed to stop the algorithm from destroying Pickett Gap.");
    SetProfileDeletion();
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0070L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_56_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0020L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_56_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    GameOver(false, 0);
    End();
TimerFailed:
    Log("Sam failed to get to Masse in time. Game Over.");
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0048L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_62_01', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
Executed:
    Log("Sam killed Masse, game over.");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0025L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_62_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    GameOver(false, 0);
    End();
TimerWarning:
    Log("Masses timer has started.");
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0065L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_51_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0066L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_51_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_LambertComms", "Speech_0067L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_51_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
DoNothing:
    End();

}

defaultproperties
{
}
