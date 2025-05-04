//===============================================================================
//  [EDoberman] 
//
//	Nasty dawg.
//
//===============================================================================

class EDoberman extends EDog;

#exec OBJ LOAD FILE=..\Animations\EDog.ukx PACKAGE=EDog

#exec MESH CLEARPILLINFO	MESH=dobeMesh

// left rear leg
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Toe0"		X=1.3 Y=-0.5 Z=0.3
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Foot"		X=-0.4 Y=-0.5 Z=-0.3
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Calf"		X=1.4 Y=-3.4 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Calf"		X=2.4 Y=2.4 Z=-0.6
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Calf"		X=-3.6 Y=-2.4 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Calf"		X=0 Y=3.1 Z=-0.5
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Thigh"	X=12.2 Y=-5.3 Z=1.1
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Thigh"	X=7.7 Y=3.4 Z=0.0

// right rear leg
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Toe0"		X=1.3 Y=-0.5 Z=-0.3
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Foot"		X=-0.4 Y=-0.5 Z=0.3
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Calf"		X=1.4 Y=-3.4 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Calf"		X=2.4 Y=2.4 Z=0.6
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Calf"		X=-3.6 Y=-2.4 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Calf"		X=0 Y=3.1 Z=0.5
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Thigh"	X=12.2 Y=-5.3 Z=-1.1
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Thigh"	X=7.7 Y=3.4 Z=0.0

// body
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Spine"		X=-8.9 Y=-5.9 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Spine1"		X=1.2 Y=-6.6 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Spine1"		X=11.5 Y=-8.5 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Neck"		X=-9.1 Y=1.4 Z=0.0

// left front leg
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Finger0"	X=0.8 Y=0.0 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Hand"		X=-2.2 Y=0.8 Z=0.6
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L Forearm"	X=2.3 Y=-1.2 Z=1.6
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik L UpperArm"	X=1.3 Y=1.9 Z=0.9

// right front leg
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Finger0"	X=0.8 Y=0.0 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Hand"		X=-2.2 Y=0.8 Z=-0.6
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R Forearm"	X=2.3 Y=-1.2 Z=-1.6
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik R UpperArm"	X=1.3 Y=1.9 Z=-0.9

// neck / head / nose / jaw
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Neck"		X=3.9 Y=2.7 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Head"		X=-5.3 Y=0.1 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Head"		X=0.5 Y=-5.1 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Head"		X=1.5 Y=-12.3 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGik Head"		X=1.6 Y=-20.1 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGb Jaw"			X=0.0 Y=4.9 Z=-3.3
#exec MESH ADDPILLVERTEX	MESH=dobeMesh	BONE="DOGb Jaw"			X=0.0 Y=12.4 Z=-6.8

// left rear leg
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=0 VERTEX2=1 RADIUS=3.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=1 VERTEX2=2 RADIUS=3.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=1 VERTEX2=3 RADIUS=3.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=4 VERTEX2=6 RADIUS=5.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=5 VERTEX2=7 RADIUS=4.0 TAG=6 PRIORITY=1

// right rear leg
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=8  VERTEX2=9  RADIUS=3.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=9  VERTEX2=10 RADIUS=3.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=9  VERTEX2=11 RADIUS=3.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=12 VERTEX2=14 RADIUS=5.0 TAG=6 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=13 VERTEX2=15 RADIUS=4.0 TAG=6 PRIORITY=1

// body
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=16 VERTEX2=17 RADIUS=11.0 TAG=2 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=18 VERTEX2=19 RADIUS=14.0 TAG=2 PRIORITY=1

// left front leg
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=20 VERTEX2=21 RADIUS=3.0 TAG=3 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=21 VERTEX2=22 RADIUS=4.0 TAG=3 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=22 VERTEX2=23 RADIUS=5.0 TAG=3 PRIORITY=1

// right front leg
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=24 VERTEX2=25 RADIUS=3.0 TAG=3 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=25 VERTEX2=26 RADIUS=4.0 TAG=3 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=26 VERTEX2=27 RADIUS=5.0 TAG=3 PRIORITY=1


// neck / head / nose / jaw
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=28 VERTEX2=29 RADIUS=8.0 TAG=1 PRIORITY=1
#exec MESH ADDSPHEREPILL	MESH=dobeMesh	VERTEX=30 RADIUS=9.0	TAG=1 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=31 VERTEX2=32 RADIUS=4.0 TAG=1 PRIORITY=1
#exec MESH ADDCYLINDERPILL	MESH=dobeMesh	VERTEX1=33 VERTEX2=34 RADIUS=3.0 TAG=1 PRIORITY=1

#exec MESH PILLCOPY MESH1=dobeMesh MESH2=RottMesh

#exec SAVEPACKAGE FILE=..\Animations\EDog.ukx PACKAGE=EDog

defaultproperties
{
    DogBark=Sound'Dog.Play_random_DogBark'
    DogAttack=Sound'Dog.Play_random_DogAttack'
    PlayBreath=Sound'Dog.Play_DogBreath'
    StopBreath=Sound'Dog.Stop_DogBreath'
    DogHit=Sound'Dog.Play_random_DogHit'
    PlayerFarDistance=101.000000
    PlayerCloseDistance=100.000000
    PlayerVeryCloseDistance=90.000000
    IntuitionTime=10.750000
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'EDog.dobeMesh'
}