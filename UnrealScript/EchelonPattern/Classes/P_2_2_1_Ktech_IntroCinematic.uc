//=============================================================================
// P_2_2_1_Ktech_IntroCinematic
//=============================================================================
class P_2_2_1_Ktech_IntroCinematic extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Lambert.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int PlayIntroOnce;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('WilkesDied');
            break;
        case AI_UNCONSCIOUS:
            EventJump('WilkesDied');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local EHat Hat;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EWilkes0')
            Characters[1] = P.controller;
        if (P.name == 'ELambert0')
            Characters[2] = P.controller;
    }

    // Joshua - Replace NPC skins for variety
    if (!bInit)
    {
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EMafiaMuscle0')
            {
                Hat = spawn(class'EHat', EPawn(P));
                Hat.SetStaticMesh(StaticMesh(DynamicLoadObject("EMeshCharacter.Mafia.KnitCap", class'StaticMesh')));
                Hat.Setup();
                EPawn(P).AttachToBone(Hat, 'HatBone');
                EPawn(P).Hat = Hat;
            }
            if (P.name == 'EMafiaMuscle5' || P.name == 'EMafiaMuscle8')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Grunt.GruntA", class'Texture'));
            }
            if (P.name == 'EMafiaMuscle14')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Grunt.GruntB", class'Texture'));
            }
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    PlayIntroOnce=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
IntroConversation:
    Log("IntroConversation");
    CheckFlags(PlayIntroOnce,TRUE,'DontPlayIntro');
    Talk(Sound'S2_2_1Voice.Play_22_02_01', 1, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_02_02', 0, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_02_03', 1, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_02_04', 0, , TRUE, 0);
    Close();
    SetFlags(PlayIntroOnce,TRUE);
WilkesTeleport:
    Goal_Set(1,GOAL_MoveTo,9,,,,'WilkesLeavingTeleport',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Teleport(1, 'WilkesTeleport');
    SendUnrealEvent('WilkesAI');
DontPlayIntro:
    End();
WilkesDied:
    Log("If Sam Kills Wilkes");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_2_2_1_Ktech_IntroCinematic", "Speech_0013L", "Localization\\P_2_2_1_Kalinatek"), Sound'Lambert.Play_41_95_01', 0, 0, TR_HEADQUARTER, 0, true);
    Sleep(2);
    Close();
    GameOver(false, 0);
    End();

}

