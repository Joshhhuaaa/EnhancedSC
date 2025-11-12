//=============================================================================
// P_3_4_1_Sev_PhoneCall
//=============================================================================
class P_3_4_1_Sev_PhoneCall extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int PhonedOnce;


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
        if (P.name == 'spetsnaz0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    PhonedOnce=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
PhoneStart:
    Log("Fisher overhears the phonecall about the arrival of Alekseevich.");
    CheckFlags(PhonedOnce,TRUE,'DoNothing');
    SetFlags(PhonedOnce,TRUE);
    Goal_Set(1,GOAL_Action,9,,'NeilFocus',,'NeilFocus','RdioStNmBg0',FALSE,,,,);
    Goal_Default(1,GOAL_Wait,0,,'NeilFocus',,,'RdioStNmNt0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_20_01', 1, , TRUE, 0);
    Close();
    Goal_Set(1,GOAL_Action,9,,'NeilFocus',,'NeilFocus','RdioStNmEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Default(1,GOAL_Patrol,0,,,,'NeilAlphonso_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

defaultproperties
{
}
