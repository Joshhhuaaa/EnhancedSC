class ELightSwitch extends ESwitchObject;

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var	EGameplayObject	Button;
var	StaticMesh		ButtonMesh;
var vector			ButtonOffset;

function PostBeginPlay()
{
    local int i;

	Button = spawn(class'EGameplayObject', self,, ToWorld(ButtonOffset));
	if( Button == None )
		log("Problem with ELightSwitch"@self@"spawning button");
	Button.SetStaticMesh(ButtonMesh);
	Button.SetCollision(false);
	Button.bDamageable = false;

	if( TriggeredObjects.Length == 0 )
    {
		Log(self$" should have at least one light attached to");
    }
    else // Remove for retail!
    {
        // 
        for(i = 0; i < TriggeredObjects.Length; i++)
        {
            if((TriggeredObjects[i] != None)
                && (TriggeredObjects[i].IsA('ELight')))
            {
                log(self@"links directly to"@TriggeredObjects[i]@". Switches should link to the EGamplayObjectLight instead");
            }
        }
    }

	Super.postBeginPlay();
}

function Destroyed()
{
	if( Button != None )
		Button.Destroy();
	Super.Destroyed();
}

auto state s_On
{
	function BeginState()
	{
		Button.SetRotation(Rotation+Rot(8191,0,0));
		
		Super.BeginState();
	}
}

state s_Off
{
	function BeginState()
	{
		Button.SetRotation(Rotation-Rot(8191,0,0));

		Super.BeginState();
	}
}

defaultproperties
{
    ButtonMesh=StaticMesh'EMeshIngredient.Object.LightSwitchButton'
    ButtonOffset=(X=2.000000,Y=0.000000,Z=0.000000)
    StaticMesh=StaticMesh'EMeshIngredient.Object.LightSwitch'
    CollisionRadius=2.000000
}