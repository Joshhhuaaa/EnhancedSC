//=============================================================================
//
// class EAIProfessional
//
// intended specifically for Professional-related Animation Setup
// NOTE!  Right now (11/01/01) all AIPawns use the same animation setup
// so this class for now is simply an intermediate class to avoid redundant animation loading
//
//=============================================================================

class EAIProfessional extends EAIPawn
	notplaceable;



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
#exec MESH LIPSYNCHBONES MESH=RookieAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=FakeSoldierAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MafiaAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=MafiaBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=AgentAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=AgentBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=EliteAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GEPoliceAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GEPoliceBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GESoldierAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GESoldierBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=PalaceGuardAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=PalaceGuardBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=RenegadeAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=RenegadeBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=SecurityAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=SecurityBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=SoldierAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=SpetsnazAMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GEColonelMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=GEColonelBMesh FILE=..\lipsynch\npc.lbp
#exec MESH LIPSYNCHBONES MESH=ChineseColonelMesh FILE=..\lipsynch\npc.lbp


//
//
//  Attachments
//
//

#exec MESH CLEARATTACHTAGS	MESH=RookieAMesh
#exec MESH CLEARATTACHTAGS	MESH=FakeSoldierAMesh
#exec MESH CLEARATTACHTAGS	MESH=MafiaAMesh
#exec MESH CLEARATTACHTAGS	MESH=MafiaBMesh
#exec MESH CLEARATTACHTAGS	MESH=AgentAMesh
#exec MESH CLEARATTACHTAGS	MESH=AgentBMesh
#exec MESH CLEARATTACHTAGS	MESH=EliteAMesh
#exec MESH CLEARATTACHTAGS	MESH=GEPoliceAMesh
#exec MESH CLEARATTACHTAGS	MESH=GEPoliceBMesh
#exec MESH CLEARATTACHTAGS	MESH=GESoldierAMesh
#exec MESH CLEARATTACHTAGS	MESH=GESoldierBMesh
#exec MESH CLEARATTACHTAGS	MESH=PalaceGuardAMesh
#exec MESH CLEARATTACHTAGS	MESH=PalaceGuardBMesh
#exec MESH CLEARATTACHTAGS	MESH=RenegadeAMesh
#exec MESH CLEARATTACHTAGS	MESH=RenegadeBMesh
#exec MESH CLEARATTACHTAGS	MESH=SecurityAMesh
#exec MESH CLEARATTACHTAGS	MESH=SecurityBMesh
#exec MESH CLEARATTACHTAGS	MESH=SoldierAMesh
#exec MESH CLEARATTACHTAGS	MESH=SpetsnazAMesh
#exec MESH CLEARATTACHTAGS	MESH=GEColonelMesh
#exec MESH CLEARATTACHTAGS	MESH=GEColonelBMesh
#exec MESH CLEARATTACHTAGS	MESH=ChineseColonelMesh


// weapon bones
#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B R Hand" TAG="WeaponBone" YAW=0.34 PITCH=-3.057 ROLL=9.804 X=5.63 Y=-3.39 Z=0.868

#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B Head" TAG="MouthBone" YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0

// weapon away bones

// two-handed weapons
#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B Spine2"	 TAG="TwoHandAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=-10 Y=13 Z=-5

// pistol locations
#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B R Thigh" TAG="OneHandAwayBone"	  YAW=0 PITCH=1 ROLL=191.25 X=8 Y=10.5 Z=-5

// hat bones
#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=-2
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B Head" TAG="HatBone" YAW=00.0 PITCH=-64.0 ROLL=5.36 X=0 Y=0 Z=0

// satchel bones
#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B Spine" TAG="SatchelBone" YAW=-68.0 PITCH=00.0 ROLL=64.0 X=17 Y=0 Z=0

