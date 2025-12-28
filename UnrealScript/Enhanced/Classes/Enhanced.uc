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
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\ETGAME_PS2.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="ETGAME_PS2" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\ETGAME_Hor.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="ETGAME_Hor" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\ETGAME2_SCPT.dds" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="ETGAME2_SCPT" MIPS=0

// Alpha textures
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\ETMENU_PS2.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="ETMENU_PS2" MIPS=0
#exec Texture Import File="..\Textures\HUD_Enhanced\HUD\ETMENU_GameCube.tga" PACKAGE="HUD_Enhanced" GROUP="HUD" NAME="ETMENU_GameCube" MIPS=0

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

#exec Texture Import File="..\Textures\ETexCharacter\Elite\EliteAMesh.tga" PACKAGE="ETexCharacter" GROUP="Elite" NAME="EliteAMesh" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Elite\EliteANightvision.tga" PACKAGE="ETexCharacter" GROUP="Elite" NAME="EliteANightvision" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Elite\EliteB.dds" PACKAGE="ETexCharacter" GROUP="Elite" NAME="EliteB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\ERussianCivilian\ERussianCivilianA.dds" PACKAGE="ETexCharacter" GROUP="ERussianCivilian" NAME="ERussianCivilianA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\ERussianCivilian\ERussianCivilianB.dds" PACKAGE="ETexCharacter" GROUP="ERussianCivilian" NAME="ERussianCivilianB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\ERussianCivilian\ERussianCivilianC.dds" PACKAGE="ETexCharacter" GROUP="ERussianCivilian" NAME="ERussianCivilianC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\FakeSoldier\FakeSoldierA.dds" PACKAGE="ETexCharacter" GROUP="FakeSoldier" NAME="FakeSoldierA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\FakeSoldier\FakeSoldierB.dds" PACKAGE="ETexCharacter" GROUP="FakeSoldier" NAME="FakeSoldierB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\FakeSoldier\Ushanka.dds" PACKAGE="ETexCharacter" GROUP="FakeSoldier" NAME="Ushanka" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Feirong\Feirong.dds" PACKAGE="ETexCharacter" GROUP="Feirong" NAME="Feirong" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Feirong\FeirongHat.tga" PACKAGE="ETexCharacter" GROUP="Feirong" NAME="FeirongHat" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\FranceCoen\FranceCoen.dds" PACKAGE="ETexCharacter" GROUP="FranceCoen" NAME="FranceCoen" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\GEColonel\Colonel_redberet.tga" PACKAGE="ETexCharacter" GROUP="GEColonel" NAME="Colonel_redberet" MIPS=1
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

#exec Texture Import File="..\Textures\ETexCharacter\Grunt\GruntA.tga" PACKAGE="ETexCharacter" GROUP="Grunt" NAME="GruntA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Grunt\GruntB.tga" PACKAGE="ETexCharacter" GROUP="Grunt" NAME="GruntB" MIPS=1

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
#exec Texture Import File="..\Textures\ETexCharacter\model_FX\specDot.tga" PACKAGE="ETexCharacter" GROUP="model_FX" NAME="specDot" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\PalaceGuard\PalaceGuardA.dds" PACKAGE="ETexCharacter" GROUP="PalaceGuard" NAME="PalaceGuardA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\PalaceGuard\PalaceGuardAHat.tga" PACKAGE="ETexCharacter" GROUP="PalaceGuard" NAME="PalaceGuardAHat" MIPS=1
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

// Sam Suit A - Standard
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamABody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamABody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamAFace.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamAFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamAbodyHeat.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamAbodyHeat" MIPS=1
// Sam Suit B - Balaclava
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamBBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamBBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamBFace.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamBFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamStealthFace_heat.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamStealthFace_heat" MIPS=1
// Sam Suit C - Partial Sleeves
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamCBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamCBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamCbodyHeat.dds" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamCbodyHeat" MIPS=1
// Sam Cuit D - Green Vest
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamDFace.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamDFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamDBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamDBody" MIPS=1
// Sam Suit E - White Balaclava
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamEBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamEBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamEFace.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamEFace" MIPS=1
// Sam Suit F - Short Sleeves
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamFBody.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamFBody" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamFFace.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamFFace" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Sam\SamFBodyHeat.tga" PACKAGE="ETexCharacter" GROUP="Sam" NAME="SamFBodyHeat" MIPS=1


#exec Texture Import File="..\Textures\ETexCharacter\Security\SecurityA.dds" PACKAGE="ETexCharacter" GROUP="Security" NAME="SecurityA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Security\SecurityB.dds" PACKAGE="ETexCharacter" GROUP="Security" NAME="SecurityB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\SimarglCitizen\SimarglCitizen.dds" PACKAGE="ETexCharacter" GROUP="SimarglCitizen" NAME="SimarglCitizen" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Soldier\SoldierA.dds" PACKAGE="ETexCharacter" GROUP="Soldier" NAME="SoldierA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Soldier\SoldierB.dds" PACKAGE="ETexCharacter" GROUP="Soldier" NAME="SoldierB" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\Soldier\SoldierC.dds" PACKAGE="ETexCharacter" GROUP="Soldier" NAME="SoldierC" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\headset.tga" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="headset" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\headset_glw.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="headset_glw" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\SpetsnazA.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="SpetsnazA" MIPS=1
#exec Texture Import File="..\Textures\ETexCharacter\spetsnaz\SpetsnazB.dds" PACKAGE="ETexCharacter" GROUP="spetsnaz" NAME="SpetsnazB" MIPS=1

#exec Texture Import File="..\Textures\ETexCharacter\Wilkes\Wilkes.dds" PACKAGE="ETexCharacter" GROUP="Wilkes" NAME="Wilkes" MIPS=1

#exec SAVEPACKAGE FILE=..\Textures\ETexCharacter.utx PACKAGE=ETexCharacter
*/

//=============================================================================
// ETexIngredient.utx
//=============================================================================

// Joshua - Uncomment to generate a new ETexIngredient.utx with modified or new textures
// Textures must be extracted into Textures\ETexIngredient
/*
#exec OBJ LOAD FILE=..\Textures\ETexIngredient.utx PACKAGE=ETexIngredient

#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\keypaddigit.tga" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="keypaddigit" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\KeyPadTech\keypad02.tga" PACKAGE="ETexIngredient" GROUP="KeyPadTech" NAME="keypad02" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Weapons\ak47.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="ak47" MIPS=1

// New AK-47 texture for Grinko
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\ak47_Grinko.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="ak47_Grinko" MIPS=1

// Alpha textures
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Echelon AK107.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Echelon AK107" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\EchelonQBZType95.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="EchelonQBZType95" MIPS=1

#exec Texture Import File="..\Textures\ETexIngredient\Weapons\F2000_MF.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="F2000_MF" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\FN7.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="FN7" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Makarov.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Makarov" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\map_dragunova.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="map_dragunova" MIPS=1

// Alpha textures
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Mk23.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Mk23" MIPS=1
#exec Texture Import File="..\Textures\ETexIngredient\Weapons\P228.tga" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="P228" MIPS=1
//#exec Texture Import File="..\Textures\ETexIngredient\Weapons\Uzi.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="Uzi" MIPS=1
//#exec Texture Import File="..\Textures\ETexIngredient\Weapons\SPAS01.dds" PACKAGE="ETexIngredient" GROUP="Weapons" NAME="SPAS01" MIPS=1

#exec SAVEPACKAGE FILE=..\Textures\ETexIngredient.utx PACKAGE=ETexIngredient
*/