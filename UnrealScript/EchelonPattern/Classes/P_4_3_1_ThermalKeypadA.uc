//=============================================================================
// P_4_3_1_ThermalKeypadA
//=============================================================================
class P_4_3_1_ThermalKeypadA extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int oneInert;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('KeypadACheckDead');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('AISeePlayer');
            break;
        case AI_REVIVED:
            EventJump('revived');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AISeePlayer');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AISeePlayer');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KeypadACheckDead');
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
        if (P.name == 'EAzeriColonel1')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier0')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    oneInert=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ThermalKeypadA:
    Log("ThermalKeypadA Start");
    Teleport(1, 'ThermalKeypadATeleport01');
    Teleport(2, 'ThermalKeypadATeleport02');
    ResetGroupGoals();
    SendPatternEvent('SwitchDummyC','LoopKeypad');
    ChangeGroupState('s_default');
    Goal_Default(1,GOAL_Guard,9,,'ThermalKeypadAFocus03',,'ThermalKeypadANode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'ThermalKeypadAFocus02',,'ThermalKeypadANode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Speech(Localize("P_4_3_1_ThermalKeypadA", "Speech_0001L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_52_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_4_3_1_ThermalKeypadA", "Speech_0002L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_52_02', 2, 0, TR_NPCS, 0, false);
    Close();
    Goal_Set(1,GOAL_InteractWith,9,,'HallKeypad',,'HallKeypad',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_InteractWith,);
    SendPatternEvent('LambertComms','ThermalKeypadExplanationC');
    End();
AISeePlayer:
    Log("AISeePlayer");
    SetExclusivity(FALSE);
    End();
KeypadACheckDead:
    Log("KeypadACheckDead");
    SetFlags(oneInert,FALSE);
    CheckIfIsDead(1,'ColonelDied');
    CheckIfIsUnconscious(1,'ColonelDied');
SolTest:
    CheckIfIsDead(2,'SoldierDied');
    CheckIfIsUnconscious(2,'SoldierDied');
    End();
SoldierDied:
    Log("SoldierDied");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadASoldierSwitch,TRUE);
    CheckFlags(oneInert,TRUE,'BothDied');
    End();
ColonelDied:
    Log("ColonelDied");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadAColonelSwitch,TRUE);
    SetFlags(oneInert,TRUE);
    Jump('SolTest');
BothDied:
    Log("BothDied");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).BothKeypadADied,TRUE);
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadWasUsed,TRUE,'End');
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadExpiredToggle,TRUE);
    End();
revived:
    Log("");
    CheckIfIsDead(1,'two');
    CheckIfIsUnconscious(1,'two');
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadAColonelSwitch,FALSE);
two:
    CheckIfIsDead(2,'End');
    CheckIfIsUnconscious(2,'End');
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadASoldierSwitch,FALSE);
End:
    End();

}

