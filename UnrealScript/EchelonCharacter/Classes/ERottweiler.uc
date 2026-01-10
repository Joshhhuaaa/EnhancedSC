//===============================================================================
//  [ERottweiler]
//
//	Nasty dawg.
//
//===============================================================================

class ERottweiler extends EDog;

#exec OBJ LOAD FILE=..\Animations\EDog.ukx PACKAGE=EDog

defaultproperties
{
    DogBark=Sound'Dog.Play_random_DogBark'
    DogAttack=Sound'Dog.Play_random_DogAttack'
    PlayBreath=Sound'Dog.Play_DogBreath'
    StopBreath=Sound'Dog.Stop_DogBreath'
    DogHit=Sound'Dog.Play_random_DogHit'
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'EDog.RottMesh'
}