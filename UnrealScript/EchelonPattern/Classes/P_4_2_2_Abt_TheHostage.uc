//=============================================================================
// P_4_2_2_Abt_TheHostage
//=============================================================================
class P_4_2_2_Abt_TheHostage extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int InFight;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('HostageKilled');
            break;
        case AI_UNCONSCIOUS:
            EventJump('HostageKilled');
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
        if (P.name == 'ELongDan0')
            Characters[1] = P.controller;
        if (P.name == 'EChineseDignitary0')
            Characters[2] = P.controller;
        if (P.name == 'EChineseDignitary1')
            Characters[3] = P.controller;
        if (P.name == 'EUSPrisoner4')
            Characters[4] = P.controller;
        if (P.name == 'EUSPrisoner3')
            Characters[5] = P.controller;
        if (P.name == 'EUSPrisoner5')
            Characters[6] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    InFight=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Hostage:
    Log("");
HostageKilled:
    Log("Are the hostage dead");
    CheckIfIsDead(1,'GOchinese');
    CheckIfIsUnconscious(1,'GOchinese');
    CheckIfIsDead(2,'GOchinese');
    CheckIfIsUnconscious(2,'GOchinese');
    CheckIfIsDead(3,'GOchinese');
    CheckIfIsUnconscious(3,'GOchinese');
    CheckIfIsDead(4,'GameOver');
    CheckIfIsUnconscious(4,'GameOver');
    CheckIfIsDead(5,'GameOver');
    CheckIfIsUnconscious(5,'GameOver');
    CheckIfIsDead(6,'GameOver');
    CheckIfIsUnconscious(6,'GameOver');
    End();
GetCover:
    Log("Get Cover");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode320',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Wait,8,,,,'PathNode320','PrsoCrAlBB0',FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode503',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Wait,8,,,,'PathNode320','PrsoCrAlCC0',FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PathNode321',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Wait,8,,,,'EChineseDignitary1','PrsoCrAlCC0',FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(4,GOAL_MoveTo,9,,,,'PathNode316',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(4,GOAL_Wait,8,,,,'PathNode504','PrsoCrAlCC0',FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(5,GOAL_MoveTo,9,,,,'PathNode504',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(5,GOAL_Wait,8,,,,'PathNode317','PrsoCrAlBB0',FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(6,GOAL_MoveTo,9,,,,'PathNode317',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(6,GOAL_Wait,8,,,,'PathNode504','PrsoCrAlBB0',FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    SetFlags(InFight,TRUE);
    End();
GOchinese:
    Log("");
    DisableMessages(TRUE, TRUE);
    SetFlags(V4_2_2_Abattoir(Level.VarObject).HostageType,TRUE);
GameOver:
    Log("GameOver");
    DisableMessages(TRUE, TRUE);
    CheckFlags(InFight,TRUE,'NotSam');
    SendPatternEvent('EGroupAI28','HostageSam');
    End();
NotSam:
    SendPatternEvent('EGroupAI28','HostageSoldier');
    End();
LongDanKiLLGrinko:
    Log("");
    End();
USspeach:
    Log("");
    DisableMessages(FALSE, TRUE);
    JumpRandom('UsSpeach1', 0.34, 'UsSpeach2', 0.67, 'UsSpeach3', 1.00, , , ,); 
UsSpeach1:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_66_01', 4, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_66_02', 4, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();
UsSpeach2:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_66_03', 5, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_66_04', 5, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();
UsSpeach3:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_66_05', 6, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_66_06', 6, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();
DiplomatSpeach:
    Log("");
    DisableMessages(FALSE, TRUE);
    JumpRandom('DiploSpeach1', 0.34, 'DiploSpeach2', 0.67, 'DiploSpeach3', 1.00, , , ,); 
DiploSpeach1:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_67_01', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_67_02', 3, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();
DiploSpeach2:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_67_02', 3, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();
DiploSpeach3:
    Log("");
    Talk(Sound'S4_2_2Voice.Play_42_67_01', 2, , TRUE, 0);
    Talk(Sound'S4_2_2Voice.Play_42_67_03', 1, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();

}

