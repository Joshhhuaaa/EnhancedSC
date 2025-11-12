//=============================================================================
// P_1_7_1_2_TorpedoDefendC
//=============================================================================
class P_1_7_1_2_TorpedoDefendC extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_3_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S3_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('GoFalseTorpedoDefendC');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('GoFalseTorpedoDefendC');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('GoFalseTorpedoDefendC');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('GoFalseTorpedoDefendC');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GoFalseTorpedoDefendC');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GoFalseTorpedoDefendC');
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
        if (P.name == 'spetsnaz19')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if (P.name == 'spetsnaz20')
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
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
MilestoneTorpedoDefendC:
    Log("MilestoneTorpedoDefendC");
    ToggleGroupAI(TRUE, 'TorpedoDefendC', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'TorpedoNodeD',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'LastGrenadesB','LastGrenadesB','TorpedoNodeD',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'TorpedoNodeA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'LastGrenadesB','LastGrenadesB','TorpedoNodeA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
CommTorpedoDefendC:
    Log("CommTorpedoDefendC");
    Speech(Localize("P_1_7_1_2_TorpedoDefendC", "Speech_0001L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_3_1Voice.Play_33_64_01', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_1_7_1_2_TorpedoDefendC", "Speech_0002L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_1_2Voice.Play_31_36_04', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
GoFalseTorpedoDefendC:
    Log("GoFalseTorpedoDefendC");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_ShootHim;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
