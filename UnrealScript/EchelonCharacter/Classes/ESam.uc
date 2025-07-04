//===============================================================================
//  [sam] 
//===============================================================================
class ESam extends EPawn;

var float FireTimer;

#exec OBJ LOAD FILE=..\textures\ETexCharacter.utx
#exec OBJ LOAD FILE=..\StaticMeshes\generic_obj.usx
#exec OBJ LOAD FILE=..\Sounds\FisherVoice.uax
#exec OBJ LOAD FILE=..\Sounds\CommonMusic.uax


//
//
//	Perform all #exec setup on all Non Hostile meshes and Male.PSA Animations
//	Save UKX when finished.
//
//

#exec OBJ LOAD FILE=..\Animations\ESam.ukx PACKAGE=ESam

#exec MESH LIPSYNCHBONES MESH=samAMesh FILE=..\lipsynch\sam.lbp
#exec MESH LIPSYNCHBONES MESH=samBMesh FILE=..\lipsynch\sam.lbp
#exec MESH LIPSYNCHBONES MESH=samCMesh FILE=..\lipsynch\sam.lbp

//
//
//  Attachments
//
//


#exec MESH CLEARATTACHTAGS MESH=samAMesh

#exec MESH ATTACHNAME MESH=samAMesh BONE="B R Hand"	 TAG="WeaponBone"	  YAW=0.756 PITCH=-3.234 ROLL=13.262 X=5.611 Y=-4.488 Z=0.596
#exec MESH ATTACHNAME MESH=samAMesh BONE="B L Hand"	 TAG="LeftHandBone"	  YAW=0 PITCH=4.3 ROLL=2.0 X=9.5 Y=-3.0 Z=-2.5
#exec MESH ATTACHNAME MESH=samAMesh BONE="B R Hand"	 TAG="WalletBone"	  YAW=0 PITCH=0	ROLL=00.0 X=4 Y=0 Z=0
#exec MESH ATTACHNAME MESH=samAMesh BONE="B Spine2"	 TAG="WeaponAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=0 Y=11 Z=0
#exec MESH ATTACHNAME MESH=samAMesh BONE="B R Thigh" TAG="LegHolster"	  YAW=0 PITCH=1 ROLL=191.25 X=6 Y=10.5 Z=-5
#exec MESH ATTACHNAME MESH=samAMesh BONE="B Spine2"	 TAG="CarryBody"	  YAW=0 PITCH=0 ROLL=00.0 X=0 Y=0 Z=0
#exec MESH ATTACHNAME MESH=samAMesh BONE="B Head"	 TAG="MouthBone"	  YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME MESH=samAMesh	BONE="B R Hand"	 TAG="Briefcase"	  YAW=56.853 PITCH=-0.314 ROLL=70.387 X=-1.443 Y=2.734 Z=-37.932

#exec MESH CLEARATTACHTAGS MESH=samBMesh

#exec MESH ATTACHNAME MESH=samBMesh BONE="B R Hand"	 TAG="WeaponBone"	  YAW=0.756 PITCH=-3.234 ROLL=13.262 X=5.611 Y=-4.488 Z=0.596
#exec MESH ATTACHNAME MESH=samBMesh BONE="B L Hand"	 TAG="LeftHandBone"	  YAW=0 PITCH=4.3 ROLL=2.0 X=9.5 Y=-3.0 Z=-2.5
#exec MESH ATTACHNAME MESH=samBMesh BONE="B R Hand"	 TAG="WalletBone"	  YAW=0 PITCH=0	ROLL=00.0 X=4 Y=0 Z=0
#exec MESH ATTACHNAME MESH=samBMesh BONE="B Spine2"	 TAG="WeaponAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=0 Y=11 Z=0
#exec MESH ATTACHNAME MESH=samBMesh BONE="B R Thigh" TAG="LegHolster"	  YAW=0 PITCH=1 ROLL=191.25 X=6 Y=10.5 Z=-5
#exec MESH ATTACHNAME MESH=samBMesh BONE="B Spine2"	 TAG="CarryBody"	  YAW=0 PITCH=0 ROLL=00.0 X=0 Y=0 Z=0
#exec MESH ATTACHNAME MESH=samBMesh BONE="B Head"	 TAG="MouthBone"	  YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME MESH=samBMesh	BONE="B R Hand"	 TAG="Briefcase"	  YAW=56.853 PITCH=-0.314 ROLL=70.387 X=-1.443 Y=2.734 Z=-37.932

#exec MESH CLEARATTACHTAGS MESH=samCMesh

