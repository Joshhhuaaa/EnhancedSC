//=============================================================================
// P_2_2_1_Ktech_DeadKeyTech
//=============================================================================
class P_2_2_1_Ktech_DeadKeyTech extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FirstPartAlreadyTriggered;
var int MafiosoOutDone;
var int SecondPartAlreadyTriggered;


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
        if (P.name == 'EMercenaryTechnician10')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle6')
            Characters[2] = P.controller;
        if (P.name == 'EMafiaMuscle7')
            Characters[3] = P.controller;
        if (P.name == 'EMafiaMuscle0')
        {
            Characters[4] = P.controller;
            EAIController(Characters[4]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    FirstPartAlreadyTriggered=0;
    MafiosoOutDone=0;
    SecondPartAlreadyTriggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
DeadKeyTechStart:
    Log("DeadKeyTechStart");
    CheckFlags(FirstPartAlreadyTriggered,TRUE,'AlreadyTriggered');
    SetFlags(FirstPartAlreadyTriggered,TRUE);
    SendUnrealEvent('KeyTechVolumeB');
    Teleport(2, 'DeadKeyTechTeleport02');
    Teleport(3, 'DeadKeyTechTeleport03');
    Goal_Set(2,GOAL_Guard,9,,'DeadKeyTechFocus01',,'DeadKeyTechTeleport02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(3,GOAL_Guard,9,,'DeadKeyTechFocus01',,'DeadKeyTechTeleport03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
DeadKeyTech:
    Log("DeadKeyTech");
    CheckFlags(SecondPartAlreadyTriggered,TRUE,'AlreadyTriggered');
    SetFlags(SecondPartAlreadyTriggered,TRUE);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S2_2_1Voice.Play_22_20_01', 2, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S2_2_1Voice.Play_22_20_02', 3, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_20_03', 2, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_20_04', 2, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_20_05', 3, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_20_06', 2, , TRUE, 0);
    Close();
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint',,'DeadKeyTechTeleport',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(1.5);
    Goal_Set(3,GOAL_MoveTo,9,,'EFocusPoint',,'DeadKeyTechTeleport',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(2,GOAL_MoveTo,);
    WaitForGoal(3,GOAL_MoveTo,);
    Teleport(2, 'DeadKeyTechTeleportA');
    Teleport(3, 'DeadKeyTechTeleportB');
    KillNPC(2, FALSE, FALSE);
    KillNPC(3, FALSE, FALSE);
    End();
MafiosoOut:
    Log("A mafioso comes out of the building to check the bridge");
    CheckFlags(MafiosoOutDone,TRUE,'AlreadyTriggered');
    SetFlags(MafiosoOutDone,TRUE);
    Goal_Default(4,GOAL_Patrol,9,,,,'Mafioso03_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
RappelingRain:
    Log("Triggers the rain when Sam break the glass when rappeling");
    SendUnrealEvent('RainDropA');
    SendUnrealEvent('RainDropB');
AlreadyTriggered:
    End();

}

