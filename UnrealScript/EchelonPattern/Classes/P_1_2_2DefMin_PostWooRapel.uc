//=============================================================================
// P_1_2_2DefMin_PostWooRapel
//=============================================================================
class P_1_2_2DefMin_PostWooRapel extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int WentTrough;


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
        if (P.name == 'EGeorgianSoldier2')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier1')
            Characters[2] = P.controller;
        if (P.name == 'EGrinko0')
            Characters[3] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    WentTrough=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ToGun:
    Log("ToGun");
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).AlarmSentByWindow,TRUE,'End');
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).AlarmSentByWindow,TRUE);
    SendPatternEvent('SecondPossibleAlarm','AlarmEndLevel');
    SendPatternEvent('ThirdPossibleAlarm','AlarmEndLevel');
    Goal_Default(2,GOAL_Patrol,9,,,,'WindowPanicA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
GrinkoCallParking:
    Log("GrinkoCallParking");
    Speech(Localize("P_1_2_2DefMin_PostWooRapel", "Speech_0005L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_59_01', 3, 0, TR_NPCS, 0, false);
    Speech(Localize("P_1_2_2DefMin_PostWooRapel", "Speech_0006L", "Localization\\P_1_2_2DefenseMinistry"), Sound'S1_2_2Voice.Play_12_59_02', 3, 0, TR_NPCS, 0, false);
    Close();
    End();
NoPlayIntComm:
    Log("NoPlayIntComm");
    Close();
End:
    End();

}