#exec MESH ATTACHNAME MESH=samCMesh BONE="B R Hand"	 TAG="WeaponBone"	  YAW=0.756 PITCH=-3.234 ROLL=13.262 X=5.611 Y=-4.488 Z=0.596
#exec MESH ATTACHNAME MESH=samCMesh BONE="B L Hand"	 TAG="LeftHandBone"	  YAW=0 PITCH=4.3 ROLL=2.0 X=9.5 Y=-3.0 Z=-2.5
#exec MESH ATTACHNAME MESH=samCMesh BONE="B R Hand"	 TAG="WalletBone"	  YAW=0 PITCH=0	ROLL=00.0 X=4 Y=0 Z=0
#exec MESH ATTACHNAME MESH=samCMesh BONE="B Spine2"	 TAG="WeaponAwayBone" YAW=0 PITCH=150 ROLL=00.0 X=0 Y=11 Z=0
#exec MESH ATTACHNAME MESH=samCMesh BONE="B R Thigh" TAG="LegHolster"	  YAW=0 PITCH=1 ROLL=191.25 X=6 Y=10.5 Z=-5
#exec MESH ATTACHNAME MESH=samCMesh BONE="B Spine2"	 TAG="CarryBody"	  YAW=0 PITCH=0 ROLL=00.0 X=0 Y=0 Z=0
#exec MESH ATTACHNAME MESH=samCMesh BONE="B Head"	 TAG="MouthBone"	  YAW=0 PITCH=0 ROLL=00.0 X=4.5 Y=-10.5 Z=0
#exec MESH ATTACHNAME MESH=samCMesh	BONE="B R Hand"	 TAG="Briefcase"	  YAW=56.853 PITCH=-0.314 ROLL=70.387 X=-1.443 Y=2.734 Z=-37.932

//
//
// Pills -- Clear before processing
//
//

#exec MESH CLEARPILLINFO	MESH=samAMesh
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B Head"			X=4.172 Y=-2.376 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B Head"			X=11.519 Y=-0.428 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B Spine2"			X=15.820 Y=-2.171 Z=6.210
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B Pelvis"			X=2.591 Y=-2.420 Z=4.759
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L UpperArm"		X=0.503 Y=1.035 Z=0.881
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Forearm"		X=0.345 Y=1.431 Z=-1.673
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Forearm"		X=17.537 Y=1.051 Z=-1.409
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Hand"			X=4.393 Y=-0.614 Z=-1.436
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Thigh"		X=3.650 Y=-1.730 Z=0.0802
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Calf"			X=-0.205 Y=-2.376 Z=-1.444
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Calf"			X=5.693 Y=-0.653 Z=-1.457
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Foot"			X=-4.250 Y=-1.127 Z=-0.0661
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Foot"			X=5.318 Y=0.159 Z=-0.153
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B L Toe0"			X=5.208 Y=-3.884 Z=-0.137
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B Spine2"			X=15.820 Y=-2.171 Z=-6.210
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B Pelvis"			X=2.591 Y=-2.420 Z=-4.759
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R UpperArm"		X=0.503 Y=1.035 Z=-0.881
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Forearm"		X=0.345 Y=1.431 Z=1.673
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Forearm"		X=17.537 Y=1.051 Z=1.409
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Hand"			X=4.393 Y=-0.614 Z=1.436
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Thigh"		X=3.650 Y=-1.730 Z=-0.0802
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Calf"			X=-0.205 Y=-2.376 Z=1.444
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Calf"			X=5.693 Y=-0.653 Z=1.457
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Foot"			X=-4.250 Y=-1.127 Z=0.0661
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Foot"			X=5.318 Y=0.159 Z=0.153
#exec MESH ADDPILLVERTEX	MESH=samAMesh	BONE="B R Toe0"			X=5.208 Y=-3.884 Z=0.137
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=0 VERTEX2=1 RADIUS=9.0 TAG=1 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=2 VERTEX2=3 RADIUS=12.5 TAG=2 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=4 VERTEX2=5 RADIUS=7.0 TAG=3 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=5 VERTEX2=6 RADIUS=6.5 TAG=4 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=samAMesh	VERTEX=7 RADIUS=7.0 TAG=5 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=8 VERTEX2=9 RADIUS=9.5 TAG=6 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=10 VERTEX2=11 RADIUS=7.5 TAG=7 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=12 VERTEX2=13 RADIUS=5.5 TAG=8 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=14 VERTEX2=15 RADIUS=12.5 TAG=9 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=16 VERTEX2=17 RADIUS=7.0 TAG=10 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=17 VERTEX2=18 RADIUS=6.5 TAG=11 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=samAMesh	VERTEX=19 RADIUS=7.0 TAG=12 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=20 VERTEX2=21 RADIUS=9.5 TAG=13 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=22 VERTEX2=23 RADIUS=7.5 TAG=14 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samAMesh	VERTEX1=24 VERTEX2=25 RADIUS=5.5 TAG=15 PRIORITY=1

