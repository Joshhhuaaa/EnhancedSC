class EPlayerStats extends Actor;

var EPlayerController Epc;

var string MissionName;
var float MissionTime;

var int PlayerIdentified;
var int BodyFound;
var int AlarmTriggered;

var int EnemyKnockedOut;
var int EnemyKnockedOutRequired;
var int EnemyInjured;
var int EnemyKilled;
var int EnemyKilledRequired;

var int CivilianKnockedOut;
var int CivilianKnockedOutRequired;
var int CivilianInjured;
var int CivilianKilled;
var int CivilianKilledRequired;

var int BulletFired;
var int LightDestroyed;
var int ObjectDestroyed;

var int LockPicked;
var int LockDestroyed;
var int MedkitUsed;

var int NPCsInterrogated;

var float GhostRating;
var float StealthRating;
var bool bMissionComplete;
var bool bCheatsActive;
var bool bStatsInitialized;

function ResetSessionStats()
{
    MissionTime = 0;

    PlayerIdentified = 0;
    BodyFound = 0;
    AlarmTriggered = 0;

    EnemyKnockedOut = 0;
    EnemyKnockedOutRequired = 0;
    EnemyInjured = 0;
    EnemyKilled = 0;
    EnemyKilledRequired = 0;

    CivilianKnockedOut = 0;
    CivilianKnockedOutRequired = 0;
    CivilianInjured = 0;
    CivilianKilled = 0;
    CivilianKilledRequired = 0;

    BulletFired = 0;
    LightDestroyed = 0;
    ObjectDestroyed = 0;
    
    LockPicked = 0;
    LockDestroyed = 0;
    MedkitUsed = 0;
 
    NPCsInterrogated = 0;

    GhostRating = 100.0;
    StealthRating = 100.0;
    bMissionComplete = false;
    bCheatsActive = false;
}

function PostBeginPlay()
{
    Epc = EPlayerController(Owner);
    bStatsInitialized = false;
    
    // Joshua - Reset stats initially, will load from console once Player is ready
    ResetSessionStats();
    MissionName = GetCurrentMapName();
    
    Enable('Tick');
}

function Tick(float DeltaTime)
{
    if (!bStatsInitialized && Epc.Player != None && Epc.Player.Console != None)
    {
        InitializeStats();
    }
    
    if (!bMissionComplete)
    {
        MissionTime += DeltaTime;
    }
}

// Joshua - Called once Player.Console is ready to initialize stats
function InitializeStats()
{
    local string CurrentMap;
    local bool bReset;
    
    CurrentMap = GetCurrentMapName();
    bReset = false;
    
    // Joshua - Only reset stats if we're moving to a new mission
    if (Epc.Player.Console.StatsMissionName != "")
    {
        bReset = ShouldResetStats(Epc.Player.Console.StatsMissionName, CurrentMap);
    }
    
    if (bReset || Epc.Player.Console.StatsMissionName == "")
    {
        ResetSessionStats();
    }
    else
    {
        LoadStatsFromConsole();
    }
    
    MissionName = CurrentMap;

    CalculateGhostRating();
    CalculateStealthRating();
    
    bStatsInitialized = true;
}

function AddStat(string StatName, optional int Amount)
{
    if (bMissionComplete)
        return;

    if (Amount == 0)
        Amount = 1;
        
    switch (StatName)
    {
        case "PlayerIdentified":
            PlayerIdentified += Amount;
            break;
        case "BodyFound":
            BodyFound += Amount;
            break;
        case "AlarmTriggered":
            AlarmTriggered += Amount;
            break;
        case "EnemyKnockedOut":
            EnemyKnockedOut += Amount;
            break;
        case "EnemyKnockedOutRequired":
            EnemyKnockedOutRequired += Amount;
            break;
        case "EnemyInjured":
            EnemyInjured += Amount;
            break;
        case "EnemyKilled":
            EnemyKilled += Amount;
            break;
        case "EnemyKilledRequired":
            EnemyKilledRequired += Amount;
            break;
        case "CivilianKnockedOut":
            CivilianKnockedOut += Amount;
            break;
        case "CivilianKnockedOutRequired":
            CivilianKnockedOutRequired += Amount;
            break;
        case "CivilianInjured":
            CivilianInjured += Amount;
            break;
        case "CivilianKilled":
            CivilianKilled += Amount;
            break;
        case "CivilianKilledRequired":
            CivilianKilledRequired += Amount;
            break;
        case "BulletFired":
            BulletFired += Amount;
            break;
        case "LightDestroyed":
            LightDestroyed += Amount;
            break;
        case "ObjectDestroyed":
            ObjectDestroyed += Amount;
            break;
        case "LockPicked":
            LockPicked += Amount;
            break;
        case "LockDestroyed":
            LockDestroyed += Amount;
            break;
        case "MedkitUsed":
            MedkitUsed += Amount;
            break;
        case "NPCsInterrogated":
            NPCsInterrogated += Amount;
            break;
    }

    CalculateGhostRating();
    CalculateStealthRating();
    SaveStatsToConsole();
}

