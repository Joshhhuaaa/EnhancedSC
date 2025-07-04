class EPlayerStats extends Actor
    config (Enhanced);

var config string MissionName;
var config float MissionTime;
var config float MissionTimePart;

var config int EnemyKnockedOut;
var config int EnemyKnockedOutRequired;
var config int EnemyInjured;
var config int EnemyKilled;
var config int EnemyKilledRequired;

var config int CivilianKnockedOut;
var config int CivilianKnockedOutRequired;
var config int CivilianInjured;
var config int CivilianKilled;
var config int CivilianKilledRequired;

var config int PlayerIdentified;
var config int AlarmTriggered;
var config int BodyFound;

var config int BulletFired;
var config int MedkitUsed;
var config int LockPicked;

var config int LockDestroyed;
var config int LightDestroyed;
var config int ObjectDestroyed;
var config int NPCsInterrogated;

var float StealthRating;
var bool bMissionComplete;
var config bool bCheatsActive;

function ResetSessionStats()
{
    MissionTime = 0;
    MissionTimePart = 0;

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
    
    PlayerIdentified = 0;
    AlarmTriggered = 0;
    BodyFound = 0;

    BulletFired = 0;
    MedkitUsed = 0;
    LockPicked = 0;

    LockDestroyed = 0;
    LightDestroyed = 0;
    ObjectDestroyed = 0;
    NPCsInterrogated = 0;

    StealthRating = 100.0;
    bMissionComplete = false;
    bCheatsActive = false;
}

exec function SavePlayerStats()
{
	SaveConfig("Enhanced");
}

function PostBeginPlay()
{
    local string CurrentMap;
    local bool bReset;
    
    CurrentMap = GetCurrentMapName();
    bReset = false;
    
    // Joshua - Only reset stats if we're moving to a new mission
    if (MissionName != "")
    {
        bReset = ShouldResetStats(MissionName, CurrentMap);
    }
    
    if (bReset || MissionName == "")
    {
        ResetSessionStats();
    }
    
    MissionName = CurrentMap;
    MissionTime = MissionTimePart;

    CalculateStealthRating();
    SavePlayerStats();
    Enable('Tick');
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

function AddStat(string StatName, optional int Amount)
{
    if (bMissionComplete)
        return;

    if (Amount == 0)
        Amount = 1;
        
    switch(StatName)
    {
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
        case "PlayerIdentified":
            PlayerIdentified += Amount;
            break;
        case "AlarmTriggered":
            AlarmTriggered += Amount;
            break;
        case "BodyFound":
            BodyFound += Amount;
            break;
        case "BulletFired":
            BulletFired += Amount;
            break;
        case "MedkitUsed":
            MedkitUsed += Amount;
            break;
        case "LockPicked":
            LockPicked += Amount;
            break;
        case "LockDestroyed":
            LockDestroyed += Amount;
            break;
        case "LightDestroyed":
            LightDestroyed += Amount;
            break;
        case "ObjectDestroyed":
            ObjectDestroyed += Amount;
            break;
        case "NPCsInterrogated":
            NPCsInterrogated += Amount;
            break;
    }
    CalculateStealthRating();
}

function CalculateStealthRating()
{
    local float rating;
    rating = 100.0;
    
    rating -= float(LockDestroyed) * 2.0;

    rating -= float(EnemyKnockedOut) * 5.0;

    rating -= float(CivilianKnockedOut) * 5.0;

    rating -= float(EnemyKilled) * 15.0;

    rating -= float(CivilianKilled) * 30.0;

    rating -= float(AlarmTriggered) * 20.0;

    rating -= float(BodyFound) * 15.0;

    rating -= float(PlayerIdentified) * 15.0;

    /* Joshua - Allow Stealth Rating to go below 0 like Double Agent
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

function Tick(float DeltaTime)
{
    if (!bMissionComplete)
    {
        MissionTime += DeltaTime;
    }
}

function OnMissionComplete()
{
    bMissionComplete = true;
    //SavePlayerStats();
}

function OnLevelChange()
{
    MissionTimePart = MissionTime;
    SavePlayerStats();
}

defaultproperties
{
    bHidden=true
    bTravel=true
}
