//=============================================================================
//
// class EAINonHostile
//
// intended specifically for Professional-related Animation Setup
//
//=============================================================================

class EAINonHostile extends EAIPawn;


#exec OBJ LOAD FILE=..\textures\ETexCharacter.utx
#exec OBJ LOAD FILE=..\StaticMeshes\generic_obj.usx


//
//
//	Perform all #exec setup on all Non Hostile meshes and Male.PSA Animations
//	Save UKX when finished.
//
//

#exec OBJ LOAD FILE=..\Animations\ENPC.ukx PACKAGE=ENPC

//
// Add the lipsynch LBP data here.
//
#exec MESH LIPSYNCHBONES MESH=BobrovMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GrinkoMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=HamletMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=KombaynMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=BaxterMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MinerAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MinerBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=BureaucratAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=DignitaryAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MitchMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MasseMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=WilkesMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=CookAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=CookBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=ERussianCivilianCMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=AlekseevichMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=CIAmaintenanceMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=ContactAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=ERussianCivilianAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=ERussianCivilianBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=FeirongMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=Grunt FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=IvanMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=LambertMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=LongDanMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MercTechAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MercTechBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MinerAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=PietrMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=PowerPlantAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=PowerPlantCMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=CristaviMesh FILE=..\lipsynch\npc.lbp


//
//
//  Attachments
//	
//


#exec MESH CLEARATTACHTAGS	MESH=BobrovMesh
#exec MESH CLEARATTACHTAGS	MESH=GrinkoMesh
#exec MESH CLEARATTACHTAGS	MESH=HamletMesh
#exec MESH CLEARATTACHTAGS	MESH=KombaynMesh
#exec MESH CLEARATTACHTAGS	MESH=BaxterMesh
#exec MESH CLEARATTACHTAGS	MESH=MinerAMesh
#exec MESH CLEARATTACHTAGS	MESH=MinerBMesh
#exec MESH CLEARATTACHTAGS	MESH=BureaucratAMesh
#exec MESH CLEARATTACHTAGS	MESH=DignitaryAMesh
#exec MESH CLEARATTACHTAGS	MESH=MitchMesh
#exec MESH CLEARATTACHTAGS	MESH=MasseMesh
#exec MESH CLEARATTACHTAGS	MESH=WilkesMesh
#exec MESH CLEARATTACHTAGS	MESH=CookAMesh
#exec MESH CLEARATTACHTAGS	MESH=CookBMesh
#exec MESH CLEARATTACHTAGS	MESH=ERussianCivilianCMesh
#exec MESH CLEARATTACHTAGS	MESH=AlekseevichMesh
#exec MESH CLEARATTACHTAGS	MESH=CIAmaintenanceMesh
#exec MESH CLEARATTACHTAGS	MESH=ContactAMesh
#exec MESH CLEARATTACHTAGS	MESH=ERussianCivilianAMesh
#exec MESH CLEARATTACHTAGS	MESH=ERussianCivilianBMesh
#exec MESH CLEARATTACHTAGS	MESH=FeirongMesh
#exec MESH CLEARATTACHTAGS	MESH=Grunt
#exec MESH CLEARATTACHTAGS	MESH=IvanMesh
#exec MESH CLEARATTACHTAGS	MESH=LambertMesh
#exec MESH CLEARATTACHTAGS	MESH=LongDanMesh
#exec MESH CLEARATTACHTAGS	MESH=MercTechAMesh
#exec MESH CLEARATTACHTAGS	MESH=MercTechBMesh
#exec MESH CLEARATTACHTAGS	MESH=MinerAMesh
#exec MESH CLEARATTACHTAGS	MESH=PietrMesh
#exec MESH CLEARATTACHTAGS	MESH=PowerPlantAMesh
#exec MESH CLEARATTACHTAGS	MESH=PowerPlantCMesh
#exec MESH CLEARATTACHTAGS	MESH=PrisonerAMesh
#exec MESH CLEARATTACHTAGS	MESH=CristaviMesh


// weapon bones
#exec MESH ATTACHNAME		MESH=BobrovMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GrinkoMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=HamletMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=KombaynMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=BaxterMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MinerBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=BureaucratAMesh		BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=DignitaryAMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MitchMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MasseMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=WilkesMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=CookAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=CookBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=ERussianCivilianCMesh	BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=AlekseevichMesh		BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=CIAmaintenanceMesh		BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=ContactAMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=ERussianCivilianAMesh	BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=ERussianCivilianBMesh	BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=FeirongMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=Grunt					BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=IvanMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=LambertMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=LongDanMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MercTechAMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MercTechBMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=PietrMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=PowerPlantAMesh		BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=PowerPlantCMesh		BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=PrisonerAMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=CristaviMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868