#exec MESH CLEARPILLINFO	MESH=samBMesh
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B Head"			X=4.172 Y=-2.376 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B Head"			X=11.519 Y=-0.428 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B Spine2"			X=15.820 Y=-2.171 Z=6.210
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B Pelvis"			X=2.591 Y=-2.420 Z=4.759
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L UpperArm"		X=0.503 Y=1.035 Z=0.881
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Forearm"		X=0.345 Y=1.431 Z=-1.673
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Forearm"		X=17.537 Y=1.051 Z=-1.409
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Hand"			X=4.393 Y=-0.614 Z=-1.436
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Thigh"		X=3.650 Y=-1.730 Z=0.0802
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Calf"			X=-0.205 Y=-2.376 Z=-1.444
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Calf"			X=5.693 Y=-0.653 Z=-1.457
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Foot"			X=-4.250 Y=-1.127 Z=-0.0661
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Foot"			X=5.318 Y=0.159 Z=-0.153
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B L Toe0"			X=5.208 Y=-3.884 Z=-0.137
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B Spine2"			X=15.820 Y=-2.171 Z=-6.210
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B Pelvis"			X=2.591 Y=-2.420 Z=-4.759
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R UpperArm"		X=0.503 Y=1.035 Z=-0.881
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Forearm"		X=0.345 Y=1.431 Z=1.673
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Forearm"		X=17.537 Y=1.051 Z=1.409
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Hand"			X=4.393 Y=-0.614 Z=1.436
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Thigh"		X=3.650 Y=-1.730 Z=-0.0802
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Calf"			X=-0.205 Y=-2.376 Z=1.444
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Calf"			X=5.693 Y=-0.653 Z=1.457
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Foot"			X=-4.250 Y=-1.127 Z=0.0661
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Foot"			X=5.318 Y=0.159 Z=0.153
#exec MESH ADDPILLVERTEX	MESH=samBMesh	BONE="B R Toe0"			X=5.208 Y=-3.884 Z=0.137
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=0 VERTEX2=1 RADIUS=9.0 TAG=1 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=2 VERTEX2=3 RADIUS=12.5 TAG=2 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=4 VERTEX2=5 RADIUS=7.0 TAG=3 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=5 VERTEX2=6 RADIUS=6.5 TAG=4 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=samBMesh	VERTEX=7 RADIUS=7.0 TAG=5 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=8 VERTEX2=9 RADIUS=9.5 TAG=6 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=10 VERTEX2=11 RADIUS=7.5 TAG=7 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=12 VERTEX2=13 RADIUS=5.5 TAG=8 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=14 VERTEX2=15 RADIUS=12.5 TAG=9 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=16 VERTEX2=17 RADIUS=7.0 TAG=10 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=17 VERTEX2=18 RADIUS=6.5 TAG=11 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=samBMesh	VERTEX=19 RADIUS=7.0 TAG=12 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=20 VERTEX2=21 RADIUS=9.5 TAG=13 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=22 VERTEX2=23 RADIUS=7.5 TAG=14 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samBMesh	VERTEX1=24 VERTEX2=25 RADIUS=5.5 TAG=15 PRIORITY=1

