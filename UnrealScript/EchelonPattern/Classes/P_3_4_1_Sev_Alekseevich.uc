//=============================================================================
// P_3_4_1_Sev_Alekseevich
//=============================================================================
class P_3_4_1_Sev_Alekseevich extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('AlexCheck');
            break;
        case AI_UNCONSCIOUS:
            EventJump('AlexCheck');
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
        if(P.name == 'EAzeriColonel0')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz22')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz23')
            Characters[3] = P.controller;
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
ColonelArrival:
    Log("Colonel Alekseevich arrives by Unimog in the garage.");
    SendUnrealEvent('AlexMog');
    SendUnrealEvent('AlexGate');
    Sleep(2);
    CinCamera(0, 'AlexScA01Cam', 'AlexScA01Foc',);
    Sleep(5);
    SendUnrealEvent('AlexGate');
    CinCamera(0, 'AlexScA02Cam', 'AlexScA02Foc',);
    Sleep(0.5);
    Teleport(1, 'AlexScAIn');
    Teleport(2, 'AdamScAIn');
    Teleport(3, 'BorisScAIn');
    Goal_Default(1,GOAL_Guard,0,,'AlexScA03Foc',,'AlexScAComplain',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,0,,'AlexScAComplain',,'AdamScAListen',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Guard,0,,'AlexScAComplain',,'BorisScAListen',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    CinCamera(0, 'AlexScA03Cam', 'AlexScA03Foc',);
    Speech(Localize("P_3_4_1_Sev_Alekseevich", "Speech_0004L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_24_01', 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_Alekseevich", "Speech_0005L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_24_02', 2, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_Alekseevich", "Speech_0006L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_24_03', 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_Alekseevich", "Speech_0007L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_24_04', 2, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_Alekseevich", "Speech_0008L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_24_05', 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_Alekseevich", "Speech_0009L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_24_06', 2, 0, TR_CONVERSATION, 0, false);
    Close();
    Goal_Set(1,GOAL_MoveTo,9,,'AlexScAFinal',,'AlexScAFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,'AdamScAFinal',,'AdamScAFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,9,,'BorisScAFinal',,'BorisScAFinal',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1.5);
    CinCamera(1, , ,);
    Teleport(1, 'AlekseevichTeleportDestination');
    ResetGroupGoals();
    ChangeState(1,'s_default');
    Goal_Default(1,GOAL_Guard,9,,'AlekseevichTeleportDestination',,'AlekseevichTeleportDestination',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Teleport(2, 'AdamGuard');
    Teleport(3, 'Boris_0');
    SetExclusivity(FALSE);
    Goal_Default(2,GOAL_Guard,0,,'CrusherWalkwayFocusLight1',,'AdamGuard',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,0,,,,'Boris_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Jackpot:
    Log("Watch the dish blow up");
    End();
AlexCheck:
    Log("Someone in Alekseevichs group has been killed or knocked out.");
    CheckIfIsDead(1,'AlexKilled');
    CheckIfIsUnconscious(1,'AlexKilled');
    End();
AlexKilled:
    Log("Alekseevich has been killed or knocked out. This is a Game Over Condition.");
    SendPatternEvent('LambertAI','AlexDeathFail');
    End();

}

defaultproperties
{
}