// hat bones
#exec MESH ATTACHNAME		MESH=BobrovMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GrinkoMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=HamletMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=KombaynMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=BaxterMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MinerBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=BureaucratAMesh		BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=DignitaryAMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MitchMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MasseMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=WilkesMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CookAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CookBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianCMesh	BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=AlekseevichMesh		BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CIAmaintenanceMesh		BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ContactAMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianAMesh	BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianBMesh	BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=FeirongMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=Grunt					BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=IvanMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=LambertMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=LongDanMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MercTechAMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MercTechBMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PietrMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PowerPlantAMesh		BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PowerPlantCMesh		BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PrisonerAMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CristaviMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0

// satchel bones
#exec MESH ATTACHNAME		MESH=BobrovMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GrinkoMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=HamletMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=KombaynMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=BaxterMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MinerBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=BureaucratAMesh		BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=DignitaryAMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MitchMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MasseMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=WilkesMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CookAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CookBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianCMesh	BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=AlekseevichMesh		BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CIAmaintenanceMesh		BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ContactAMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianAMesh	BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianBMesh	BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=FeirongMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=Grunt					BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=IvanMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=LambertMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=LongDanMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MercTechAMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MercTechBMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PietrMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PowerPlantAMesh		BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PowerPlantCMesh		BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PrisonerAMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=CristaviMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0

// mouth bones
#exec MESH ATTACHNAME		MESH=BobrovMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GrinkoMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=HamletMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=KombaynMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=BaxterMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MinerBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=BureaucratAMesh		BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=DignitaryAMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MitchMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MasseMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=WilkesMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=CookAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=CookBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianCMesh	BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=AlekseevichMesh		BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=CIAmaintenanceMesh		BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=ContactAMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianAMesh	BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=ERussianCivilianBMesh	BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=FeirongMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=Grunt					BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=IvanMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=LambertMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=LongDanMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MercTechAMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MercTechBMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MinerAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=PietrMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=PowerPlantAMesh		BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=PowerPlantCMesh		BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=PrisonerAMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=CristaviMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0

// SPECIFIC STUFF
#exec MESH ATTACHNAME		MESH=MercTechAMesh			BONE="B Spine2" TAG="Screen" YAW=125.095 PITCH=-54.233 ROLL=41.61 X=0.434 Y=11.484 Z=13.353
#exec MESH ATTACHNAME		MESH=MercTechBMesh			BONE="B Spine2" TAG="Screen" YAW=125.095 PITCH=-54.233 ROLL=41.61 X=0.434 Y=11.484 Z=13.353
#exec MESH ATTACHNAME		MESH=PietrMesh				BONE="B Spine2" TAG="Screen" YAW=125.095 PITCH=-54.233 ROLL=41.61 X=0.434 Y=11.484 Z=13.353

#exec MESH ATTACHNAME		MESH=MercTechAMesh			BONE="B R Hand" TAG="Briefcase"	YAW=56.853 PITCH=-0.314 ROLL=70.387 X=-1.443 Y=2.734 Z=-37.932
#exec MESH ATTACHNAME		MESH=MercTechBMesh			BONE="B R Hand" TAG="Briefcase"	YAW=56.853 PITCH=-0.314 ROLL=70.387 X=-1.443 Y=2.734 Z=-37.932
#exec MESH ATTACHNAME		MESH=PietrMesh				BONE="B R Hand" TAG="Briefcase"	YAW=56.853 PITCH=-0.314 ROLL=70.387 X=-1.443 Y=2.734 Z=-37.932

#exec MESH ATTACHNAME		MESH=FeirongMesh			BONE="B L Hand" TAG="BottleBone" YAW=51.483 PITCH=39.206 ROLL=-119.562 X=-3.468 Y=9.145 Z=-2.756

#exec MESH ATTACHNAME		MESH=IvanMesh				BONE="B L Hand" TAG="CellBone" YAW=68.255 PITCH=2.05 ROLL=-103.431 X=-4.283 Y=5.109 Z=5.799
#exec MESH ATTACHNAME		MESH=BureaucratAMesh		BONE="B L Hand" TAG="CellBone" YAW=68.255 PITCH=2.05 ROLL=-103.431 X=-4.283 Y=5.109 Z=5.799