#exec MESH CLEARPILLINFO	MESH=samCMesh
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B Head"			X=4.172 Y=-2.376 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B Head"			X=11.519 Y=-0.428 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B Spine2"			X=15.820 Y=-2.171 Z=6.210
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B Pelvis"			X=2.591 Y=-2.420 Z=4.759
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L UpperArm"		X=0.503 Y=1.035 Z=0.881
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Forearm"		X=0.345 Y=1.431 Z=-1.673
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Forearm"		X=17.537 Y=1.051 Z=-1.409
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Hand"			X=4.393 Y=-0.614 Z=-1.436
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Thigh"		X=3.650 Y=-1.730 Z=0.0802
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Calf"			X=-0.205 Y=-2.376 Z=-1.444
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Calf"			X=5.693 Y=-0.653 Z=-1.457
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Foot"			X=-4.250 Y=-1.127 Z=-0.0661
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Foot"			X=5.318 Y=0.159 Z=-0.153
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B L Toe0"			X=5.208 Y=-3.884 Z=-0.137
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B Spine2"			X=15.820 Y=-2.171 Z=-6.210
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B Pelvis"			X=2.591 Y=-2.420 Z=-4.759
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R UpperArm"		X=0.503 Y=1.035 Z=-0.881
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Forearm"		X=0.345 Y=1.431 Z=1.673
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Forearm"		X=17.537 Y=1.051 Z=1.409
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Hand"			X=4.393 Y=-0.614 Z=1.436
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Thigh"		X=3.650 Y=-1.730 Z=-0.0802
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Calf"			X=-0.205 Y=-2.376 Z=1.444
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Calf"			X=5.693 Y=-0.653 Z=1.457
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Foot"			X=-4.250 Y=-1.127 Z=0.0661
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Foot"			X=5.318 Y=0.159 Z=0.153
#exec MESH ADDPILLVERTEX	MESH=samCMesh	BONE="B R Toe0"			X=5.208 Y=-3.884 Z=0.137
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=0 VERTEX2=1 RADIUS=9.0 TAG=1 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=2 VERTEX2=3 RADIUS=12.5 TAG=2 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=4 VERTEX2=5 RADIUS=7.0 TAG=3 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=5 VERTEX2=6 RADIUS=6.5 TAG=4 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=samCMesh	VERTEX=7 RADIUS=7.0 TAG=5 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=8 VERTEX2=9 RADIUS=9.5 TAG=6 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=10 VERTEX2=11 RADIUS=7.5 TAG=7 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=12 VERTEX2=13 RADIUS=5.5 TAG=8 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=14 VERTEX2=15 RADIUS=12.5 TAG=9 PRIORITY=3
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=16 VERTEX2=17 RADIUS=7.0 TAG=10 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=17 VERTEX2=18 RADIUS=6.5 TAG=11 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=samCMesh	VERTEX=19 RADIUS=7.0 TAG=12 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=20 VERTEX2=21 RADIUS=9.5 TAG=13 PRIORITY=2
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=22 VERTEX2=23 RADIUS=7.5 TAG=14 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=samCMesh	VERTEX1=24 VERTEX2=25 RADIUS=5.5 TAG=15 PRIORITY=1

//
//
//	DONE - save the UKX
//
//

#exec SAVEPACKAGE FILE=..\Animations\ESam.ukx PACKAGE=ESam

// Joshua - New Sam mesh function
function SetSamMesh(int SamMeshType)
{
    switch (SamMeshType)
    {
		case 0:
			Mesh = EchelonLevelInfo(Level).SamMesh;
			if( Mesh == none )
			{
				// JFP: Temp hack, following the Oct-30-2002 merge some maps didn't have the SamMesh set.
				// Added this for backward compatibility.
				Mesh=SkeletalMesh'ESam.samAMesh';
				log("JFPDEBUG: Hardcoding the default Sam mesh, since no mesh appeared to be set in the Level. Fix this in UnrealEd. New mesh:"@Mesh);
			}
			break;
        case 1:
            Mesh = SkeletalMesh'ESam.samAMesh';
            break;
        case 2:
            Mesh = SkeletalMesh'ESam.samBMesh';
            break;
        case 3:
            Mesh = SkeletalMesh'ESam.samCMesh';
            break;
        default:
			Mesh = EchelonLevelInfo(Level).SamMesh;
			if( Mesh == none )
			{
				Mesh=SkeletalMesh'ESam.samAMesh';
			}
            break;
    }
}

function PostBeginPlay()
{
    // Joshua - Check for level specific overrides
    switch(GetCurrentMapName())
    {
        case "0_0_2_Training":
        case "0_0_3_Training":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Training);
            break;
            
        case "1_1_0Tbilisi":
        case "1_1_1Tbilisi": 
        case "1_1_2Tbilisi":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Tbilisi);
            break;

		case "1_2_1DefenseMinistry":
        case "1_2_2DefenseMinistry": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_DefenseMinistry);
            break;

		case "1_3_2CaspianOilRefinery":
        case "1_3_3CaspianOilRefinery": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_CaspianOilRefinery);
            break;

        case "2_1_0CIA":
        case "2_1_1CIA":
		case "2_1_2CIA":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_CIA);
            break;
            
        case "2_2_1_Kalinatek":
        case "2_2_2_Kalinatek": 
        case "2_2_3_Kalinatek":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Kalinatek);
            break;

		case "3_2_1_PowerPlant":
        case "3_2_2_PowerPlant": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_PowerPlant);
            break;

        case "3_4_2Severonickel":
        case "3_4_3Severonickel":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Severonickel);
            break;
            
        case "4_1_1ChineseEmbassy":
        case "4_1_2ChineseEmbassy": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_ChineseEmbassy);
            break;

		case "4_2_1_Abattoir":
        case "4_2_2_Abattoir": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Abattoir);
            break;

        case "4_3_0ChineseEmbassy":
        case "4_3_1ChineseEmbassy":
		case "4_3_2ChineseEmbassy":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_ChineseEmbassy2);
            break;
            
		case "5_1_1_PresidentialPalace":
        case "5_1_2_PresidentialPalace": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_PresidentialPalace);
            break;			
            
		case "1_6_1_1KolaCell":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_KolaCell);
            break;	

		case "1_7_1_1VselkaInfiltration":
        case "1_7_1_2Vselka": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Vselka);
            break;

		default:
			SetSamMesh(0);
			break;
    }
 
    Super.PostBeginPlay();
}

