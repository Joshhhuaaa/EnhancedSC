//=============================================================================
// P_3_4_3_Sev_LambertComms
//=============================================================================
class P_3_4_3_Sev_LambertComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax
#exec OBJ LOAD FILE=..\Animations\EOSP.ukx PACKAGE=EOSP

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FinalePlayed;
var int MoveEmOutPlayed;
var int ServerActive;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;
    local EAnimatedObject Osprey;
    local ETurret Turret;
    local ETurretController TurretController;
    local name OspreyAnimation;
    
    if (!bInit)
    {
        // Joshua - Adding turret controllers for the turrets
        // ETurret0 - Server room
        // ETurret1 - Server room
        // ETurret2
        TurretController = Spawn(class'ETurretController', , , vect(-4000, 4900, 518), rot(0, 16384, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret2')
                TurretController.LinkedTurret = ETurret(A);
        }

        // ETurret3
        TurretController = Spawn(class'ETurretController', , , vect(-4120, 4420, 518), rot(0, 49152, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret3')
                TurretController.LinkedTurret = ETurret(A);
        }

        // ETurret4
        TurretController = Spawn(class'ETurretController', , , vect(-3200, 4800, 518), rot(0, 16384, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret4')
                TurretController.LinkedTurret = ETurret(A);
        }

        // ETurret5
        TurretController = Spawn(class'ETurretController', , , vect(-3350, 4300, 518), rot(0, 49152, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret5')
                TurretController.LinkedTurret = ETurret(A);
        }

        // Joshua - Adding the Osprey mesh used in the final game
        Osprey = Spawn(class'EAnimatedObject', , , vect(-6111, 590, 266), rot(0, -0, 0));
        Osprey.SetDrawType(DT_Mesh);
        Osprey.Mesh = SkeletalMesh'EOSP.Osprey';
        Osprey.bLoopNeutral = True;
    
        OspreyAnimation = '2260osp3';
        Osprey.NeutralPoseAnim =  OspreyAnimation;

        OspreyAnimation = '2260osp2';
        Osprey.TriggeredAnimations[0] = OspreyAnimation;

        OspreyAnimation = '2260osp4';
        Osprey.TriggeredAnimations[1] = OspreyAnimation;

        Osprey.AmbientPlaySound = Sound'Vehicules.Play_OspreyIdle';
        Osprey.AmbientStopSound = Sound'Vehicules.Play_OspreyIdle';

        Osprey.HeatIntensity = 1.0;
        Osprey.SurfaceType = SURFACE_MetalHard;        
        Osprey.InitialHitPoints = 100;
        
        Osprey.Tag = 'Osprey';
    }
    
    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    // Joshua - Adding texture to several meshes, disabling a trigger that caused game to crash
   ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EEventTrigger8')
            A.SetCollision(False);
        if(A.name == 'ESwingingDoor18')
            A.Skins[0] = Texture(DynamicLoadObject("3_4_Severo_tex.Door07_SEV", class'Texture'));
        if(A.name == 'StaticMeshActor946')
            A.Skins[0] = Texture(DynamicLoadObject("3_4_Severo_tex.Door07_SEV", class'Texture'));
        if(A.name == 'StaticMeshActor237') // Joshua - Hiding the placeholder Osprey
            A.bHidden = True;
        if(A.name == 'ESBPatchActor2') 
            A.Texture = Shader(DynamicLoadObject("3_4_Severo_tex.Objects.plasticshd", class'Shader'));
        if(A.name == 'StaticMeshActor273')
            A.Skins[0] = Texture(DynamicLoadObject("3_2PowerPlant_tex.Cleanup.classeur_pow", class'Texture'));
        if(A.name == 'StaticMeshActor393')
            A.Skins[0] = Texture(DynamicLoadObject("3_2PowerPlant_tex.Cleanup.classeur_pow", class'Texture'));
        if(A.name == 'StaticMeshActor1037')
            A.Skins[0] = Texture(DynamicLoadObject("3_2PowerPlant_tex.Cleanup.classeur_pow", class'Texture'));
        if(A.name == 'StaticMeshActor1318')
            A.Skins[0] = Texture(DynamicLoadObject("3_2PowerPlant_tex.Cleanup.classeur_pow", class'Texture'));
        if(A.name == 'StaticMeshActor1319')
            A.Skins[0] = Texture(DynamicLoadObject("3_2PowerPlant_tex.Cleanup.classeur_pow", class'Texture'));
        if(A.name == 'StaticMeshActor1343')
            A.Skins[0] = Texture(DynamicLoadObject("EGO_Tex.GenTexGO.GO_laptop", class'Texture'));
        if(A.name == 'StaticMeshActor1344')
            A.Skins[0] = Texture(DynamicLoadObject("EGO_Tex.GenTexGO.GO_laptop", class'Texture'));
        if(A.name == 'EChair0') // Joshua - Hiding placeholder chair
            A.bHidden = True;
    }

    if( !bInit )
    {
    bInit=TRUE;
    FinalePlayed=0;
    MoveEmOutPlayed=0;
    ServerActive=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("These are the comms received from Lambert in the level");
InitGoals:
    Log("Sams starting state.");
    // Joshua - Adding equipment from previous part
    InventoryManager(0, true, 'None', 1, true, Class'EchelonIngredient.ELockpick', false);
    InventoryManager(0, true, 'None', 1, true, Class'EchelonIngredient.EOpticCable', false);
    InventoryManager(0, true, 'None', 5, true, Class'EchelonIngredient.EStickyCamera', false);
    InventoryManager(0, true, 'None', 5, true, Class'EchelonIngredient.ERingAirfoilRound', false);
    InventoryManager(0, true, 'None', 5, true, Class'EchelonIngredient.EStickyShocker', false);
    InventoryManager(0, true, 'None', 1, true, Class'EchelonIngredient.ECameraJammer', false);
    InventoryManager(0, true, 'None', 2, true, Class'EchelonIngredient.EDisposablePick', false);
    // Joshua - End of equipment
    AddGoal('COOPMASSE', "", 1, "", "P_3_4_3_Sev_LambertComms", "Goal_0023L", "Localization\\P_3_4_3Severonickel", "P_3_4_3_Sev_LambertComms", "Goal_0061L", "Localization\\P_3_4_3Severonickel");
    AddGoal('ALEKS', "", 10, "", "P_3_4_3_Sev_LambertComms", "Goal_0056L", "Localization\\P_3_4_3Severonickel", "P_3_4_3_Sev_LambertComms", "Goal_0062L", "Localization\\P_3_4_3Severonickel");
    SendPatternEvent('TerraHaute','LambertGrimOrders');
    End();
SabotageSAMs:
    Log("Lambert tells Sam he'll need to sabotage the SAM launchers");
    AddGoal('SAMS', "", 3, "", "P_3_4_3_Sev_LambertComms", "Goal_0055L", "Localization\\P_3_4_3Severonickel", "P_3_4_3_Sev_LambertComms", "Goal_0063L", "Localization\\P_3_4_3Severonickel");
    AddRecon(class 'EReconFullTextMissileDesc');
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0050L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_30_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0051L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_30_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0052L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_30_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0053L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_30_04', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0054L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_30_05', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SAMA:
    Log("One SAM has been sabotaged");
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0057L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_32_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SAMB:
    Log("Two SAM's have been sabotaged");
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0058L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_44_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SAMC:
    Log("All three SAM's have been sabotaged checking to see if the server is deactivated yet.");
    CheckFlags(V3_4_3Severonickel(Level.VarObject).ServerActive,TRUE,'ServerStillRemains');
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0059L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_67_02', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    SendPatternEvent('GrandFinale','IsOspreySafe');
    End();
SkippedSAM:
    Log("Sam has skipped a SAM, this label might get cut.");
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0069L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_68_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
ServerStillRemains:
    Log("Lambert reminds Sam to deal with the server.");
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0060L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_69_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
NearDisaster:
    Log("Algorithm Near Disaster");
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0006L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_54_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0007L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_54_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0008L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_54_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
AlgoSuccess:
    Log("Sam has deactivated the server");
    GoalCompleted('SERVER');
    SetFlags(V3_4_3Severonickel(Level.VarObject).ServerActive,FALSE);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0038L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_58_01', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0039L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_58_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0040L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_58_03', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0041L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_58_04', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0042L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_58_05', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Log("Checking to see if a SAM is active.");
    CheckFlags(V3_4_3Severonickel(Level.VarObject).OneSAMActive,TRUE,'GoBackForSAM');
    Jump('DontGoBack');
    End();
GoBackForSAM:
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0043L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_58_06', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
DontGoBack:
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0044L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_65_07', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('RENDEZVOUS', "", 4, "", "P_3_4_3_Sev_LambertComms", "Goal_0045L", "Localization\\P_3_4_3Severonickel", "P_3_4_3_Sev_LambertComms", "Goal_0064L", "Localization\\P_3_4_3Severonickel");
    Close();
    SendPatternEvent('GrandFinale','IsOspreySafe');
    End();
EitherWay:
    Log("Either way we still have to close the camera.");
    Close();
    End();
AlgoFail:
    Log("Sam failed to stop the algorithm from destroying Pickett Gap.");
    SetProfileDeletion();
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0070L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_56_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0020L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_56_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    GameOver(false, 0);
    End();
TimerFailed:
    Log("Sam failed to get to Masse in time. Game Over.");
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0048L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_62_01', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
Executed:
    Log("Sam killed Masse, game over.");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0025L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_62_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    GameOver(false, 0);
    End();
TimerWarning:
    Log("Masses timer has started.");
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0065L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_51_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0066L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_51_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_3_Sev_LambertComms", "Speech_0067L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_51_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
DoNothing:
    End();
LevelChange:
    Log("Changing the level yo.");
    LevelChange("3_4_4Severonickel");
    End();

}

defaultproperties
{
}
