//=============================================================================
// P_3_4_3_Sev_TrainYard
//=============================================================================
class P_3_4_3_Sev_TrainYard extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Gun.uax

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
        if (P.name == 'EAzeriColonel0')
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
    Log("This is Alekseevich's pattern for the level.");
AleksDies:
    Log("Alekseevich finally gives in and blows hisself away.");
    CinCamera(0, 'Aleks01Cam', 'Aleks01Foc',);
    Goal_Default(1,GOAL_Guard,0,,,,'AleksEndPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,9,,'Aleks02Cam',,'AleksEndPoint',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    CinCamera(0, 'Aleks02Cam', 'Aleks01Foc',);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_4_3_Sev_TrainYard", "Speech_0001L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_60_01', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Close();
    Goal_Set(1,GOAL_Action,9,,'Aleks02Cam',,'Aleks02Cam','CiggStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(0.75);
    CinCamera(1, , ,);
    KillNPC(1, FALSE, FALSE);
	PlaySound(Sound'Gun.Play_M16ASingleShot', SLOT_SFX);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

defaultproperties
{
}