function bool ShouldResetStats(string PreviousMap, string NextMap)
{
    if (PreviousMap == "0_0_2_Training" && NextMap == "0_0_3_Training") return false;
    
    if (PreviousMap == "1_1_0Tbilisi" && NextMap == "1_1_1Tbilisi") return false;
    if (PreviousMap == "1_1_1Tbilisi" && NextMap == "1_1_2Tbilisi") return false;
    
    if (PreviousMap == "1_2_1DefenseMinistry" && NextMap == "1_2_2DefenseMinistry") return false;
    
    if (PreviousMap == "1_3_2CaspianOilRefinery" && NextMap == "1_3_3CaspianOilRefinery") return false;
    
    if (PreviousMap == "1_7_1_1VselkaInfiltration" && NextMap == "1_7_1_2Vselka") return false;
    
    if (PreviousMap == "2_1_0CIA" && NextMap == "2_1_1CIA") return false;
    if (PreviousMap == "2_1_1CIA" && NextMap == "2_1_2CIA") return false;
    
    if (PreviousMap == "2_2_1_Kalinatek" && NextMap == "2_2_2_Kalinatek") return false;
    if (PreviousMap == "2_2_2_Kalinatek" && NextMap == "2_2_3_Kalinatek") return false;
    
    if (PreviousMap == "3_2_1_PowerPlant" && NextMap == "3_2_2_PowerPlant") return false;
    
    if (PreviousMap == "3_4_2Severonickel" && NextMap == "3_4_3Severonickel") return false;
    
    if (PreviousMap == "4_1_1ChineseEmbassy" && NextMap == "4_1_2ChineseEmbassy") return false;
    
    if (PreviousMap == "4_2_1_Abattoir" && NextMap == "4_2_2_Abattoir") return false;
    
    if (PreviousMap == "4_3_0ChineseEmbassy" && NextMap == "4_3_1ChineseEmbassy") return false;
    if (PreviousMap == "4_3_1ChineseEmbassy" && NextMap == "4_3_2ChineseEmbassy") return false;
    
    if (PreviousMap == "5_1_1_PresidentialPalace" && NextMap == "5_1_2_PresidentialPalace") return false;
    
    return true;
}

function CalculateGhostRating()
{
    local float rating;
    rating = 100.0;

    rating -= float(PlayerIdentified) * 15.0;
    rating -= float(BodyFound) * 15.0;
    rating -= float(AlarmTriggered) * 20.0;
    
    rating -= float(EnemyKnockedOut) * 5.0;
    rating -= float(CivilianKnockedOut) * 5.0;

    rating -= float(EnemyKilled) * 15.0;
    rating -= float(CivilianKilled) * 30.0;

    rating -= float(LockDestroyed) * 2.0;

    /* Joshua - Allow rating to go below 0 like SCDA
    if (rating < 0)
        rating = 0;*/

    GhostRating = rating;
}

function CalculateStealthRating()
{
    local float rating;
    rating = 100.0;

    rating -= float(PlayerIdentified) * 15.0;
    rating -= float(BodyFound) * 15.0;
    rating -= float(AlarmTriggered) * 20.0;
    
    rating -= float(EnemyKilled) * 15.0;
    rating -= float(CivilianKilled) * 30.0;

    /* Joshua - Allow rating to go below 0 like SCDA
    if (rating < 0)
        rating = 0;*/

    StealthRating = rating;
}

// Joshua - Returns the play time in a formatted string (HH:MM:SS)
function string GetFormattedPlayTime(float TimeInSeconds)
{
    local int Hours, Minutes, Seconds;
    local string TimeString;
    
    Hours = int(TimeInSeconds / 3600);
    Minutes = int((TimeInSeconds - (Hours * 3600)) / 60);
    Seconds = int(TimeInSeconds - (Hours * 3600) - (Minutes * 60));
    
    if (Hours < 10)
        TimeString = "0" $ Hours $ ":";
    else
        TimeString = Hours $ ":";
        
    if (Minutes < 10)
        TimeString = TimeString $ "0" $ Minutes $ ":";
    else
        TimeString = TimeString $ Minutes $ ":";
        
    if (Seconds < 10)
        TimeString = TimeString $ "0" $ Seconds;
    else
        TimeString = TimeString $ Seconds;
        
    return TimeString;
}

