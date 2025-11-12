//=============================================================================
// P_1_2_2DefMin_WilkesTalking
//=============================================================================
class P_1_2_2DefMin_WilkesTalking extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_2Voice.uax

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
        if (P.name == 'EWilkes0')
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
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).LastParkingGuyState,FALSE,'End');
    SendPatternEvent('OutroAI','TalkToMe');
    SendPatternEvent('NikoOfficeWow','NoPlayIntComm');
    Sleep(0.50);
    Talk(Sound'S1_2_2Voice.Play_12_60_01', 1, , TRUE, 0);
    Talk(Sound'S1_2_2Voice.Play_12_60_02', 0, , TRUE, 0);
    Talk(Sound'S1_2_2Voice.Play_12_60_03', 1, , TRUE, 0);
    Close();
    EndConversation();
    GameOver(true, 0);
End:
    End();

}