//------------------------------------------------------------------------
// Description		
//		Called from Epawn to play special animations after an idle time
//------------------------------------------------------------------------
event GetRandomWaitAnim(out name ReturnName)
{
	local float r;
	local float CamPan;
	CamPan = Vector(Controller.Rotation) Dot Vector(Rotation);

	r = FRand();
	if( !bIsCrouched )
	{
		if( r <= 0.25f )
			ReturnName = 'prsostalaa0';
		else if( r <= 0.50f )
			ReturnName = 'prsostalbb0';
		else if( r <= 0.75f && CamPan > 0.5 )
			ReturnName = 'prsostalcc0';
		else
			ReturnName = 'prsostaldd0';
	}
	else
	{
		if( r <= 0.50f )
			ReturnName = 'prsocralaa0';
		else
			ReturnName = 'prsocralbb0';
	}
}

function bool IsExtraWaiting( optional int f )
{
	local name CurrentAnimSeq;
	CurrentAnimSeq = GetAnimName();
	
	switch( f )
	{
	case 0:
		return CurrentAnimSeq == EPlayerController(Controller).SpecialWaitAnim ||
			   CurrentAnimSeq == 'prsostalaa0' || 
		   CurrentAnimSeq == 'prsostalbb0' ||
		   CurrentAnimSeq == 'prsostalcc0' ||
		   CurrentAnimSeq == 'prsostaldd0' ||
		   CurrentAnimSeq == 'prsocralaa0' ||
		   CurrentAnimSeq == 'prsocralbb0';
		break;

	case 1:
		return CurrentAnimSeq == EPlayerController(Controller).SpecialWaitAnim ||
			   CurrentAnimSeq == 'prsostalaa0' || 
			   CurrentAnimSeq == 'prsostalbb0' ||
			   CurrentAnimSeq == 'prsostalcc0' ||
			   CurrentAnimSeq == 'prsostaldd0';
		break;

	case 2:
		return CurrentAnimSeq == 'prsocralaa0' ||
			   CurrentAnimSeq == 'prsocralbb0';
		break;
	}
}

//---------------------------------------[David Kalina - 10 Apr 2001]-----
// 
// Description
//		Set up Player Animations
// 
//------------------------------------------------------------------------
function InitAnims()
{
	// Default (Same For Every MoveFlag)
	AJumpForwardR					= 'jumpstalfdr';
	AJumpForwardL					= 'jumpstalfdl';
	AJumpStart						= 'jumpStAlUp0';
	ALandHi							= 'landStAlHi0';
	ALandLow						= 'landStAlLo0';
	ALandQuiet						= 'landCrAlQt0';
	ALandAttack						= 'LandStAlAk0';
	AFall							= 'fallstaldn0';
	AFallFree						= 'fallstalfr0';
	AFallQuiet						= 'fallStAlQt0';
	ADamageHeadShotForward			= 'painstamrt0';
	ADamageHeadShotBack				= 'painstamrt0';
	ADamageChestForward				= 'painstamrt0';
	ADamageChestBack				= 'painstamrt0';
	ADamageChestLeft				= 'painstamrt0';
	ADamageChestRight				= 'painstamrt0';
	ADamageArmLeft					= 'painstamrt0';
	ADamageArmRight					= 'painstamrt0';
	ADamageLegLeft					= 'painstamrt0';
	ADamageLegRight					= 'painstamrt0';
	ACough							= 'smokstalfd0';
	ATurnRight						= 'turnstalnt0';
	ATurnRightCrouch				= 'turncralnt0';
	ASearchBody						= 'srchcralfd0';
	APlaceWallMine					= 'minestalfd0';
	ADoorOpenLt						= 'doorstallt0';
	ADoorOpenRt						= 'doorstalrt0';
	ADoorTryOpenLt					= 'doorstallkL';
	ADoorTryOpenRt					= 'doorstallkR';
	ARetinalScanBegin				= 'ScanStAlBg0';
	ARetinalScan					= 'ScanStAlNt0';
	ARetinalScanEnd					= 'ScanStAlEd0';
	ANLUpRight						= 'laddstalupr';
	ANLUpLeft						= 'laddstalupl';
	ANLOutBottomLeft				= 'LaddStAlIOL';
	ANLOutBottomRight				= 'LaddStAlIOR';
	ANLTopUpLeft					= 'laddstaleul';
	ANLTopUpRight					= 'laddstaleur';
	ANLInTop						= 'laddstalbu0';
	ANLTopDownRight					= 'laddstalbur';
	ANLInBottom						= 'laddstalior';
	ANLWaitLeft						= 'laddstalntl';
	ANLWaitRight					= 'laddstalntr';
	ANLWaitTop						= 'laddstalnt0';
	ANLSlideDown					= 'laddstaldn0';
}

