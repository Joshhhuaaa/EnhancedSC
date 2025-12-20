//=============================================================================
// P_4_2_2_Abt_InitGoal
//=============================================================================
class P_4_2_2_Abt_InitGoal extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
    local EVolume V;
    local EHat Hat;

    Super.InitPattern();

    ForEach AllActors(class'EVolume', V)
    {
        // Joshua - Disabling the volume after it triggers once, as the player could infinitely retrigger it to add the same objective
        if (V.name == 'EVolume9')
            V.bTriggerOnlyOnce = true;
    }

    // Joshua - Replace NPC skins for variety
    if (!bInit)
    {
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EGeorgianSoldier23' || P.name == 'EGeorgianSoldier25' || P.name == 'EGeorgianSoldier27')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.GESoldier.GESoldierA", class'Texture'));
            }
            if (P.name == 'EGeorgianSoldier29')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.GESoldier.GESoldierA", class'Texture'));
                EPawn(P).Hat = None;
                EPawn(P).HatMesh = None;
            }
            if (P.name == 'EUSPrisoner5')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Prisoner.PrisonerB", class'Texture'));
            }
        }
        }

        ForEach AllActors(Class'EHat', Hat)
        {
            if (Hat.name == 'EHat4')
            {
                Hat.Destroy();
            }
        }
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
LastMapGoal:
    Log("goal and note from 421");
    AddGoal('DestroyAntenna', "", 8, "", "P_4_2_2_Abt_InitGoal", "Goal_0001L", "Localization\\P_4_2_2_Abattoir", "P_4_2_2_Abt_InitGoal", "Goal_0004L", "Localization\\P_4_2_2_Abattoir");
    GoalCompleted('DestroyAntenna');
    AddGoal('StopSoldier', "", 4, "", "P_4_2_2_Abt_InitGoal", "Goal_0002L", "Localization\\P_4_2_2_Abattoir", "P_4_2_2_Abt_InitGoal", "Goal_0005L", "Localization\\P_4_2_2_Abattoir");
    GoalCompleted('StopSoldier');
    AddRecon(class 'EReconPicGrinko');
    AddRecon(class 'EReconFullTextGrinko');
NextGoal:
    Log("");
    AddGoal('LocateSoldier', "", 6, "", "P_4_2_2_Abt_InitGoal", "Goal_0003L", "Localization\\P_4_2_2_Abattoir", "P_4_2_2_Abt_InitGoal", "Goal_0006L", "Localization\\P_4_2_2_Abattoir");
    Sleep(1);
    SendUnrealEvent('Mover3');
    End();

}

