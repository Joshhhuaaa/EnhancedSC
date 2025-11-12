//=============================================================================
// P_3_2_2_NPP_InventoryGuards
//=============================================================================
class P_3_2_2_NPP_InventoryGuards extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_2Voice.uax

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
        if (P.name == 'EFalseRussianSoldier5')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier6')
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
StartConvo:
    Log("Sam has tripped the Inventory trigger, start the guard dialog and pattern.");
    Teleport(1, 'TurretTele2');
    Teleport(2, 'TurretTele25');
    Goal_Set(1,GOAL_MoveTo,9,,'Olly','Olly','ChillPoint2',,FALSE,,,,);
    Goal_Set(2,GOAL_Stop,9,,'Sifl','Sifl',,,FALSE,1,,,);
    Goal_Set(2,GOAL_MoveTo,8,,'Sifl','Sifl','ChillPoint1',,FALSE,,,,);
    Goal_Default(1,GOAL_Stop,6,,'Olly','Olly',,,FALSE,2,,,);
    Goal_Set(2,GOAL_Stop,6,,'Sifl','Sifl',,,FALSE,2,,,);
    Speech(Localize("P_3_2_2_NPP_InventoryGuards", "Speech_0001L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_34_01', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_2_NPP_InventoryGuards", "Speech_0002L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_34_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_2_NPP_InventoryGuards", "Speech_0003L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_34_03', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_2_NPP_InventoryGuards", "Speech_0004L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_34_04', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_2_NPP_InventoryGuards", "Speech_0005L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_34_05', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_2_2_NPP_InventoryGuards", "Speech_0006L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_34_06', 2, 0, TR_CONVERSATION, 0, false);
    Sleep(2.5);
    Close();
    Goal_Set(2,GOAL_Action,7,,'Sifl','Sifl',,'ReacStNmAA0',FALSE,,,,);
    WaitForGoal(2,GOAL_Action,);
    Goal_Default(1,GOAL_Patrol,5,,,,'Sifl_0',,FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,6,,,,'Olly_600',,FALSE,,,,);
    Goal_Default(2,GOAL_Patrol,5,,,,'Olly_600',,FALSE,,,,);
    End();

}

defaultproperties
{
}