function SwitchAnims()
{
	// Nothing in hand
	if( WeaponStance == 0 )
	{
		AWait						= 'waitStAlFd0';
		AWalk						= 'walkstalfd0';
		AWalkCrouch					= 'WalkCrAlFd0';
		AJogg						= 'JoggStAlFd0';
		AJoggCrouch					= 'JoggCrAlFd0';

		AWaitCrouch					= 'waitCrAlFd0';
		AWaitCrouchIn				= 'WaitCrAlBg0';
		ARappelWait					= 'raplstalnt0';
		ASplitWait					= 'spltstalnt0';

		AGrabStart					= 'grabstalbg0';
		AGrabWait					= 'grabstalnt0';
		AGrabSqeeze					= 'GrabStAlIn0';
		AGrabRelease				= 'grabstalEd0';
		AGrabReleaseKnock			= 'grabstalko0';
		AGrabRetinalStart			= 'grabstcpbg0';
		AGrabRetinalWait			= 'grabstcpnt0';
		AGrabRetinalEnd				= 'grabstcped0';
		ABlendGrab.m_backward		= 'grabstalbk0';
	}

	// One handed weapon
	else if( WeaponStance == 1 )
	{
		AWait						= 'waitStSpFd1';

		AWaitCrouch					= 'waitCrSpFd1';
		AWaitCrouchIn				= 'WaitCrSpbg1';

		AReload						= 'ReloStSpFd1';
		AReloadCrouch				= 'ReloCrSpFd1';
		ARappelWait					= 'RaplStSpNt1';
		ASplitWait					= 'SpltStSpNt1';

		AGrabStart					= 'grabstalbg1';
		AGrabWait					= 'grabstalnt1';
		AGrabSqeeze					= 'GrabStAlIn1';
		AGrabRelease				= 'grabstalEd1';
		AGrabReleaseKnock			= 'grabstalko1';
		AGrabRetinalStart			= 'grabstcpbg1';
		AGrabRetinalWait			= 'grabstcpnt1';
		AGrabRetinalEnd				= 'grabstcped1';
		ABlendGrab.m_backward		= 'grabstalbk1';
	}

	// Maingun
	else
	{
		AWait						= 'waitStSpFd2';

		AWaitCrouch					= 'waitCrSpFd2';
		AWaitCrouchIn				= 'WaitCrSpbg2';

		AReload						= 'ReloStSpFd2';
		AReloadCrouch				= 'ReloCrSpFd2';
		ARappelWait					= 'RaplStSpNt2';
		ASplitWait					= 'SpltStSpNt2';
	}

	if(bIsCrouched)
	{
		ADeathForward				= 'XxxxCrAlFd0';
		ADeathBack					= 'XxxxCrAlBk0';
		ADeathLeft					= 'XxxxCrAlLt0';
		ADeathRight					= 'XxxxCrAlRt0';
		ADeathDown					= 'XxxxCrAlDn0';
	}
	else
	{
		ADeathForward				= 'XxxxStAlFd0';
		ADeathBack					= 'XxxxStAlBk0';
		ADeathLeft					= 'XxxxStAlLt0';
		ADeathRight					= 'XxxxStAlRt0';
		ADeathDown					= 'XxxxStAlDn0';
	}
}