// light bones
#exec MESH ATTACHNAME		MESH=RookieAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=FakeSoldierAMesh			BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=MafiaAMesh					BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=MafiaBMesh					BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=AgentBMesh					BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=EliteAMesh					BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=GEPoliceAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=GEPoliceBMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=GESoldierAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=GESoldierBMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=PalaceGuardAMesh			BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=PalaceGuardBMesh			BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=RenegadeAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=RenegadeBMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=SecurityAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=SecurityBMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=SoldierAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=SpetsnazAMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=GEColonelMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=GEColonelBMesh				BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804
#exec MESH ATTACHNAME		MESH=ChineseColonelMesh			BONE="B Head" TAG="LightBone" YAW=-58.595 PITCH=0 ROLL=64 X=0.684 Y=-8.123 Z=12.804

#exec MESH ATTACHNAME		MESH=AgentAMesh					BONE="B L Hand" TAG="CellBone" YAW=68.255 PITCH=2.05 ROLL=-103.431 X=-4.283 Y=5.109 Z=5.799

//
//
// Pills -- Clear before processing
//
//

#exec MESH CLEARPILLINFO	MESH=RookieAMesh
#exec MESH CLEARPILLINFO	MESH=FakeSoldierAMesh
#exec MESH CLEARPILLINFO	MESH=MafiaAMesh
#exec MESH CLEARPILLINFO	MESH=MafiaBMesh
#exec MESH CLEARPILLINFO	MESH=AgentAMesh
#exec MESH CLEARPILLINFO	MESH=AgentBMesh
#exec MESH CLEARPILLINFO	MESH=EliteAMesh
#exec MESH CLEARPILLINFO	MESH=GEPoliceAMesh
#exec MESH CLEARPILLINFO	MESH=GEPoliceBMesh
#exec MESH CLEARPILLINFO	MESH=GESoldierAMesh
#exec MESH CLEARPILLINFO	MESH=GESoldierBMesh
#exec MESH CLEARPILLINFO	MESH=PalaceGuardAMesh
#exec MESH CLEARPILLINFO	MESH=PalaceGuardBMesh
#exec MESH CLEARPILLINFO	MESH=RenegadeAMesh
#exec MESH CLEARPILLINFO	MESH=RenegadeBMesh
#exec MESH CLEARPILLINFO	MESH=SecurityAMesh
#exec MESH CLEARPILLINFO	MESH=SecurityBMesh
#exec MESH CLEARPILLINFO	MESH=SoldierAMesh
#exec MESH CLEARPILLINFO	MESH=SpetsnazAMesh
#exec MESH CLEARPILLINFO	MESH=GEColonelMesh
#exec MESH CLEARPILLINFO	MESH=GEColonelBMesh
#exec MESH CLEARPILLINFO	MESH=ChineseColonelMesh



// Head
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B Head"			X=4.172 Y=-2.376 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B Head"			X=11.519 Y=-0.428 Z=0.0

// L Body

#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B Spine2"			X=15.820 Y=-2.171 Z=6.210
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B Pelvis"			X=2.591 Y=-2.420 Z=4.759

// L UpperArm and L ForeArm
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L UpperArm"		X=0.503 Y=1.035 Z=0.881
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Forearm"		X=0.345 Y=1.431 Z=-1.673
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Forearm"		X=17.537 Y=1.051 Z=-1.409

// L Hand
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Hand"			X=4.393 Y=-0.614 Z=-1.436

// L Thigh
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Thigh"		X=3.650 Y=-1.730 Z=0.0802
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Calf"			X=-0.205 Y=-2.376 Z=-1.444

// L Calf
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Calf"			X=5.693 Y=-0.653 Z=-1.457
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Foot"			X=-4.250 Y=-1.127 Z=-0.0661

// L Foot
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Foot"			X=5.318 Y=0.159 Z=-0.153
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B L Toe0"			X=5.208 Y=-3.884 Z=-0.137

// R Body
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B Spine2"			X=15.820 Y=-2.171 Z=-6.210
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B Pelvis"			X=2.591 Y=-2.420 Z=-4.759

