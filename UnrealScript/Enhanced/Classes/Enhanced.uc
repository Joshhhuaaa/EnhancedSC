//=============================================================================
// Enhanced
//
// #exec statements for the Enhanced patch.
//=============================================================================
class Enhanced extends Actor;

//=============================================================================
// HUD_Enhanced.utx
//=============================================================================

// Joshua - Uncomment to generate a new HUD_Enhanced.utx with modified or new textures
// Textures must be extracted into Textures\HUD_Enhanced
/*
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\PS2_Cross.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="PS2_Cross" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\GameCube_A.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="GameCube_A" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\Alarm.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="Alarm" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\AlarmBackground.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="AlarmBackground" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\Discord.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="Discord" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\Discord_dis.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="Discord_dis" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\QR_Discord.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="QR_Discord" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\QR_GitHub.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="QR_GitHub" MIPS=0

#exec SAVEPACKAGE FILE=..\Textures\HUD_Enhanced.utx PACKAGE=HUD_Enhanced
*/

//=============================================================================
// ETexCharacter.utx
//=============================================================================

// Joshua - Uncomment to generate a new ETexCharacter.utx with modified or new textures
// Textures must be extracted into Textures\ETexCharacter
/*
#exec OBJ LOAD FILE=..\Textures\ETexCharacter.utx PACKAGE=ETexCharacter

#exec Texture Import File="..\Textures\ETexCharacter\Agent\AgentA.dds" PACKAGE="ETexCharacter" GROUP="Agent" NAME="AgentA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Agent\AgentB.dds" PACKAGE="ETexCharacter" GROUP="Agent" NAME="AgentB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Alekseevich\Alekseevich.dds" PACKAGE="ETexCharacter" GROUP="Alekseevich" NAME="Alekseevich" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Alekseevich\Alekseevich_hat.dds" PACKAGE="ETexCharacter" GROUP="Alekseevich" NAME="Alekseevich_hat" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Anna\Accessories.dds" PACKAGE="ETexCharacter" GROUP="Anna" NAME="Accessories" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Anna\Anna.dds" PACKAGE="ETexCharacter" GROUP="Anna" NAME="Anna" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Baxter\Baxter.dds" PACKAGE="ETexCharacter" GROUP="Baxter" NAME="Baxter" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Bird\Bird.dds" PACKAGE="ETexCharacter" GROUP="Bird" NAME="Bird" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\bobrov\BobrovBody.dds" PACKAGE="ETexCharacter" GROUP="bobrov" NAME="BobrovBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\bobrov\bobrovFace.dds" PACKAGE="ETexCharacter" GROUP="bobrov" NAME="bobrovFace" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Bureaucrat\BureaucratA.dds" PACKAGE="ETexCharacter" GROUP="Bureaucrat" NAME="BureaucratA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Bureaucrat\BureaucratB.dds" PACKAGE="ETexCharacter" GROUP="Bureaucrat" NAME="BureaucratB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Bureaucrat\bureaucratC.dds" PACKAGE="ETexCharacter" GROUP="Bureaucrat" NAME="bureaucratC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\BurFem\BurFemA.dds" PACKAGE="ETexCharacter" GROUP="BurFem" NAME="BurFemA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\BurFem\BurFemB.dds" PACKAGE="ETexCharacter" GROUP="BurFem" NAME="BurFemB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\BurFem\BurFemC.dds" PACKAGE="ETexCharacter" GROUP="BurFem" NAME="BurFemC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\BurnBody\BurnBody.dds" PACKAGE="ETexCharacter" GROUP="BurnBody" NAME="BurnBody" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\ChineseColonel\ChineseColonel.dds" PACKAGE="ETexCharacter" GROUP="ChineseColonel" NAME="ChineseColonel" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\CIAmaintenance\CIAmaintenance.dds" PACKAGE="ETexCharacter" GROUP="CIAmaintenance" NAME="CIAmaintenance" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\CONTACT\ContactA.dds" PACKAGE="ETexCharacter" GROUP="CONTACT" NAME="ContactA" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Cook\CookA.dds" PACKAGE="ETexCharacter" GROUP="Cook" NAME="CookA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Cook\CookB.dds" PACKAGE="ETexCharacter" GROUP="Cook" NAME="CookB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Cristavi\Cristavi.dds" PACKAGE="ETexCharacter" GROUP="Cristavi" NAME="Cristavi" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Dignitary\ChineseDignitaryF.dds" PACKAGE="ETexCharacter" GROUP="Dignitary" NAME="ChineseDignitaryF" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Dignitary\DignitaryA.dds" PACKAGE="ETexCharacter" GROUP="Dignitary" NAME="DignitaryA" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Dogs\Doberman.dds" PACKAGE="ETexCharacter" GROUP="Dogs" NAME="Doberman" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Dogs\Rottweiler.dds" PACKAGE="ETexCharacter" GROUP="Dogs" NAME="Rottweiler" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Elite\EliteAMesh.dds" PACKAGE="ETexCharacter" GROUP="Elite" NAME="EliteAMesh" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Elite\EliteANightvision.dds" PACKAGE="ETexCharacter" GROUP="Elite" NAME="EliteANightvision" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Elite\EliteB.dds" PACKAGE="ETexCharacter" GROUP="Elite" NAME="EliteB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\ERussianCivilian\ERussianCivilianA.dds" PACKAGE="ETexCharacter" GROUP="ERussianCivilian" NAME="ERussianCivilianA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\ERussianCivilian\ERussianCivilianB.dds" PACKAGE="ETexCharacter" GROUP="ERussianCivilian" NAME="ERussianCivilianB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\ERussianCivilian\ERussianCivilianC.dds" PACKAGE="ETexCharacter" GROUP="ERussianCivilian" NAME="ERussianCivilianC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\FakeSoldier\FakeSoldierA.dds" PACKAGE="ETexCharacter" GROUP="FakeSoldier" NAME="FakeSoldierA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\FakeSoldier\FakeSoldierB.dds" PACKAGE="ETexCharacter" GROUP="FakeSoldier" NAME="FakeSoldierB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\FakeSoldier\Ushanka.dds" PACKAGE="ETexCharacter" GROUP="FakeSoldier" NAME="Ushanka" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Feirong\Feirong.dds" PACKAGE="ETexCharacter" GROUP="Feirong" NAME="Feirong" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Feirong\FeirongHat.dds" PACKAGE="ETexCharacter" GROUP="Feirong" NAME="FeirongHat" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\FranceCoen\FranceCoen.dds" PACKAGE="ETexCharacter" GROUP="FranceCoen" NAME="FranceCoen" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\GEColonel\Colonel_redberet.dds" PACKAGE="ETexCharacter" GROUP="GEColonel" NAME="Colonel_redberet" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\GEColonel\GEColonel.dds" PACKAGE="ETexCharacter" GROUP="GEColonel" NAME="GEColonel" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\GEColonel\GEColonel_winter.dds" PACKAGE="ETexCharacter" GROUP="GEColonel" NAME="GEColonel_winter" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\GEPolice\GEPoliceA.dds" PACKAGE="ETexCharacter" GROUP="GEPolice" NAME="GEPoliceA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\GEPolice\GEPoliceB.dds" PACKAGE="ETexCharacter" GROUP="GEPolice" NAME="GEPoliceB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\GEPrisoner\GEPrisoner.dds" PACKAGE="ETexCharacter" GROUP="GEPrisoner" NAME="GEPrisoner" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\GESoldier\GESoldierA.dds" PACKAGE="ETexCharacter" GROUP="GESoldier" NAME="GESoldierA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\GESoldier\GESoldierB.dds" PACKAGE="ETexCharacter" GROUP="GESoldier" NAME="GESoldierB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\GESoldier\GESoldierCap.dds" PACKAGE="ETexCharacter" GROUP="GESoldier" NAME="GESoldierCap" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\glasses\glasses3.dds" PACKAGE="ETexCharacter" GROUP="glasses" NAME="glasses3" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Grinko\Grinko.dds" PACKAGE="ETexCharacter" GROUP="Grinko" NAME="Grinko" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Grunt\GruntA.dds" PACKAGE="ETexCharacter" GROUP="Grunt" NAME="GruntA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Grunt\GruntB.dds" PACKAGE="ETexCharacter" GROUP="Grunt" NAME="GruntB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Hamlet\Hamlet.dds" PACKAGE="ETexCharacter" GROUP="Hamlet" NAME="Hamlet" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Ivan\cell.dds" PACKAGE="ETexCharacter" GROUP="Ivan" NAME="cell" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Ivan\Ivan.dds" PACKAGE="ETexCharacter" GROUP="Ivan" NAME="Ivan" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Kombayn\Kombayn.dds" PACKAGE="ETexCharacter" GROUP="Kombayn" NAME="Kombayn" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Lambert\Lambert.dds" PACKAGE="ETexCharacter" GROUP="Lambert" NAME="Lambert" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\LongDan\LongDan.dds" PACKAGE="ETexCharacter" GROUP="LongDan" NAME="LongDan" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Mafia\KnitCapA.dds" PACKAGE="ETexCharacter" GROUP="Mafia" NAME="KnitCapA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Mafia\MafiaA.dds" PACKAGE="ETexCharacter" GROUP="Mafia" NAME="MafiaA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Mafia\MafiaB.dds" PACKAGE="ETexCharacter" GROUP="Mafia" NAME="MafiaB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Masse\Masse.dds" PACKAGE="ETexCharacter" GROUP="Masse" NAME="Masse" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Masse\masseglasses.dds" PACKAGE="ETexCharacter" GROUP="Masse" NAME="masseglasses" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\MercTech\Cap.dds" PACKAGE="ETexCharacter" GROUP="MercTech" NAME="Cap" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\MercTech\MercTechA.dds" PACKAGE="ETexCharacter" GROUP="MercTech" NAME="MercTechA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\MercTech\MercTechB.dds" PACKAGE="ETexCharacter" GROUP="MercTech" NAME="MercTechB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Miner\MinerABody.dds" PACKAGE="ETexCharacter" GROUP="Miner" NAME="MinerABody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Miner\MinerAFace.dds" PACKAGE="ETexCharacter" GROUP="Miner" NAME="MinerAFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Miner\MinerAhardhat.dds" PACKAGE="ETexCharacter" GROUP="Miner" NAME="MinerAhardhat" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Miner\MinerBBody.dds" PACKAGE="ETexCharacter" GROUP="Miner" NAME="MinerBBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Miner\MinerBFace.dds" PACKAGE="ETexCharacter" GROUP="Miner" NAME="MinerBFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Miner\MinerBhardhat.dds" PACKAGE="ETexCharacter" GROUP="Miner" NAME="MinerBhardhat" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Mitch\Mitch.dds" PACKAGE="ETexCharacter" GROUP="Mitch" NAME="Mitch" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\model_FX\Black.dds" PACKAGE="ETexCharacter" GROUP="model_FX" NAME="Black" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\model_FX\specDot.dds" PACKAGE="ETexCharacter" GROUP="model_FX" NAME="specDot" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\PalaceGuard\PalaceGuardA.dds" PACKAGE="ETexCharacter" GROUP="PalaceGuard" NAME="PalaceGuardA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\PalaceGuard\PalaceGuardAHat.dds" PACKAGE="ETexCharacter" GROUP="PalaceGuard" NAME="PalaceGuardAHat" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\PalaceGuard\PalaceGuardB.dds" PACKAGE="ETexCharacter" GROUP="PalaceGuard" NAME="PalaceGuardB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Pietr\Pietr.dds" PACKAGE="ETexCharacter" GROUP="Pietr" NAME="Pietr" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\PowerPlant\Hardhat.dds" PACKAGE="ETexCharacter" GROUP="PowerPlant" NAME="Hardhat" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\PowerPlant\PowerPlantA.dds" PACKAGE="ETexCharacter" GROUP="PowerPlant" NAME="PowerPlantA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\PowerPlant\PowerPlantB.dds" PACKAGE="ETexCharacter" GROUP="PowerPlant" NAME="PowerPlantB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\PowerPlant\PowerPlantC.dds" PACKAGE="ETexCharacter" GROUP="PowerPlant" NAME="PowerPlantC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Prisoner\PrisonerA.dds" PACKAGE="ETexCharacter" GROUP="Prisoner" NAME="PrisonerA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Prisoner\PrisonerB.dds" PACKAGE="ETexCharacter" GROUP="Prisoner" NAME="PrisonerB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Prisoner\PrisonerC.dds" PACKAGE="ETexCharacter" GROUP="Prisoner" NAME="PrisonerC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\RAT\RAT.dds" PACKAGE="ETexCharacter" GROUP="RAT" NAME="RAT" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Renegade\Renegade_Cap.dds" PACKAGE="ETexCharacter" GROUP="Renegade" NAME="Renegade_Cap" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Renegade\RenegadeA.dds" PACKAGE="ETexCharacter" GROUP="Renegade" NAME="RenegadeA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Renegade\RenegadeB.dds" PACKAGE="ETexCharacter" GROUP="Renegade" NAME="RenegadeB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Rookie\RookieA.dds" PACKAGE="ETexCharacter" GROUP="Rookie" NAME="RookieA" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamABody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamABody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamAbodyHeat.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamAbodyHeat" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamAFace.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamAFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamBBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamBBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamBFace.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamBFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamCBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamCBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamCbodyHeat.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamCbodyHeat" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamStealthFace_heat.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamStealthFace_heat" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Security\SecurityA.dds" PACKAGE="ETexCharacter" GROUP="Security" NAME="SecurityA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Security\SecurityB.dds" PACKAGE="ETexCharacter" GROUP="Security" NAME="SecurityB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\SimarglCitizen\SimarglCitizen.dds" PACKAGE="ETexCharacter" GROUP="SimarglCitizen" NAME="SimarglCitizen" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Soldier\SoldierA.dds" PACKAGE="ETexCharacter" GROUP="Soldier" NAME="SoldierA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Soldier\SoldierB.dds" PACKAGE="ETexCharacter" GROUP="Soldier" NAME="SoldierB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Soldier\SoldierC.dds" PACKAGE="ETexCharacter" GROUP="Soldier" NAME="SoldierC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\headset.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="headset" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\headset_glw.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="headset_glw" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\SpetsnazA.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="SpetsnazA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\SpetsnazB.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="SpetsnazB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Wilkes\Wilkes.dds" PACKAGE="ETexCharacter" GROUP="Wilkes" NAME="Wilkes" MIPS=1

#exec SAVEPACKAGE FILE=..\Textures\ETexCharacter.utx PACKAGE=ETexCharacter
*/

