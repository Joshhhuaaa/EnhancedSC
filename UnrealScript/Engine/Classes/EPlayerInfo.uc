//=============================================================================
// EPlayerInfo.
//=============================================================================
class EPlayerInfo extends Actor 
	  //config(SplinterCellUser)
      config(Enhanced) // Joshua - Class, configurable in Enhanced config
	  native;

/*-----------------------------------------------------------------------------
                      T Y P E   D E F I N I T I O N S 
-----------------------------------------------------------------------------*/
//struct SaveGameInfo
//{
//	var String	Name;
//    var String	Date;
//    var String	Time;
//	var Texture	ScreenShot;
//};

/*-----------------------------------------------------------------------------
                   I N S T A N C E   V A R I A B L E S
-----------------------------------------------------------------------------*/
var config string PlayerName;
var config int    ControllerScheme;
var config int    Difficulty; 
var config string GameSave[3];
var config string GameSaveRealMap[3];
var config int    MapCompleted;
var config string UnlockedMap[14];
var config bool   bDownloadableMapsExists;
var config string GamePath;
var config int    PosX;
var config int    PosY;
var config int    MusicVol;
var config int    VoiceVol;
var config int    SfxVol;
var config int    AmbVol;
var config int    iLastSaveType;
var config bool   bValidProfile;

// Joshua - New variable for mission unlocks
enum ELevelUnlock
{
  LU_Disabled, // Use the profile's progression
  LU_Enabled, // Unlock all levels
  LU_AllParts // Unlock all levels and their parts
};
var config ELevelUnlock LevelUnlock;

exec function SaveEnhancedOptions()
{
	SaveConfig("Enhanced");
}

defaultproperties
{
    // Joshua - Adding UnlockedMap properties, previously set in SplinterCellUser.ini (not sure if needed)
    UnlockedMap(0)="0_0_2_Training"
    UnlockedMap(1)="1_1_0Tbilisi"
    UnlockedMap(2)="1_2_1DefenseMinistry"
    UnlockedMap(3)="1_3_2CaspianOilRefinery"
    UnlockedMap(4)="2_1_0CIA"
    UnlockedMap(5)="2_2_1_Kalinatek"
    UnlockedMap(6)="4_1_1ChineseEmbassy"
    UnlockedMap(7)="4_2_1_Abattoir"
    UnlockedMap(8)="4_3_0ChineseEmbassy"
    UnlockedMap(9)="5_1_1_PresidentialPalace"
    UnlockedMap(10)="1_6_1_1KolaCell"
    UnlockedMap(11)="1_7_1_1VselkaInfiltration"
    UnlockedMap(12)="1_7_1_2Vselka"
    bHidden=true
    LevelUnlock=LU_Disabled
}