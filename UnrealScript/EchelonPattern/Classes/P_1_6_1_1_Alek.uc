//=============================================================================
// P_1_6_1_1_Alek
//=============================================================================
class P_1_6_1_1_Alek extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CinPlayed;
var int TelDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('KilledOrKOed');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KilledOrKOed');
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
        if(P.name == 'EAleksee0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if(P.name == 'spetsnaz10')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    CinPlayed=0;
    TelDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneAlek:
    Log("MilestoneAlek");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerObj,FALSE,'End');
    CheckFlags(CinPlayed,TRUE,'End');
    SetFlags(CinPlayed,TRUE);
    Close();
    SendUnrealEvent('AllowTensionGuy');
    Teleport(2, 'TopStairsConv');
    Teleport(1, 'ConvAlekA');
    Goal_Set(2,GOAL_Guard,8,,'AlekBitchFocus',,'TopStairsConv',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'TopStairsConv',,'ConvAlekA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(0.50);
    CinCamera(0, 'SpetCin', 'SpetCinB',);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_24_01', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_24_02', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_24_03', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_24_04', 2, , TRUE, 0);
    CinCamera(0, 'AlekKamA', 'SpetCinB',);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_24_05', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_24_06', 2, , TRUE, 0);
    ResetGoals(2);
    Goal_Default(2,GOAL_Patrol,9,,,,'PatrolNearServerA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,,,,'LstnStNmAA0',FALSE,,,,);
    Sleep(1);
    CinCamera(1, , ,);
    SetExclusivity(FALSE);
    End();
LambertQuickComment:
    Log("LambertQuickComment");
    ToggleGroupAI(TRUE, 'GroupAlek', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    ToggleGroupAI(TRUE, 'Flashers', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Speech(Localize("P_1_6_1_1_Alek", "Speech_0009L", "Localization\\P_1_6_1_1KolaCell"), Sound'S3_4_2Voice.Play_34_22_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
KilledOrKOed:
    Log("KilledOrKOed");
    CheckIfIsDead(1,'AlekIsOut');
    CheckIfIsUnconscious(1,'AlekIsOut');
    End();
AlekIsOut:
    Log("AlekIsOut");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).RetinalObj,TRUE,'End');
    SetProfileDeletion();
    Sleep(1);
    GameOver(false, 6);
    End();
HeadOnASpike:
    Log("HeadOnASpike");
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).ServerObj,TRUE);
    ToggleGroupAI(FALSE, 'GroupRadioFirst', 'GroupBasementAmbush', 'GroupExtincteur', 'GroupLoneForSplit', 'Lockerz', 'UNUSED_GROUP_TAG__');
    Sleep(1);
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,TRUE,'SkipDoorClose');
CloseDoor:
    Log("CloseDoor");
    SendUnrealEvent('servertrapdoor');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,TRUE);
SkipDoorClose:
    Log("SkipDoorClose");
    SendPatternEvent('GroupServerSweep','MilestoneNVServerSweep');
    Sleep(1);
    Speech(Localize("P_1_6_1_1_Alek", "Speech_0001L", "Localization\\P_1_6_1_1KolaCell"), Sound'S3_4_2Voice.Play_34_42_01', 1, 0, TR_NPCS, 0, false);
    Close();
    Sleep(4);
    SendPatternEvent('GroupServerSweep','SweepIt');
    End();
Tel:
    Log("Tel");
    ToggleGroupAI(FALSE, 'GroupAlek', 'Flashers', 'GroupServerSweep', 'LoneTense', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SendPatternEvent('GroupServerSweep','Tel');
    SendPatternEvent('Flashers','Tel');
    SendPatternEvent('LoneTense','Tel');
    CheckIfIsUnconscious(1,'TelB');
    Teleport(1, 'AlekOutB');
    KillNPC(1, FALSE, TRUE);
TelB:
    Log("TelB");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'AlekOutA');
    KillNPC(2, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}