//=============================================================================
// HUD.utx
//=============================================================================

// Joshua - Uncomment to generate a new HUD.utx with modified or new textures
// Textures must be extracted into Textures\HUD
/*
#exec OBJ LOAD FILE=..\Textures\HUD.utx PACKAGE=HUD

#exec Texture Import File="..\Textures\HUD\HUD\EAX.tga" PACKAGE="HUD" GROUP="HUD" NAME="EAX" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\eax_dis.tga" PACKAGE="HUD" GROUP="HUD" NAME="eax_dis" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\ETGAME.dds" PACKAGE="HUD" GROUP="HUD" NAME="ETGAME" MIPS=1
//#exec Texture Import File="..\Textures\HUD\HUD\ETGAME_PSX2.dds" PACKAGE="HUD" GROUP="HUD" NAME="ETGAME_PSX2" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\ETICON.dds" PACKAGE="HUD" GROUP="HUD" NAME="ETICON" MIPS=1
//#exec Texture Import File="..\Textures\HUD\HUD\ETICON_PSX2.dds" PACKAGE="HUD" GROUP="HUD" NAME="ETICON_PSX2" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\ETMENU.tga" PACKAGE="HUD" GROUP="HUD" NAME="ETMENU" MIPS=1
//#exec Texture Import File="..\Textures\HUD\HUD\ETMENU_PSX2.tga" PACKAGE="HUD" GROUP="HUD" NAME="ETMENU_PSX2" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\ETMenuBar.tga" PACKAGE="HUD" GROUP="HUD" NAME="ETMenuBar" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\ETPixel.dds" PACKAGE="HUD" GROUP="HUD" NAME="ETPixel" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\logo.dds" PACKAGE="HUD" GROUP="HUD" NAME="logo" MIPS=1
#exec Texture Import File="..\Textures\HUD\HUD\palm_bkg.tga" PACKAGE="HUD" GROUP="HUD" NAME="palm_bkg" MIPS=1

#exec Texture Import File="..\Textures\HUD\InventoryItems\rs_animvideo.tga" PACKAGE="HUD" GROUP="InventoryItems" NAME="rs_animvideo" MIPS=1
#exec Texture Import File="..\Textures\HUD\InventoryItems\rs_scan1.tga" PACKAGE="HUD" GROUP="InventoryItems" NAME="rs_scan1" MIPS=1

#exec Texture Import File="..\Textures\HUD\Recon\rc_1_1_maptibilisi.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_1_maptibilisi" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_2_grinko.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_2_grinko" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_2_masse.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_2_masse" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_2_MinistryMap2.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_2_MinistryMap2" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_3_AuxiliaryPetroleumReservoir.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_3_AuxiliaryPetroleumReservoir" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_3_CrudeOilFlowRegulator.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_3_CrudeOilFlowRegulator" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_3_industrialwaterpump.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_3_industrialwaterpump" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_1_3_SecondaryCrudeOilCircuitPump.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_1_3_SecondaryCrudeOilCircuitPump" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_2_1_CIA1.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_2_1_CIA1" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_2_1_CIA2.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_2_1_CIA2" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_2_1_doughert.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_2_1_doughert" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_2_1_jackbaxter.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_2_1_jackbaxter" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_2_2_ivan.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_2_2_ivan" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_2_2_mapkalinatek.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_2_2_mapkalinatek" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_3_2_coolingroom.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_3_2_coolingroom" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_3_4_alekseevich.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_3_4_alekseevich" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_4_1map.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_4_1map" MIPS=1
#exec Texture Import File="..\Textures\HUD\Recon\rc_5_1_critavi.dds" PACKAGE="HUD" GROUP="Recon" NAME="rc_5_1_critavi" MIPS=1

#exec SAVEPACKAGE FILE=..\Textures\HUD.utx PACKAGE=HUD
*/

