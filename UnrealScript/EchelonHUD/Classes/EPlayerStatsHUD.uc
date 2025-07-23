/******************************************************************************

 Class:         EPlayerStatsHUD

 Description:   Player Statistics HUD

 Reference:     -

******************************************************************************/
class EPlayerStatsHUD extends Actor;

var EPlayerController Epc;

var color		TitleColor,
                SectionColor,
                TextColor;

var	EchelonGameInfo	 eGame;
var EchelonLevelInfo eLevel;

var bool        bStopDrawing;
var int         PlayerStatsAlpha;


/*-----------------------------------------------------------------------------
                            F U N C T I O N S
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
	Epc = EPlayerController(Owner.Owner);
    eGame  = EchelonGameInfo(Level.Game);
    eLevel = EchelonLevelInfo(Level);
	bStopDrawing = false;
    PlayerStatsAlpha = 200;
}

function bool KeyEvent( string Key, EInputAction Action, FLOAT Delta );

function PostRender(Canvas C)
{
    if (GetStateName() == 's_StandardDisplay' || GetStateName() == 's_MissionComplete' || GetStateName() == 's_FinalMapStats')
    {
        DrawPlayerStats(ECanvas(C));
    }
}

state s_StandardDisplay
{   
	function BeginState()
	{
        Epc.bStopInput = true;
    }

	function EndState()
	{
        if(!Epc.playerStats.bMissionComplete)
            Epc.bStopInput = false;
	}

    function Tick(float DeltaTime)
    {
        if (Epc != None && Epc.GetStateName() == 's_Dead')
        {
            GotoState('');
            Owner.GotoState(EchelonMainHud(Owner).RestoreState());
        }
    }
    
    function bool KeyEvent(string Key, EInputAction Action, float Delta)
    {
        if (Key == "PlayerStats")
        {
            if (Action == IST_Press || Action == IST_Hold)
            {
                // Keep the stats visible while key is pressed or held
                return true;
            }
            else if (Action == IST_Release)
            {
                // Hide the stats when key is released
                GotoState('');
                Owner.GotoState(EchelonMainHud(Owner).RestoreState());
            }
        }
        return false;
    }

    function PostRender(Canvas C)
	{
        local ECanvas Canvas;
        Canvas = ECanvas(C);

        DrawPlayerStats(Canvas);
    }
}

state s_MissionComplete
{
    function Tick(float DeltaTime)
    {
        if (Epc != None && Epc.GetStateName() == 's_Dead')
        {
            GotoState('');
            Owner.GotoState(EchelonMainHud(Owner).RestoreState());
        }
    }

    function PostRender(Canvas C)
	{
        local ECanvas Canvas;
        Canvas = ECanvas(C);

        DrawPlayerStats(Canvas);
    }
}

state s_FinalMapStats
{
    function BeginState()
    {
        Epc.bStopInput = true;
    }

    function Tick(float DeltaTime)
    {
        if (Epc != None && Epc.GetStateName() == 's_Dead')
        {
            GotoState('');
            Owner.GotoState(EchelonMainHud(Owner).RestoreState());
        }
    }

    function bool KeyEvent(string Key, EInputAction Action, float Delta)
    {
        if (Action == IST_Press || Action == IST_Hold)
        {
            switch(Key)
			{
                case "FullInventory" :
                case "PlayerStats" :
                case "Interaction" :
                case "Fire" :
                case "AltFire" :
                    GotoState('');
                    Owner.GotoState(EchelonMainHud(Owner).RestoreState());

                    Epc.bConfirmStats = true;
                    Epc.EndMission(true, 0);

                    return true;
                    break;
            }
        }
        return false;
    }

    function PostRender(Canvas C)
    {
        local ECanvas Canvas;
        Canvas = ECanvas(C);

        DrawPlayerStats(Canvas);
    }
}

function DrawPlayerStats(ECanvas Canvas)
{
    local int xPos, yPos, spacing, boxWidth, boxHeight;
    local int headerHeight, leftMargin;
    local string statString, DifficultyText;
    local EPlayerStats playerStats;
    local string timeString;
    local float xLen, yLen;
    local int topBarY;
                
    if (Epc == None || Epc.playerStats == None)
        return;
        
    playerStats = Epc.playerStats;
        
    Canvas.Font = Canvas.ETextFont;
    Canvas.TextSize("T", xLen, yLen);
    
    TitleColor.R = 96;
    TitleColor.G = 101;
    TitleColor.B = 79;
    TitleColor.A = PlayerStatsAlpha;
    
    TextColor.R = 180;
    TextColor.G = 180;
    TextColor.B = 180;
    TextColor.A = PlayerStatsAlpha;
    
    SectionColor.R = 75;
    SectionColor.G = 83;
    SectionColor.B = 60;
    SectionColor.A = PlayerStatsAlpha;
    
    // Position and layout
    spacing = yLen + 2;
    headerHeight = 28;
    leftMargin = 20;
    boxWidth = 480;
    boxHeight = 500;
    
    // Position box in center of screen
    xPos = (640 / 2) - (boxWidth / 2);
    yPos = (480 / 2) - (boxHeight / 2);
    
    // Draw the stat box with borders
    Canvas.Style = ERenderStyle.STY_Alpha;
    Canvas.SetDrawColor(128, 128, 128, PlayerStatsAlpha);
    
    // TOP LEFT CORNER
    Canvas.SetPos(xPos, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin2, 8, 4, 8, 4, -8, -4);

    // BOTTOM LEFT CORNER
    Canvas.SetPos(xPos, yPos + boxHeight - 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 0, 0, 8, 7);

    // TOP RIGHT CORNER
    Canvas.SetPos(xPos + boxWidth - 8, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin2, 8, 4, 0, 4, 8, -4);
    
    // BOTTOM RIGHT CORNER
    Canvas.SetPos(xPos + boxWidth - 8, yPos + boxHeight - 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 8, 0, -8, 7);

    // LEFT BORDER
    Canvas.SetPos(xPos, yPos + 4);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_v, 5, boxHeight - 11, 0, 0, 5, 1);
    
    // RIGHT BORDER
    Canvas.SetPos(xPos + boxWidth - 5, yPos + 4);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_v, 5, boxHeight - 11, 5, 0, -5, 1);
    
    // TOP BORDER
    Canvas.SetPos(xPos + 8, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_h2, boxWidth - 16, 4, 0, 0, 1, 4);

    // BOTTOM BORDER
    Canvas.SetPos(xPos + 8, yPos + boxHeight - 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_h, boxWidth - 16, 6, 0, 0, 1, 6);
    
    // Fill the background
    Canvas.DrawLine(xPos + 4, yPos + 4, boxWidth - 8, boxHeight - 8, Canvas.black, 200, eLevel.TGAME);
    Canvas.Style = ERenderStyle.STY_Normal;
    
    // Draw header with title background
    topBarY = yPos + 5;

    Canvas.Style = ERenderStyle.STY_Alpha;
    Canvas.SetPos(xPos + 5, topBarY);
    Canvas.SetDrawColor(30, 35, 30, PlayerStatsAlpha);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.int_selecteur, boxWidth - 10, headerHeight, 0, 0, 1, 1);
    Canvas.Style = ERenderStyle.STY_Normal;

    // Draw header text (vertically centered in bar)
    Canvas.SetDrawColor(TitleColor.R, TitleColor.G, TitleColor.B, TitleColor.A);
    Canvas.TextSize(Caps((Localize("PlayerStats", "MissionStatistics", "Localization\\Enhanced"))), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth / 2) - (xLen / 2), topBarY + 9);
    Canvas.DrawText(Caps((Localize("PlayerStats", "MissionStatistics", "Localization\\Enhanced"))));
    
    // Start position for stats
    yPos += headerHeight + spacing;
    
    // SECTION: Mission Information
    Canvas.SetDrawColor(SectionColor.R, SectionColor.G, SectionColor.B, SectionColor.A);
    Canvas.SetPos(xPos + 10, yPos);
    Canvas.DrawText(Localize("PlayerStats", "MissionInformation", "Localization\\Enhanced"));
    yPos += spacing;
    
    // Mission stats with white text
    Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);
    
    // Mission Name
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "Mission", "Localization\\Enhanced"));
    statString = Localize("PlayerStats", playerStats.MissionName, "Localization\\Enhanced");
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(statString);
    yPos += spacing;

    // Time Played
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "Time", "Localization\\Enhanced"));
    timeString = playerStats.GetFormattedPlayTime(playerStats.MissionTime);
    Canvas.TextSize(timeString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(timeString);
    yPos += spacing;
    
    // Difficulty
    switch(Epc.playerInfo.Difficulty)
    {
        case 0:
            if(Epc.ePawn.InitialHealth <= 200)
                DifficultyText = Localize("PlayerStats", "Normal", "Localization\\Enhanced");
            else
                DifficultyText = Localize("PlayerStats", "NormalXbox", "Localization\\Enhanced");
            break;
        case 1:
            if(Epc.ePawn.InitialHealth <= 132)
                DifficultyText = Localize("PlayerStats", "Hard", "Localization\\Enhanced");
            else
                DifficultyText = Localize("PlayerStats", "HardXbox", "Localization\\Enhanced");
            break;
        case 2:
            DifficultyText = Localize("PlayerStats", "Elite", "Localization\\Enhanced");
            break;
        case 3:
            if(Epc.ePawn.InitialHealth <= 132)
                DifficultyText = Localize("PlayerStats", "HardPermadeath", "Localization\\Enhanced");
            else
                DifficultyText = Localize("PlayerStats", "HardPermadeathXbox", "Localization\\Enhanced");
            break;
        case 4:
            DifficultyText = Localize("PlayerStats", "ElitePermadeath", "Localization\\Enhanced");
            break;
        default:
            DifficultyText = "Unknown (" $ Epc.playerInfo.Difficulty $ ")";
            break;
    }
    
    // Difficulty
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "Difficulty", "Localization\\Enhanced"));
    Canvas.TextSize(DifficultyText, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(DifficultyText);
    yPos += spacing * 1.5;
    
    // SECTION: Alert Statistics
    Canvas.SetDrawColor(SectionColor.R, SectionColor.G, SectionColor.B, SectionColor.A);
    Canvas.SetPos(xPos + 10, yPos);
    Canvas.DrawText(Localize("PlayerStats", "AlarmStatistics", "Localization\\Enhanced"));
    yPos += spacing;
    
    Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);

    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "PlayerIdentified", "Localization\\Enhanced"));
    Canvas.TextSize(playerStats.PlayerIdentified, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.PlayerIdentified);
    yPos += spacing;
    
    // Body Found stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "BodyFound", "Localization\\Enhanced"));
    Canvas.TextSize(playerStats.BodyFound, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.BodyFound);
    yPos += spacing;

    // Alarm Triggered stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "AlarmTriggered", "Localization\\Enhanced"));
    Canvas.TextSize(playerStats.AlarmTriggered, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.AlarmTriggered);
    yPos += spacing * 1.5;

    // SECTION: Enemy Statistics
    Canvas.SetDrawColor(SectionColor.R, SectionColor.G, SectionColor.B, SectionColor.A);
    Canvas.SetPos(xPos + 10, yPos);
    Canvas.DrawText(Localize("PlayerStats", "EnemyStatistics", "Localization\\Enhanced"));
    yPos += spacing;

    Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);

    // Enemy Knocked Out stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "EnemyKnockedOut", "Localization\\Enhanced"));
    statString = string(playerStats.EnemyKnockedOut + playerStats.EnemyKnockedOutRequired);
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(statString);
    yPos += spacing;

    // Enemy Injured stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "EnemyInjured", "Localization\\Enhanced"));
    Canvas.TextSize(playerStats.EnemyInjured, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.EnemyInjured);
    yPos += spacing;

    // Enemy Killed stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "EnemyKilled", "Localization\\Enhanced"));
    statString = string(playerStats.EnemyKilled + playerStats.EnemyKilledRequired);
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(statString);
    yPos += spacing * 1.5;

    // SECTION: Civilian Statistics
    Canvas.SetDrawColor(SectionColor.R, SectionColor.G, SectionColor.B, SectionColor.A);
    Canvas.SetPos(xPos + 10, yPos);
    Canvas.DrawText(Localize("PlayerStats", "CivilianStatistics", "Localization\\Enhanced"));
    yPos += spacing;

    Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);

    // Civilian Knocked Out stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "CivilianKnockedOut", "Localization\\Enhanced"));
    statString = string(playerStats.CivilianKnockedOut + playerStats.CivilianKnockedOutRequired);
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(statString);
    yPos += spacing;

    // Civilian Injured stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "CivilianInjured", "Localization\\Enhanced"));
    Canvas.TextSize(playerStats.CivilianInjured, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.CivilianInjured);
    yPos += spacing;

    // Civilian Killed stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "CivilianKilled", "Localization\\Enhanced"));
    statString = string(playerStats.CivilianKilled + playerStats.CivilianKilledRequired);
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(statString);
    yPos += spacing * 1.5;
    
    // SECTION: Miscellaneous Statistics
    Canvas.SetDrawColor(SectionColor.R, SectionColor.G, SectionColor.B, SectionColor.A);
    Canvas.SetPos(xPos + 10, yPos);
    Canvas.DrawText(Localize("PlayerStats", "MiscellaneousStatistics", "Localization\\Enhanced"));
    yPos += spacing;
    
    Canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B, TextColor.A);
    
    // Bullets Fired stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "BulletFired", "Localization\\Enhanced"));
    Canvas.TextSize(string(playerStats.BulletFired), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.BulletFired);
    yPos += spacing;

    // Lights Destroyed stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "LightDestroyed", "Localization\\Enhanced"));
    Canvas.TextSize(string(playerStats.LightDestroyed), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.LightDestroyed);
    yPos += spacing;

    // Objects Destroyed stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "ObjectDestroyed", "Localization\\Enhanced"));
    Canvas.TextSize(string(playerStats.ObjectDestroyed), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.ObjectDestroyed);
    yPos += spacing;

    // Locks Picked stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "LockPicked", "Localization\\Enhanced"));
    Canvas.TextSize(string(playerStats.LockPicked), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.LockPicked);
    yPos += spacing;

    // Locks Destroyed stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "LockDestroyed", "Localization\\Enhanced"));
    Canvas.TextSize(string(playerStats.LockDestroyed), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.LockDestroyed);
    yPos += spacing;

    // Medkits Used stats
    Canvas.SetPos(xPos + leftMargin, yPos);
    Canvas.DrawText(Localize("PlayerStats", "MedkitUsed", "Localization\\Enhanced"));
    Canvas.TextSize(string(playerStats.MedkitUsed), xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth * 0.60), yPos);
    Canvas.DrawText(playerStats.MedkitUsed);
    yPos += spacing * 1.5;

    Canvas.SetDrawColor(255, 50, 50, PlayerStatsAlpha);
    statString = Caps(Localize("PlayerStats", "CheatsActive", "Localization\\Enhanced"));
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth / 2) - (xLen / 2), yPos);
    if (Epc.playerStats.bCheatsActive)
        Canvas.DrawText(statString);
    yPos += spacing;
    
    // Stealth Rating bar
    Canvas.Style = ERenderStyle.STY_Alpha;
    Canvas.SetPos(xPos + 5, yPos);
    Canvas.SetDrawColor(30, 35, 30, PlayerStatsAlpha);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.int_selecteur, boxWidth - 10, headerHeight, 0, 0, 1, 1);
    Canvas.Style = ERenderStyle.STY_Normal;

    // Stealth Rating text
    Canvas.SetDrawColor(TitleColor.R, TitleColor.G, TitleColor.B, TitleColor.A);
    statString = Caps(Localize("PlayerStats", "StealthRating", "Localization\\Enhanced")) @ int(playerStats.StealthRating) $ "%";
    Canvas.TextSize(statString, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth / 2) - (xLen / 2), yPos + 2);
    Canvas.DrawText(statString);
    
    //Canvas.SetPos(xPos + leftMargin, yPos);
    //Canvas.DrawText(Localize("PlayerStats", "NPCsInterrogated", "Localization\\Enhanced") @ playerStats.NPCsInterrogated);
}

defaultproperties
{
    TextColor=(R=75,G=83,B=60,A=255)
    TitleColor=(R=96,G=101,B=79,A=255)
    SectionColor=(R=51,G=56,B=41,A=255)
    bAlwaysTick=true
    bHidden=true
}