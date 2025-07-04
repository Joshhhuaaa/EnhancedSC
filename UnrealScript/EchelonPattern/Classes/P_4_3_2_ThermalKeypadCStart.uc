//=============================================================================
// P_4_3_2_ThermalKeypadCStart
//=============================================================================
class P_4_3_2_ThermalKeypadCStart extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax

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

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'EAzeriColonel0')
            Characters[1] = P.controller;
        if(P.name == 'EFeirong0')
            Characters[2] = P.controller;
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
ThermalKeypadCStart:
    Log("ThermalKeypadCStart");
    Teleport(1, 'GoaTeleportIn');
    SendPatternEvent('ThermalKeypadCCheckFlags','LoopKeypad');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ThermalKeypadCNode01',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,,,'ThermalKeypadCNode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
ThermalKeypadCComm:
    Log("ThermalKeypadComm");
    Log("Everything between the two red comment tags has been added to fix bug 1174. If the bug is not fixed, contact Clint");
    SendUnrealEvent('GoaVolumes');
    Log("Everything between the two red comment tags has been added to fix bug 1174. If the bug is not fixed, contact Clint");
    Speech(Localize("P_4_3_2_ThermalKeypadCStart", "Speech_0002L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_41_01', 2, 0, TR_NPCS, 0, false);
    ResetGoals(1);
    Goal_Set(1,GOAL_Wait,9,,,,,'RdioStNmNt0',FALSE,,,,);
    Speech(Localize("P_4_3_2_ThermalKeypadCStart", "Speech_0003L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_41_02', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_4_3_2_ThermalKeypadCStart", "Speech_0001L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_41_03', 2, 0, TR_NPCS, 0, false);
    Close();
    ResetGoals(1);
    Goal_Default(1,GOAL_InteractWith,9,,,,'WarehouseElevatorButton',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