function OnMissionComplete()
{
    bMissionComplete = true;
}

function OnLevelChange()
{
    SaveStatsToConsole();
}

// Joshua - Load stats from console for persistence between level parts
function LoadStatsFromConsole()
{
    MissionTime = Epc.Player.Console.StatsMissionTime;
    PlayerIdentified = Epc.Player.Console.StatsPlayerIdentified;
    BodyFound = Epc.Player.Console.StatsBodyFound;
    AlarmTriggered = Epc.Player.Console.StatsAlarmTriggered;
    EnemyKnockedOut = Epc.Player.Console.StatsEnemyKnockedOut;
    EnemyKnockedOutRequired = Epc.Player.Console.StatsEnemyKnockedOutRequired;
    EnemyInjured = Epc.Player.Console.StatsEnemyInjured;
    EnemyKilled = Epc.Player.Console.StatsEnemyKilled;
    EnemyKilledRequired = Epc.Player.Console.StatsEnemyKilledRequired;
    CivilianKnockedOut = Epc.Player.Console.StatsCivilianKnockedOut;
    CivilianKnockedOutRequired = Epc.Player.Console.StatsCivilianKnockedOutRequired;
    CivilianInjured = Epc.Player.Console.StatsCivilianInjured;
    CivilianKilled = Epc.Player.Console.StatsCivilianKilled;
    CivilianKilledRequired = Epc.Player.Console.StatsCivilianKilledRequired;
    BulletFired = Epc.Player.Console.StatsBulletFired;
    LightDestroyed = Epc.Player.Console.StatsLightDestroyed;
    ObjectDestroyed = Epc.Player.Console.StatsObjectDestroyed;
    LockPicked = Epc.Player.Console.StatsLockPicked;
    LockDestroyed = Epc.Player.Console.StatsLockDestroyed;
    MedkitUsed = Epc.Player.Console.StatsMedkitUsed;
    NPCsInterrogated = Epc.Player.Console.StatsNPCsInterrogated;
    bCheatsActive = Epc.Player.Console.StatsCheatsActive;
}

// Joshua - Save stats to console for persistence between level parts
function SaveStatsToConsole()
{
    Epc.Player.Console.StatsMissionName = MissionName;
    Epc.Player.Console.StatsMissionTime = MissionTime;
    Epc.Player.Console.StatsPlayerIdentified = PlayerIdentified;
    Epc.Player.Console.StatsBodyFound = BodyFound;
    Epc.Player.Console.StatsAlarmTriggered = AlarmTriggered;
    Epc.Player.Console.StatsEnemyKnockedOut = EnemyKnockedOut;
    Epc.Player.Console.StatsEnemyKnockedOutRequired = EnemyKnockedOutRequired;
    Epc.Player.Console.StatsEnemyInjured = EnemyInjured;
    Epc.Player.Console.StatsEnemyKilled = EnemyKilled;
    Epc.Player.Console.StatsEnemyKilledRequired = EnemyKilledRequired;
    Epc.Player.Console.StatsCivilianKnockedOut = CivilianKnockedOut;
    Epc.Player.Console.StatsCivilianKnockedOutRequired = CivilianKnockedOutRequired;
    Epc.Player.Console.StatsCivilianInjured = CivilianInjured;
    Epc.Player.Console.StatsCivilianKilled = CivilianKilled;
    Epc.Player.Console.StatsCivilianKilledRequired = CivilianKilledRequired;
    Epc.Player.Console.StatsBulletFired = BulletFired;
    Epc.Player.Console.StatsLightDestroyed = LightDestroyed;
    Epc.Player.Console.StatsObjectDestroyed = ObjectDestroyed;
    Epc.Player.Console.StatsLockPicked = LockPicked;
    Epc.Player.Console.StatsLockDestroyed = LockDestroyed;
    Epc.Player.Console.StatsMedkitUsed = MedkitUsed;
    Epc.Player.Console.StatsNPCsInterrogated = NPCsInterrogated;
    Epc.Player.Console.StatsCheatsActive = bCheatsActive;
}

defaultproperties
{
    bHidden=True
}