// R UpperArm and R ForeArm
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R UpperArm"		X=0.503 Y=1.035 Z=-0.881
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Forearm"		X=0.345 Y=1.431 Z=1.673
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Forearm"		X=17.537 Y=1.051 Z=1.409

// R Hand
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Hand"			X=4.393 Y=-0.614 Z=1.436

// R Thigh
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Thigh"		X=3.650 Y=-1.730 Z=-0.0802
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Calf"			X=-0.205 Y=-2.376 Z=1.444

// R Calf
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Calf"			X=5.693 Y=-0.653 Z=1.457
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Foot"			X=-4.250 Y=-1.127 Z=0.0661

// R Foot
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Foot"			X=5.318 Y=0.159 Z=0.153
#exec MESH ADDPILLVERTEX	MESH=RookieAMesh				BONE="B R Toe0"			X=5.208 Y=-3.884 Z=0.137


//  Head
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=0 VERTEX2=1 RADIUS=8.0 TAG=1 PRIORITY=3

// L Body
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=2 VERTEX2=3 RADIUS=12.5 TAG=2 PRIORITY=3

// L UpperArm
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=4 VERTEX2=5 RADIUS=7.0 TAG=3 PRIORITY=2

// L ForeArm
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=5 VERTEX2=6 RADIUS=6.5 TAG=4 PRIORITY=1

// L Hand
#exec MESH ADDSPHEREPILL	MESH=RookieAMesh				VERTEX=7 RADIUS=7.0 TAG=5 PRIORITY=1

// L Thigh
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=8 VERTEX2=9 RADIUS=9.5 TAG=6 PRIORITY=2

// L Calf
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=10 VERTEX2=11 RADIUS=7.5 TAG=7 PRIORITY=1

// L Foot
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=12 VERTEX2=13 RADIUS=5.5 TAG=8 PRIORITY=1

// R Body
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=14 VERTEX2=15 RADIUS=12.5 TAG=9 PRIORITY=3

// R UpperArm
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=16 VERTEX2=17 RADIUS=7.0 TAG=10 PRIORITY=2

// R ForeArm
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=17 VERTEX2=18 RADIUS=6.5 TAG=11 PRIORITY=1

// R Hand
#exec MESH ADDSPHEREPILL	MESH=RookieAMesh				VERTEX=19 RADIUS=7.0 TAG=12 PRIORITY=1

// R Thigh
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=20 VERTEX2=21 RADIUS=9.5 TAG=13 PRIORITY=2

// R Calf
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=22 VERTEX2=23 RADIUS=7.5 TAG=14 PRIORITY=1

// R Foot
#exec MESH ADDCYLINDERPILL	MESH=RookieAMesh				VERTEX1=24 VERTEX2=25 RADIUS=5.5 TAG=15 PRIORITY=1



// copy pill info to all similar meshes

#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=FakeSoldierAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=MafiaAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=MafiaBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=AgentAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=AgentBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=EliteAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=GEPoliceAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=GEPoliceBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=GESoldierAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=GESoldierBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=PalaceGuardAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=PalaceGuardBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=RenegadeAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=RenegadeBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=SecurityAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=SecurityBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=SoldierAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=SpetsnazAMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=GEColonelMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=GEColonelBMesh
#exec MESH PILLCOPY			MESH1=RookieAMesh				MESH2=ChineseColonelMesh


// 
//
//	Anim Flags
//  
//

#exec ANIM CLEARFLAGS		ANIM=proAnims
#exec ANIM CLEARFLAGS		ANIM=maleAnims
#exec ANIM CLEARFLAGS		ANIM=pistolAnims




// MALEANIMS

// reaction & personality
#exec ANIM FLAG ANIM=MaleAnims		SEQ=reacStNmFd0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=reacStAlFd0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=prsoStNmAA0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=prsoStNmBB0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=prsoStNmCC0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=prsoStNmDD0 FLAG=AF_UseHeadBone

