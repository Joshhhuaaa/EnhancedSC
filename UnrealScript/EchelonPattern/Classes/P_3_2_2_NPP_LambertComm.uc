//=============================================================================
// P_3_2_2_NPP_LambertComm
//=============================================================================
class P_3_2_2_NPP_LambertComm extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CommCenterDialog;
var int HoboDialog;
var int Inventory;
var int LeadLiningDialog;
var int Relay;
var int SmarglDialog;
var int WhatWeNeedDialog;


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
    local Mover M;
    local EGameplayObject EGO;
    local ETurret Turret;
    local ETurretController TurretController;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'ECIABureaucratF0')
            Characters[2] = P.controller;
    }

    
    ForEach DynamicActors(class'EGamePlayObject', EGO)
    {
        if (EGO.CollisionPrimitive == StaticMesh(DynamicLoadObject("EGO_OBJ.GenObjGO.General_GlasseB00", class'StaticMesh')))
        {
            EGO.DamagedMeshes[0].Percent = 0.0;
            //EGO.DamagedMeshes[0].StaticMesh
            //EGO.DamagedMeshes[0].CollPrimMesh = None;
        }

        // Joshua - Destroying the concussion grenade (canceled gadget) to prevent a crash
        if(EGO.name == 'EConcussionGrenade0')
            EGO.Destroy();

        // Joshua - Disposable pick was assigned the incorrect mesh
        if(EGO.name == 'EDisposablePick0')
        {
            EGO.SetStaticMesh(StaticMesh'EMeshIngredient.Item.DisposablePick');
            EGO.SetLocation(EGO.Location + vect(0,0,-13.5));
        }

        // Joshua - Door nametag placement fix
        if(EGO.name == 'EGameplayObject18' && !bInit)
        {
            // This is not working properly yet location remains static instead attached to door
            // EGO.SetLocation(vect(13971.016602, -6400.000000, 984.000000));
            // Going to hide the object for now.
            EGO.bHidden = true;
            // Location=(X=13971.016602,Y=-6315.776367,Z=984.000000)
        }
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'ELight48' || A.name == 'ELight56')
            A.bAffectOwnZoneOnly=true;

        if(A.name == 'ELight55')
            A.LightEffect=LE_ESpotShadow;

        if(A.name == 'ELight117')
            A.LightEffect=LE_ESpotShadowDistAtten;
    }

    ForEach AllActors(class'Mover', M)
    {
        if (M.name == 'ESlidingDoor3')
            M.KeyPos[1]=(vect(0,112,0)); // Joshua - Originally, 144, lowered to 128.

        if (M.name == 'ESlidingDoor10')
            M.KeyPos[1]=(vect(0,0,0)); //0,-144,0 // Joshua - Going to keep this mover static since it clips through wall
    }

    // Joshua - Adding turret controllers for the turrets
    if (!bInit)
    {
        TurretController = Spawn(class'ETurretController', , , vect(12000, -6680, 430), rot(0, 16384, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret0')
                TurretController.LinkedTurret = ETurret(A);
        }

        TurretController = Spawn(class'ETurretController', , , vect(13080, -3440, 430), rot(0, 32768, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret1')
                TurretController.LinkedTurret = ETurret(A);
        }

        TurretController = Spawn(class'ETurretController', , , vect(14100, -5016, 430), rot(0, 49152, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret2')
                TurretController.LinkedTurret = ETurret(A);
        }


        TurretController = Spawn(class'ETurretController', , , vect(12670, -3310, 430), rot(0, 49152, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret4')
                TurretController.LinkedTurret = ETurret(A);
        }

        TurretController = Spawn(class'ETurretController', , , vect(13360, -7180, 430), rot(0, 16384, 0));
        ForEach AllActors(class'Actor', A)
        {
            if(A.name == 'ETurret5')
                TurretController.LinkedTurret = ETurret(A);
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    CommCenterDialog=0;
    HoboDialog=0;
    Inventory=0;
    LeadLiningDialog=0;
    Relay=0;
    SmarglDialog=0;
    WhatWeNeedDialog=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FalseRelay:
    Log("Communicator 32_44 -  Lambert Comm for the Communications Center.");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0001L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(10);
    Close();
    End();
Radioactive:
    Log("Commmunicator 32_30 - Non-radioactive.");
    IgnoreAlarmStage(TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0002L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_30_01', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0003L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_30_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0004L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_30_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    AddGoal('2', "", 5, "", "P_3_2_2_NPP_LambertComm", "Goal_0005L", "Localization\\P_3_2_2_PowerPlant", "P_3_2_2_NPP_LambertComm", "Goal_0036L", "Localization\\P_3_2_2_PowerPlant");
    AddGoal('3', "", 8, "", "P_3_2_2_NPP_LambertComm", "Goal_0012L", "Localization\\P_3_2_2_PowerPlant", "P_3_2_2_NPP_LambertComm", "Goal_0037L", "Localization\\P_3_2_2_PowerPlant");
    AddGoal('4', "", 9, "", "P_3_2_2_NPP_LambertComm", "Goal_0013L", "Localization\\P_3_2_2_PowerPlant", "P_3_2_2_NPP_LambertComm", "Goal_0038L", "Localization\\P_3_2_2_PowerPlant");
    AddRecon(class 'EReconFullText3_2AF_B');
    Sleep(11);
    Jump('WayOut');
    End();
WayOut:
    Log("Communicator 32_33 - Another Way Out");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0006L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_33_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
Americium:
    Log("Communicator 32_40 - Americium");
    SetFlags(Inventory,TRUE);
    Sleep(3);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0007L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_40_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    AddRecon(class 'EReconFullText3_2AF_A');
    GoalCompleted('2');
    End();
LeadLining:
    Log("Communicator 32_46 - Lead Lining");
    CheckFlags(Inventory,FALSE,'Nada');
    CheckFlags(LeadLiningDialog,TRUE,'Nada');
    SetFlags(LeadLiningDialog,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0008L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_46_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0009L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_46_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0010L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_46_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
CommCenter:
    Log("Communicator 32_47 - Comm Center");
    CheckFlags(Inventory,FALSE,'Nada');
    CheckFlags(CommCenterDialog,TRUE,'Nada');
    SetFlags(CommCenterDialog,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0011L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_49_01', 1, 0, TR_HEADQUARTER, 0, false);
    AddNote("", "P_3_2_2_NPP_LambertComm", "Note_0023L", "Localization\\P_3_2_2_PowerPlant");
    Sleep(0.1);
    Close();
    End();
RelayFound:
    Log("Find relay goal completed.");
    GoalCompleted('3');
    End();
Relay:
    Log("THE relay cinematic.");
    SetFlags(Relay,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0015L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_45_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0016L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_45_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0017L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_45_03', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0018L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_45_04', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0019L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_45_05', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    GoalCompleted('4');
    LockDoor('FinalDoor', FALSE, TRUE);
    Close();
    End();
Nada:
    End();
WhatWeNeed:
    Log("Communicator 32_46 -  What we need");
    CheckFlags(Relay,FALSE,'Nada');
    CheckFlags(WhatWeNeedDialog,TRUE,'Nada');
    SetFlags(WhatWeNeedDialog,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0024L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_46_10', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
Hobo:
    Log("Communicator 32_47 -  Hobo");
    CheckFlags(Inventory,FALSE,'Nada');
    CheckFlags(Relay,FALSE,'Nada');
    CheckFlags(HoboDialog,TRUE,'Nada');
    SetFlags(HoboDialog,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0025L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_47_01', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0026L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_47_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0027L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_47_03', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0028L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_47_04', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0029L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_47_05', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('5', "", 1, "", "P_3_2_2_NPP_LambertComm", "Goal_0035L", "Localization\\P_3_2_2_PowerPlant", "P_3_2_2_NPP_LambertComm", "Goal_0039L", "Localization\\P_3_2_2_PowerPlant");
    AddNote("", "P_3_2_2_NPP_LambertComm", "Note_0030L", "Localization\\P_3_2_2_PowerPlant");
    Close();
    End();
SimarglBound:
    Log("Communicator 32_51 -  Simargl Bound");
    CheckFlags(Inventory,FALSE,'Nada');
    CheckFlags(Relay,FALSE,'Nada');
    CheckFlags(SmarglDialog,TRUE,'Nada');
    SetFlags(SmarglDialog,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0031L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_51_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0032L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_51_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0033L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_51_03', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_LambertComm", "Speech_0034L", "Localization\\P_3_2_2_PowerPlant"), Sound'S3_2_2Voice.Play_32_51_04', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
Load323:
    Log("Loads 3.2.3.");
    LevelChange("3_2_3_PowerPlant");
    End();
InventoryAcquired:
    Log("Memory stick has been read.");
    GoalCompleted('2');
    SetFlags(Inventory,TRUE);
    Jump('Americium');
    End();
TheEnd:
    Log("");
    GameOver(true, 0);
    End();

}

defaultproperties
{
}
