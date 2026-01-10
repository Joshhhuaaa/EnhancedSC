//=============================================================================
// P_1_2_1DefMin_HamletIntel
//=============================================================================
class P_1_2_1DefMin_HamletIntel extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int First;
var int Last;
var int Second;


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
        if (P.name == 'EHamlet0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    First=0;
    Last=0;
    Second=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneHamletIntel");
    CheckIfGrabbed(1,'InterroStart');
    End();
InterroStart:
    Log("InterroStartHamletIntel");
    CheckFlags(First,TRUE,'InterroSecond');
    SetFlags(First,TRUE);
    Talk(Sound'S1_2_1Voice.Play_12_15_01', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_02', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_03', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_04', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_05', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_06', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_07', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_08', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_09', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_10', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_11', 1, , TRUE, 0);
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).InterroDone,TRUE);
    GoalCompleted('1_2_2');
    Talk(Sound'S1_2_1Voice.Play_12_15_12', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_13', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_14', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_15', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_16', 0, , TRUE, 0);
    Close();
    End();
InterroSecond:
    Log("InterroSecond");
    CheckFlags(Second,TRUE,'InterroLast');
    SetFlags(Second,TRUE);
    Talk(Sound'S1_2_1Voice.Play_12_15_17', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_18', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_19', 0, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_15_20', 1, , TRUE, 0);
    Close();
    End();
InterroLast:
    Log("InterroLast");
    JumpRandom('RandomBarkFinalOne', 0.50, 'RandomBarkFinalTwo', 1.00, , , , , ,);
    End();
RandomBarkFinalOne:
    Log("RandomOne");
    Talk(Sound'S1_2_1Voice.Play_12_15_21', 1, , TRUE, 0);
    Close();
    End();
RandomBarkFinalTwo:
    Log("RandomTwo");
    Talk(Sound'S1_2_1Voice.Play_12_15_22', 1, , TRUE, 0);
    Close();
End:
    End();

}