#exec MESH ATTACHNAME		MESH=BureaucratAMesh		BONE="B L Hand" TAG="CupBone" YAW=65.953 PITCH=5.048 ROLL=-127.348 X=-5.639 Y=10.498 Z=-2.793

#exec MESH ATTACHNAME		MESH=MitchMesh				BONE="B L Finger01" TAG="CigBone" YAW=-123.368 PITCH=21.803 ROLL=18.932 X=-4.283 Y=-0.559 Z=3.175
#exec MESH ATTACHNAME		MESH=HamletMesh				BONE="B L Finger01" TAG="CigBone" YAW=-123.368 PITCH=21.803 ROLL=18.932 X=-4.283 Y=-0.559 Z=3.175
#exec MESH ATTACHNAME		MESH=CookAMesh				BONE="B L Finger01" TAG="CigBone" YAW=-123.368 PITCH=21.803 ROLL=18.932 X=-4.283 Y=-0.559 Z=3.175
#exec MESH ATTACHNAME		MESH=CookBMesh				BONE="B L Finger01" TAG="CigBone" YAW=-123.368 PITCH=21.803 ROLL=18.932 X=-4.283 Y=-0.559 Z=3.175

//
//
// Pills -- Clear before processing
//
//


#exec MESH CLEARPILLINFO	MESH=BobrovMesh
#exec MESH CLEARPILLINFO	MESH=GrinkoMesh
#exec MESH CLEARPILLINFO	MESH=HamletMesh
#exec MESH CLEARPILLINFO	MESH=KombaynMesh
#exec MESH CLEARPILLINFO	MESH=BaxterMesh
#exec MESH CLEARPILLINFO	MESH=MinerAMesh
#exec MESH CLEARPILLINFO	MESH=MinerBMesh
#exec MESH CLEARPILLINFO	MESH=BureaucratAMesh
#exec MESH CLEARPILLINFO	MESH=DignitaryAMesh
#exec MESH CLEARPILLINFO	MESH=MitchMesh
#exec MESH CLEARPILLINFO	MESH=MasseMesh
#exec MESH CLEARPILLINFO	MESH=WilkesMesh
#exec MESH CLEARPILLINFO	MESH=CookAMesh
#exec MESH CLEARPILLINFO	MESH=CookBMesh
#exec MESH CLEARPILLINFO	MESH=ERussianCivilianCMesh
#exec MESH CLEARPILLINFO	MESH=AlekseevichMesh
#exec MESH CLEARPILLINFO	MESH=CIAmaintenanceMesh
#exec MESH CLEARPILLINFO	MESH=ContactAMesh
#exec MESH CLEARPILLINFO	MESH=ERussianCivilianAMesh
#exec MESH CLEARPILLINFO	MESH=ERussianCivilianBMesh
#exec MESH CLEARPILLINFO	MESH=FeirongMesh
#exec MESH CLEARPILLINFO	MESH=Grunt
#exec MESH CLEARPILLINFO	MESH=IvanMesh
#exec MESH CLEARPILLINFO	MESH=LambertMesh
#exec MESH CLEARPILLINFO	MESH=LongDanMesh
#exec MESH CLEARPILLINFO	MESH=MercTechAMesh
#exec MESH CLEARPILLINFO	MESH=MercTechBMesh
#exec MESH CLEARPILLINFO	MESH=MinerAMesh
#exec MESH CLEARPILLINFO	MESH=PietrMesh
#exec MESH CLEARPILLINFO	MESH=PowerPlantAMesh
#exec MESH CLEARPILLINFO	MESH=PowerPlantCMesh
#exec MESH CLEARPILLINFO	MESH=PrisonerAMesh
#exec MESH CLEARPILLINFO	MESH=CristaviMesh


// Head
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B Head"			X=4.172 Y=-2.376 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B Head"			X=11.519 Y=-0.428 Z=0.0

// L Body

#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B Spine2"			X=15.820 Y=-2.171 Z=6.210
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B Pelvis"			X=2.591 Y=-2.420 Z=4.759

// L UpperArm and L ForeArm
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L UpperArm"		X=0.503 Y=1.035 Z=0.881
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Forearm"		X=0.345 Y=1.431 Z=-1.673
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Forearm"		X=17.537 Y=1.051 Z=-1.409

// L Hand
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Hand"			X=4.393 Y=-0.614 Z=-1.436

// L Thigh
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Thigh"		X=3.650 Y=-1.730 Z=0.0802
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Calf"			X=-0.205 Y=-2.376 Z=-1.444

