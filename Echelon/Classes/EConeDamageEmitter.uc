class EConeDamageEmitter extends Emitter;

var()	float				SprayDistance;
var()	int					SprayDamage;
var()	class<damageType>	DamageType;
var()	float				StopDamageTime;

var		float				ElapsedTime;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// optimization
	SetCollisionSize(1.5f*SprayDistance, 100.f);
	SetTimer(0.2f, true);
}

function Touch( Actor Other )
{
	//Log("Touch");
	if( Other.bIsPawn )
		GotoState('s_RayTracing');
}
function UnTouch( Actor Other )
{
	local int i;
	//Log("UnTouch");
	for( i=0; i<Touching.Length; i++ )
	{
		if( Touching[i].bIsPawn )
			return;
	}
		GotoState('');
}

function Tick( float DeltaTime )
{
	if( StopDamageTime == 0 )
		return;

	ElapsedTime += DeltaTime;
	if( ElapsedTime > StopDamageTime )
		StopDamage();
}

function StopDamage()
	{
	//LOG("DAMAGE TIMER STOPPED"@StopDamageTime);
	Disable('Tick');
	Disable('Touch');
	Disable('UnTouch');
	GotoState('');
}

state s_RayTracing
{
	function Timer()
	{
		local EPawn P;
		local vector EmittingDir, PawnDir, TestLocation;
		local float DotP;

		//Log("Timer CONE");

		EmittingDir = Vector(Rotation);

		ForEach VisibleCollidingActors(class'EPawn', P, SprayDistance)
		{
			TestLocation = P.Location;
			PawnDir = Normal(TestLocation - Location);
			DotP = EmittingDir Dot PawnDir;
			//log("hitting"@P@DotP);
			// If we're not in range, try on head
			if( DotP <= 0.75 )
			{
				TestLocation += 0.8f * P.CollisionHeight * Vect(0,0,1);
				PawnDir = Normal(TestLocation - Location);
				DotP = EmittingDir Dot PawnDir;
			}

			//log("hitting"@P@DotP);
			if( DotP > 0.75 )
				P.TakeDamage(SprayDamage, None, P.Location, Vect(0,0,0), Vect(0,0,0), DamageType);
		}
	}
}

defaultproperties
{
    SprayDistance=150.000000
    SprayDamage=2
    DamageType=Class'ESleepingGas'
    bCollideActors=true
    bDirectional=true
}