//=============================================================================
// ETexIngredient.utx
//=============================================================================

// Joshua - Uncomment to generate a new ETexIngredient.utx with modified or new textures
// Textures must be extracted into Textures\ETexIngredient
/*
#exec OBJ LOAD FILE=..\Textures\ETexIngredient.utx PACKAGE=ETexIngredient

#exec Texture Import File="..\Textures\ETexIngredient\fish\Kalifish.dds" PACKAGE="ETexIngredient" GROUP="fish" NAME="Kalifish" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\fish\moth.dds" PACKAGE="ETexIngredient" GROUP="fish" NAME="moth" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\fish\moth2.dds" PACKAGE="ETexIngredient" GROUP="fish" NAME="moth2" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\furniture\ceillingfan.dds" PACKAGE="ETexIngredient" GROUP="furniture" NAME="ceillingfan" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\furniture\Chair.dds" PACKAGE="ETexIngredient" GROUP="furniture" NAME="Chair" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_0.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_0" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_1.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_1" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_2.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_3.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_3" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_4.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_4" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_5.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_5" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_6.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_6" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_7.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_7" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_8.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_8" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_9.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_9" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_fingerPrints.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_fingerPrints" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_num.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_num" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\Key_Star.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="Key_Star" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\keypad02.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="keypad02" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\keypad02glow.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="keypad02glow" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\keypaddigit.dds" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="keypaddigit" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Obj_Kalinatek\breaker_kal.dds" PACKAGE="ETexIngredient" GROUP="Obj_Kalinatek" NAME="breaker_kal" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Obj_Kalinatek\LGTswitchUS.dds" PACKAGE="ETexIngredient" GROUP="Obj_Kalinatek" NAME="LGTswitchUS" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Obj_Kalinatek\tv_kal.dds" PACKAGE="ETexIngredient" GROUP="Obj_Kalinatek" NAME="tv_kal" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Obj_Kalinatek\tv_kalb2.dds" PACKAGE="ETexIngredient" GROUP="Obj_Kalinatek" NAME="tv_kalb2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Obj_Kalinatek\tv_kalbINT.dds" PACKAGE="ETexIngredient" GROUP="Obj_Kalinatek" NAME="tv_kalbINT" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Obj_MiningTown\Breaker_box_Mine.dds" PACKAGE="ETexIngredient" GROUP="Obj_MiningTown" NAME="Breaker_box_Mine" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Obj_MiningTown\Breaker_box_MineB1.dds" PACKAGE="ETexIngredient" GROUP="Obj_MiningTown" NAME="Breaker_box_MineB1" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Obj_MiningTown\Breaker_box_MineB2.dds" PACKAGE="ETexIngredient" GROUP="Obj_MiningTown" NAME="Breaker_box_MineB2" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Object\AlarmBox2.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="AlarmBox2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\bomb01_kal.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="bomb01_kal" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\bomb02_kal.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="bomb02_kal" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\bomb03_kal.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="bomb03_kal" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\bullet_5-7.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="bullet_5-7" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\bullet_f-2000.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="bullet_f-2000" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Cam_jammer.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Cam_jammer" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Camera.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Camera" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\camera_red.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="camera_red" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\camera_red2.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="camera_red2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\camera_unbrake.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="camera_unbrake" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\camera_unbroke.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="camera_unbroke" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Camera02.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Camera02" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\CIA_fanblade.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="CIA_fanblade" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\CONTAINERb.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="CONTAINERb" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\dome_window.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="dome_window" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\dome_windowB.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="dome_windowB" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\elec_hw.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="elec_hw" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\elevatorpanel2_v2.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="elevatorpanel2_v2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Flare01.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Flare01" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\flarepack.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="flarepack" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\GrenadeBox.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="GrenadeBox" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\hardcase_kal01.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="hardcase_kal01" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\HealthKit02.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="HealthKit02" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\led.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="led" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\light_sensor.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="light_sensor" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\mapscan.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="mapscan" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\memstick.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="memstick" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Metal_detect.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Metal_detect" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\portGenerator1.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="portGenerator1" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\portGenerator2.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="portGenerator2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\portGenerator3.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="portGenerator3" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Pouch.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Pouch" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\Rope.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="Rope" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\safe_PAL.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="safe_PAL" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\sensorlight.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="sensorlight" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\shaflight.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="shaflight" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\shaflight_front.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="shaflight_front" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\stick.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="stick" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\stickky_cam.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="stickky_cam" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\vent_exit.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="vent_exit" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\wallmine.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="wallmine" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\wallmineGreen.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="wallmineGreen" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Object\wallmineRED.dds" PACKAGE="ETexIngredient" GROUP="Object" NAME="wallmineRED" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\PickLock\lock2.dds" PACKAGE="ETexIngredient" GROUP="PickLock" NAME="lock2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\PickLock\LockPick.dds" PACKAGE="ETexIngredient" GROUP="PickLock" NAME="LockPick" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Turrets\transpac.dds" PACKAGE="ETexIngredient" GROUP="Turrets" NAME="transpac" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Turrets\Turret.dds" PACKAGE="ETexIngredient" GROUP="Turrets" NAME="Turret" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Turrets\valise02.dds" PACKAGE="ETexIngredient" GROUP="Turrets" NAME="valise02" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\LADA.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="LADA" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\Limo_MYA.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="Limo_MYA" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\Limo2_MYA.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="Limo2_MYA" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\Osprey.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="Osprey" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\OSPREY2.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="OSPREY2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\tire.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="tire" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\truck_cab_chi.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="truck_cab_chi" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\truck_loader01_chi.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="truck_loader01_chi" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\truck_logo_chi.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="truck_logo_chi" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\truck_tire_chi.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="truck_tire_chi" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\v2inside.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="v2inside" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\Van_02.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="Van_02" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\VAN2.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="VAN2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Vehicle\zodiac.dds" PACKAGE="ETexIngredient" GROUP="Vehicle" NAME="zodiac" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Weapons\ak47.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="ak47" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Berreta02.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Berreta02" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Conc_gren.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Conc_gren" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\CZ61.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="CZ61" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Echelon AK107.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Echelon AK107" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\EchelonQBZType95.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="EchelonQBZType95" MIPS=1
//#exec Texture Import File="..\Textures\ETexIngredient\Weapons\F2000_MF.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="F2000_MF" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\F2000_MF.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="F2000_MF" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\FN7.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="FN7" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\foam_grenade.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="foam_grenade" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Grenade.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Grenade" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\M16A2.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="M16A2" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\MainGun.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="MainGun" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Makarov.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Makarov" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\map_dragunova.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="map_dragunova" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Mk23.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Mk23" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Mp5A4.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Mp5A4" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\P228.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="P228" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\redflare.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="redflare" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\shell01.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="shell01" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\shell02.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="shell02" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\SPAS01.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="SPAS01" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\stycky_shock.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="stycky_shock" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\tracer.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="tracer" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Uzi.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Uzi" MIPS=1

#exec SAVEPACKAGE FILE=..\Textures\ETexIngredient.utx PACKAGE=ETexIngredient
*/