function Tick( float DeltaTime )
{
	local EInteractObject Interaction;
	ForEach TouchingActors(class'EInteractObject', Interaction)
		Interaction.Touch(self);

	if( BodyFlames.Length > 0 )
	{
		if( FireTimer <= 0 )
			FireTimer = 1.f;
		else
		{
			FireTimer -= DeltaTime;

			if( FireTimer <= 0 )
				AttenuateFire(1.f);
		}
	}

	Super.Tick(DeltaTime);
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector Hitlocation, vector HitNormal, Vector momentum, class<DamageType> damageType, optional int PillTag )
{
	local Controller Killer;
	local EPlayerController EPC;
	local vector crossRes;
	local bool bAlreadyDead;
	local int sideDamage;
	bAlreadyDead	= (Health <= 0);

	if ( IsPlaying(Sound'Electronic.Play_Sq_ComputerKeyBoard')) //Stop keyboard sound when hit.
		PlaySound(Sound'Electronic.Stop_Sq_ComputerKeyBoard', SLOT_SFX);

	if(	Controller == None ||
		eGame.pPlayer.bInvincible ||
		(bKeepNPCAlive && Health == 1)) // in trans and already at minimum: dont play sound or shake
		return;

	// Experimental
	EPC = EPlayerController(Controller);
	if((Vector(Controller.Rotation) cross momentum).Z > 0.0)
		sideDamage = 1;
	else
		sideDamage = -1;

	if( damageType == class'Crushed' )
		EPC.m_camera.Shake(sideDamage * 800, 20000, 5000);
	else if( damageType == None )
		EPC.m_camera.Hit(sideDamage * 500, 3000);
	else
		EPC.m_camera.Shake(200, 10000, 2500);

	// Blood effect
	if( damageType == None )
		Spawn(class'EBloodSplat', self,, HitLocation, Rotator(Normal(momentum)));

	// Check to be sure there is a pill .. else, use body pill
	if( PillTag == 0 )
		PillTag = GetApproxPillFromHit(HitLocation);

	// Gives real damage depending on the hit zone
	ResolveDamage(damage, PillTag, damageType);
	
	//Play HitSound depending on the pill
	if ( damageType == none )
	{
		if (PillTag == 1) //head
			PlaySound(Sound'GunCommon.Play_BulletHitHead', SLOT_SFX);
		else //rest of body
			PlaySound(Sound'GunCommon.Play_Random_BulletHitBody', SLOT_SFX);
	}
	// If knocked but not on head
	else if( damageType.name == 'EKnocked' && PillTag != P_Head )
		damageType = None;

	// In all case, spawn flames on burned actor
	if( damageType != None && damageType.name == 'EBurned' )
		CatchOnFire();

	// Used during transition where Sam would pop if killed
	if(!bAlreadyDead && bKeepNPCAlive)
		Health = Max(1, Health);

	// play damage animations
	if (Health > 0)
	{

		if ( damageType == None || damageType.Name == 'EKnocked' || damageType.Name == 'EElectrocuted' || damageType.Name == 'Crushed' || damageType.Name == 'EBurned' )
		{	
			if ( !IsPlaying(Sound'FisherVoice.Play_Random_FisherHitWeapon') )
				PlaySound(Sound'FisherVoice.Play_Random_FisherHitWeapon', SLOT_Barks);
		}
		else
		{
			if (!IsPlaying(Sound'FisherVoice.Play_Random_FisherCough') )
				PlaySound(Sound'FisherVoice.Play_Random_FisherCough', SLOT_Barks );
		}	
	}
	else if ( !bAlreadyDead )
	{
		SwitchAnims();
		//The controller launches the sounds because all the sounds from an actor are killed in DiedE
		EPlayerController(Controller).PlaySound(Sound'FisherVoice.Play_Random_FisherDy', SLOT_SFX);
		StartFadeOut(40.0f);
		EPlayerController(Controller).PlaySound(Sound'CommonMusic.Play_theme_FisherDeath1', SLOT_Fisher);

	    if ( instigatedBy != None )
        {
				Killer = instigatedBy.Controller;
        }

		DiedE(Killer, PillTag, momentum);
	}
}

function ResolveDamage( out int Damage, out int PillTag, out class<DamageType> damageType )
{
	if( damageType == class'ESleepingGas' && FRand() > 0.5 )
		Damage = 0;

	Super.ResolveDamage(Damage, PillTag, damageType);
}

singular event BaseChange()
{
	local EPawn npc;
	npc = EPawn(Base);
	if( npc != None )
	{
		// npc getting out of bed
		if(npc.bSleeping && npc.Physics == PHYS_RootMotion)
		{
			// Fall tru npc
			SetPhysics(PHYS_Falling);
			Move(vect(0,0,-5));
		}
		else
		npc.TakeDamage(npc.Health / 2, self, npc.Location, vect(0,0,1), vect(0,0,-1), class'EKnocked', P_Head);
	}
	else if( Base != None && Base.bFixedRotationDir && Base.RotationRate != rot(0,0,0))
	{
		// based on automatic rotating object
		SetPhysics(PHYS_Falling);
		Move(vect(0,0,-5));
	}
}

