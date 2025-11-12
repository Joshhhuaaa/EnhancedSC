//=============================================================================
// P_3_4_1Sev_4
//=============================================================================
class P_3_4_1Sev_4 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ManDown');
            break;
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
        if (P.name == 'spetsnaz3')
            Characters[1] = P.controller;
        if (P.name == 'EMercenaryTechnician1')
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
UPSChatGo:
    Log("Efrem tells Vasilii that the UPS cables are hooked up.");
    Goal_Default(1,GOAL_Guard,0,,'Vasilii',,'EfremUPSChat',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S3_4_2Voice.Play_34_14_01', 1, , TRUE, 0);
    Sleep(1);
    Goal_Set(2,GOAL_Guard,9,,'Efrem',,'VasyaFocusChat',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S3_4_2Voice.Play_34_14_02', 2, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_14_03', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_14_04', 2, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_14_05', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_14_06', 2, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_14_07', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_14_08', 2, , TRUE, 0);
    Close();
    AddNote("", "P_3_4_1Sev_4", "Note_0001L", "Localization\\P_3_4_2Severonickel");
    ResetGoals(2);
    Goal_Default(2,GOAL_Guard,0,,'VEndConsole',,'VasiliiEnd','WaitStNmFd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,0,,,,'Efrem_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'VasiliiEnd',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'WayPoint10Efrem',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'WayPoint20Efrem',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,7,,,,'WayPoint30Efrem',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,6,,,,'WayPoint40Efrem',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,5,,,,'WayPoint50Efrem',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,4,,,,'WayPoint60Efrem',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
ManDown:
    Log("Vasilii has been knocked out or killed");
    CheckIfIsDead(2,'VasDown');
    CheckIfIsUnconscious(2,'VasDown');
    End();
VasDown:
    Log("Vasilii is down, checking to see if its okay.");
    CheckFlags(V3_4_2Severonickel(Level.VarObject).OkToKOVasilii,TRUE,'ToLambert');
    SetProfileDeletion();
    GameOver(false, 0);
    End();
ToLambert:
    Log("It is okay to KO Vasilii, so Lambert has a plan.");
    SendPatternEvent('LambertAI','SatelliteMethod');
    End();
StartState:
    Log("This label comes from the Lambert pattern and changes Vasilli's initial goal");
    Goal_Set(2,GOAL_Wait,8,,'VStartConsole',,,'KbrdStNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
DoNothing:
    Log("Doing nothing");
    End();

}

defaultproperties
{
}