// L Calf
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Calf"			X=5.693 Y=-0.653 Z=-1.457
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Foot"			X=-4.250 Y=-1.127 Z=-0.0661

// L Foot
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Foot"			X=5.318 Y=0.159 Z=-0.153
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B L Toe0"			X=5.208 Y=-3.884 Z=-0.137

// R Body
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B Spine2"			X=15.820 Y=-2.171 Z=-6.210
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B Pelvis"			X=2.591 Y=-2.420 Z=-4.759

// R UpperArm and R ForeArm
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R UpperArm"		X=0.503 Y=1.035 Z=-0.881
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Forearm"		X=0.345 Y=1.431 Z=1.673
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Forearm"		X=17.537 Y=1.051 Z=1.409

// R Hand
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Hand"			X=4.393 Y=-0.614 Z=1.436

// R Thigh
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Thigh"		X=3.650 Y=-1.730 Z=-0.0802
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Calf"			X=-0.205 Y=-2.376 Z=1.444

// R Calf
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Calf"			X=5.693 Y=-0.653 Z=1.457
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Foot"			X=-4.250 Y=-1.127 Z=0.0661

// R Foot
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Foot"			X=5.318 Y=0.159 Z=0.153
#exec MESH ADDPILLVERTEX	MESH=BobrovMesh		BONE="B R Toe0"			X=5.208 Y=-3.884 Z=0.137


//  Head
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=0 VERTEX2=1 RADIUS=8.0 TAG=1 PRIORITY=3

// L Body
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=2 VERTEX2=3 RADIUS=12.5 TAG=2 PRIORITY=3

// L UpperArm
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=4 VERTEX2=5 RADIUS=7.0 TAG=3 PRIORITY=2

// L ForeArm
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=5 VERTEX2=6 RADIUS=6.5 TAG=4 PRIORITY=1

// L Hand
#exec MESH ADDSPHEREPILL	MESH=BobrovMesh		VERTEX=7 RADIUS=7.0 TAG=5 PRIORITY=1

// L Thigh
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=8 VERTEX2=9 RADIUS=9.5 TAG=6 PRIORITY=2

// L Calf
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=10 VERTEX2=11 RADIUS=7.5 TAG=7 PRIORITY=1

// L Foot
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=12 VERTEX2=13 RADIUS=5.5 TAG=8 PRIORITY=1

// R Body
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=14 VERTEX2=15 RADIUS=12.5 TAG=9 PRIORITY=3

// R UpperArm
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=16 VERTEX2=17 RADIUS=7.0 TAG=10 PRIORITY=2

// R ForeArm
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=17 VERTEX2=18 RADIUS=6.5 TAG=11 PRIORITY=1

// R Hand
#exec MESH ADDSPHEREPILL	MESH=BobrovMesh		VERTEX=19 RADIUS=7.0 TAG=12 PRIORITY=1

// R Thigh
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=20 VERTEX2=21 RADIUS=9.5 TAG=13 PRIORITY=2

// R Calf
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=22 VERTEX2=23 RADIUS=7.5 TAG=14 PRIORITY=1

// R Foot
#exec MESH ADDCYLINDERPILL	MESH=BobrovMesh		VERTEX1=24 VERTEX2=25 RADIUS=5.5 TAG=15 PRIORITY=1


// copy pill info to all similar meshes

#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=BureaucratAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=DignitaryAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MitchMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MasseMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=BobrovMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=GrinkoMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=HamletMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=KombaynMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=BaxterMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MinerAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MinerBMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=WilkesMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=CookAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=CookBMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=ERussianCivilianCMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=AlekseevichMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=CIAmaintenanceMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=ContactAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=ERussianCivilianAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=ERussianCivilianBMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=FeirongMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=Grunt
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=IvanMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=LambertMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=LongDanMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MercTechAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MercTechBMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=MinerAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=PietrMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=PowerPlantAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=PowerPlantCMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=PrisonerAMesh
#exec MESH PILLCOPY			MESH1=BobrovMesh		MESH2=CristaviMesh


#exec ANIM FLAG ANIM=FeirongAnims		SEQ=FeirStNmSh0 FLAG=AF_CanFireWeapon

// save UKX with #exec changes
#exec SAVEPACKAGE FILE=..\Animations\ENPC.ukx PACKAGE=ENPC

defaultproperties
{
    bNoAiming=True
    BasicPatternClass=Class'Echelon.EBureaucratPattern'
    AnimSequence="waitstnmfd0"
}