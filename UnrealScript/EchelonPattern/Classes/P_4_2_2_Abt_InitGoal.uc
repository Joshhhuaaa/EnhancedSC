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
    local EEventTrigger EventTrigger;
    local EHat Hat;
    local EChair Chair;
    local EZoneAI ZoneAI;

    Super.InitPattern();

    if (!bInit)
    {
        // Joshua - Disabling the volume after it triggers once, as the player could infinitely retrigger it to add the same objective
        ForEach AllActors(class'EVolume', V)
        {
            if (V.name == 'EVolume9')
            {
                V.bTriggerOnlyOnce = true;
                V.Tag = 'EVolume9';
            }
        }

        // Joshua - Fixes a bug where unconscious NPCs trigger the hostages to bark
        ForEach AllActors(class'EEventTrigger', EventTrigger)
        {
            if (EventTrigger.name == 'EEventTrigger4' || EventTrigger.name == 'EEventTrigger19' )
                EventTrigger.bNPCMustBeconscious = true;
        }

        // Joshua - Replace NPC skins for variety
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

        ForEach DynamicActors(class'EChair', Chair)
        {
            if (Chair.name == 'EChair0')
            {
                Chair.SetLocation(Chair.Location + vect(0, -20, 0));
            }

            if (Chair.name == 'EChair1')
            {
                Chair.SetLocation(Chair.Location + vect(0, 20, 0));
            }
        }

        ForEach AllActors(Class'EHat', Hat)
        {
            if (Hat.name == 'EHat4')
            {
                Hat.Destroy();
            }
        }

        // Joshua - Merge EZoneAI4 DisableGroups into EZoneAI1 to prevent double alarm triggers
        ForEach AllActors(Class'EZoneAI', ZoneAI)
        {
            if (ZoneAI.name == 'EZoneAI1')
            {
                ZoneAI.EnableGroupTags[7] = 'EGroupAI9';
                ZoneAI.EnableGroupTags[8] = 'EGroupAI10';
                ZoneAI.DisableGroupTags[2] = 'EGroupAI1';
            }
            
            if (ZoneAI.name == 'EZoneAI4')
            {
                ZoneAI.DisableGroupTags.Length = 0;
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

