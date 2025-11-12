//=============================================================================
// P_3_4_4_Sev_DoNotDisturb
//=============================================================================
class P_3_4_4_Sev_DoNotDisturb extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TriggeredAlready;


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
        if (P.name == 'spetsnaz23')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle8')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    TriggeredAlready=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is the pattern for the Mafioso who wishes to see Alekseevich.");
OnisimGo:
    Log("Onisim starts heading toward the spetznas");
    CheckFlags(TriggeredAlready,TRUE,'DoNothing');
    SetFlags(TriggeredAlready,TRUE);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Permission',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
    Talk(Sound'S3_4_3Voice.Play_34_59_01', 2, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_59_02', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_59_03', 2, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_59_04', 1, , TRUE, 0);
    Sleep(0.1);
    Goal_Default(2,GOAL_Patrol,0,,,,'Onisim_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

defaultproperties
{
}