defaultproperties
{
    m_HoistOffset=(X=60.000000,Y=0.000000,Z=206.500000)
    m_HoistCrOffset=(X=57.000000,Y=0.000000,Z=179.000000)
    m_HoistFeetOffset=(X=57.000000,Y=0.000000,Z=40.000000)
    m_HoistFeetCrOffset=(X=57.000000,Y=0.000000,Z=12.500000)
    m_HoistWaistOffset=(X=57.000000,Y=0.000000,Z=109.500000)
    m_HoistWaistCrOffset=(X=57.000000,Y=0.000000,Z=82.000000)
    m_NLOutTopAnimOffset=(X=78.000000,Y=0.000000,Z=191.500000)
    m_POutTopAnimOffset=(X=85.000000,Y=45.800000,Z=192.100000)
    GearSoundFall=Sound'GearCommon.Play_MediumGearFall'
    EyeBoneName="B Head"
    UpperBodyBoneName="B Spine1"
    ABlendFence=(m_forward="FencStAlUp0",m_backward="fencstaldn0",m_forwardLeft="fencstallt0",m_forwardRight="FencStAlRt0")
    ABlendGrab=(m_forward="GrabStSpFd1",m_backward="GrabStAlBk1",m_forwardRight="GrabStSpRt1")
    ABlendSniping=(m_forward="WalkStSpFd2",m_backward="WalkStSpFd2",m_forwardLeft="WalkStSpRt2",m_forwardRight="WalkStSpRt2")
    ABlendSnipingCrouch=(m_forward="WalkCrSpFd2",m_backward="walkCrSpBk2",m_forwardLeft="walkCrSpLt2",m_forwardRight="WalkCrSpRt2")
    PawnSampleBrightness(0)=(BoneName="B Head")
    PawnSampleBrightness(1)=(BoneName="B Spine")
    PawnSampleBrightness(2)=(BoneName="B Spine1")
    PawnSampleBrightness(3)=(BoneName="B Spine2")
    PawnSampleBrightness(4)=(BoneName="B R UpperArm")
    PawnSampleBrightness(5)=(BoneName="B R Forearm")
    PawnSampleBrightness(6)=(BoneName="B R Hand")
    PawnSampleBrightness(7)=(BoneName="B L UpperArm")
    PawnSampleBrightness(8)=(BoneName="B L Forearm")
    PawnSampleBrightness(9)=(BoneName="B L Hand")
    PawnSampleBrightness(10)=(BoneName="B R Thigh")
    PawnSampleBrightness(11)=(BoneName="B R Calf")
    PawnSampleBrightness(12)=(BoneName="B R Foot")
    PawnSampleBrightness(13)=(BoneName="B L Thigh")
    PawnSampleBrightness(14)=(BoneName="B L Calf")
    PawnSampleBrightness(15)=(BoneName="B L Foot")
    DamageLookupTable(0)=33.000000
    DamageLookupTable(1)=20.000000
    DamageLookupTable(8)=17.000000
    bCanJump=true
    GroundSpeed=400.000000
    JumpZ=500.000000
    AirControl=0.100000
    CrouchHeight=60.000000
    CrouchRadius=35.000000
    Health=200
    m_NormalArmsZone=(X=0.000000,Y=0.000000,Z=35.000000)
    m_NormalArmsRadius=110.000000
    m_CrouchedArmsZone=(X=0.000000,Y=0.000000,Z=32.000000)
    m_CrouchedArmsRadius=60.000000
    m_LedgeGrabArmsZone=(X=37.000000,Y=0.000000,Z=117.000000)
    m_LedgeGrabArmsRadius=38.000000
    m_HandOverHandArmsZone=(X=0.000000,Y=0.000000,Z=128.000000)
    m_HandOverHandArmsRadius=16.000000
    m_NarrowLadderArmsZone=(X=37.000000,Y=0.000000,Z=102.500000)
    m_NarrowLadderArmsRadius=15.000000
    m_PipeArmsZone=(X=37.000000,Y=0.000000,Z=90.000000)
    m_PipeArmsRadius=20.000000
    m_ZipLineArmsZone=(X=0.000000,Y=0.000000,Z=110.000000)
    m_ZipLineArmsRadius=20.000000
    m_FenceArmsZone=(X=36.000000,Y=0.000000,Z=89.000000)
    m_FenceArmsRadius=30.000000
    m_NormalFeetZone=(X=0.000000,Y=0.000000,Z=-85.000000)
    m_NormalFeetRadius=60.000000
    m_CrouchedFeetZone=(X=0.000000,Y=0.000000,Z=-50.000000)
    m_CrouchedFeetRadius=60.000000
    m_PoleArmsZone=(X=40.000000,Y=0.000000,Z=100.000000)
    m_PoleArmsRadius=30.000000
    bTravel=true
    bIsPlayerPawn=true
}
