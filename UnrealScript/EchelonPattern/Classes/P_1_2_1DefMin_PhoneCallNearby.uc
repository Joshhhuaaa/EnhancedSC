//=============================================================================
// P_1_2_1DefMin_PhoneCallNearby
//=============================================================================
class P_1_2_1DefMin_PhoneCallNearby extends EPattern;

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
        if (P.name == 'EGeorgianCop4')
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
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).LambertPostLaserSpoken,FALSE,'End');
    DisableMessages(TRUE, TRUE);
    Talk(Sound'S1_2_1Voice.Play_12_12_01', 1, , TRUE, 0);
    Close();
End:
    End();

}

