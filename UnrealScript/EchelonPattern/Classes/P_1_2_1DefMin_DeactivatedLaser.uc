//=============================================================================
// P_1_2_1DefMin_DeactivatedLaser
//=============================================================================
class P_1_2_1DefMin_DeactivatedLaser extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

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
Milestone:
    Log("Milestone");
    GoalCompleted('1_2_9');
    SendUnrealEvent('EIRSensorFirstVanish');
    SendUnrealEvent('StupidSideColli');
    SendUnrealEvent('DieRemove');
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).LaserDown,TRUE);
    SendPatternEvent('Colonel','Milestone');
    Sleep(3);
    Speech(Localize("P_1_2_1DefMin_DeactivatedLaser", "Speech_0002L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_25_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_DeactivatedLaser", "Speech_0003L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_25_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_DeactivatedLaser", "Speech_0004L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_25_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
LamTalkOff:
    Log("LamTalkOff");
    Close();
End:
    End();

}