// look around anims
#exec ANIM FLAG ANIM=MaleAnims		SEQ=LookStNmLt0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=LookStNmRt0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=LookStNmDn0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=LookStNmUp0 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=MaleAnims		SEQ=LookStNmBk0 FLAG=AF_UseHeadBone


// PISTOLANIMS

// reaction & personality
#exec ANIM FLAG ANIM=PistolAnims	SEQ=reacStNmFd1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=reacStAlFd1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=prsoStNmAA1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=prsoStNmBB1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=prsoStNmCC1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=prsoStNmDD1 FLAG=AF_UseHeadBone

// peeking anims
#exec ANIM FLAG ANIM=PistolAnims	SEQ=peekStNtRt1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=peekStNtLt1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=peekCrNtRt1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=peekCrNtLt1 FLAG=AF_UseHeadBone

// look around anims
#exec ANIM FLAG ANIM=PistolAnims	SEQ=LookStNmLt1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=LookStNmRt1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=LookStNmDn1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=LookStNmUp1 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=PistolAnims	SEQ=LookStNmBk1 FLAG=AF_UseHeadBone

// PROANIMS


// reaction & personality
#exec ANIM FLAG ANIM=proAnims		SEQ=reacStNmFd2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=reacStAlFd2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=prsoStNmAA2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=prsoStNmBB2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=prsoStNmCC2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=prsoStNmDD2 FLAG=AF_UseHeadBone

// peeking anims
#exec ANIM FLAG ANIM=proAnims		SEQ=peekStNtRt2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=peekStNtLt2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=peekCrNtRt2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=peekCrNtLt2 FLAG=AF_UseHeadBone


// look / sign anims -- will they be used?
#exec ANIM FLAG ANIM=proAnims		SEQ=waitStAlLt2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=waitStAlRt2 FLAG=AF_UseHeadBone	


// look around anims
#exec ANIM FLAG ANIM=proAnims		SEQ=LookStNmLt2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=LookStNmRt2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=LookStNmDn2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=LookStNmUp2 FLAG=AF_UseHeadBone
#exec ANIM FLAG ANIM=proAnims		SEQ=LookStNmBk2 FLAG=AF_UseHeadBone


// anims during which NPC can fire weapon

#exec ANIM FLAG ANIM=pistolAnims	SEQ=WaitCrAlFd1 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=pistolAnims	SEQ=WaitStAlFd1 FLAG=AF_CanFireWeapon

#exec ANIM FLAG ANIM=proAnims		SEQ=WaitStAlFd2 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=proAnims		SEQ=WaitCrAlFd2 FLAG=AF_CanFireWeapon

#exec ANIM FLAG ANIM=pistolAnims	SEQ=PeekStNtLt1 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=pistolAnims	SEQ=PeekStNtRt1 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=pistolAnims	SEQ=PeekCrNtLt1 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=pistolAnims	SEQ=PeekCrNtRt1 FLAG=AF_CanFireWeapon

#exec ANIM FLAG ANIM=proAnims		SEQ=PeekStNtLt2 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=proAnims		SEQ=PeekStNtRt2 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=proAnims		SEQ=PeekCrNtLt2 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=proAnims		SEQ=PeekCrNtRt2 FLAG=AF_CanFireWeapon

#exec ANIM FLAG ANIM=pistolAnims	SEQ=ShotStAlFd1 FLAG=AF_CanFireWeapon
#exec ANIM FLAG ANIM=proAnims		SEQ=ShotStAlFd2 FLAG=AF_CanFireWeapon




// save UKX with #exec changes
#exec SAVEPACKAGE FILE=..\Animations\ENPC.ukx PACKAGE=ENPC

defaultproperties
{
    BasicPatternClass=Class'Echelon.SpetsnazPattern'
    bHostile=true
}