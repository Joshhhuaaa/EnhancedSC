class ERainDropEmitter extends Emitter;

var		BYTE	bIsInRainVolume;
var		Actor	Camera;
var		Vector  Offset;


function PostBeginPlay()
{
	bIsInRainVolume = IsLocationInRainVolume(Camera.Location);

	if (bIsInRainVolume == 0)
	{
		bHidden = true; 
		// we should also shut down the emitter from processing, 
		// even though its not being drawn anymore.
		GotoState('s_Dry');
	}
	else
	{
		bHidden = false;
		GotoState('s_Rain');
	}
}




state s_Rain
{
	function Tick(float deltaTime)
	{
		bIsInRainVolume = IsLocationInRainVolume(Camera.Location);

		if (bIsInRainVolume == 0)
		{
			bHidden = true;
			// we should also shut down the emitter from processing, 
			// even though its not being drawn anymore.
			GotoState('s_Dry');
		}

		SetLocation(Camera.Location);
	}
}

state s_Dry
{
	function Tick(float deltaTime)
	{
		bIsInRainVolume = IsLocationInRainVolume(Camera.Location);

		if (bIsInRainVolume == 1)
		{
			bHidden = false;
			GotoState('s_Rain');
		}
	}
}




/*
Begin Map
Begin Actor Class=Emitter Name=Emitter1
    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'EMeshSFX.Item.RainDots'
        RenderTwoSided=True
        MaxParticles=200
        StartLocationRange=(X=(Min=-75.000000,Max=75.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=-100.000000,Max=100.000000))
        StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=2.500000,Max=50.000000))
        DrawStyle=PTDS_AlphaModulate_MightNotFogCorrectly
        LifetimeRange=(Min=0.600000,Max=0.600000)
        StartVelocityRange=(Z=(Min=-700.000000,Max=-700.000000))
        Name="MeshEmitter0"
    End Object
    Emitters(0)=MeshEmitter'MyLevel.MeshEmitter0'
    bDynamicLight=True
    LastRenderTime=11.996189
    Tag="Emitter"
    Level=EchelonLevelInfo'MyLevel.LevelInfo0'
    Region=(Zone=EchelonLevelInfo'MyLevel.LevelInfo0',iLeaf=44,ZoneNumber=2)
    PhysicsVolume=PhysicsVolume'MyLevel.PhysicsVolume2'
    Location=(X=-109.000000,Y=-909.000000,Z=332.000000)
    AmbientGlow=102
    bSelected=True
    Name="Emitter1"
End Actor
Begin Surface
End Surface
Begin GE
End GE
End Map
*/

defaultproperties
{
	Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'EMeshSFX.Item.RainDots'
        RenderTwoSided=True
        MaxParticles=200
        StartLocationRange=(X=(Min=-75.000000,Max=75.000000),Y=(Min=-75.000000,Max=75.000000),Z=(Min=-100.000000,Max=100.000000))
        StartSizeRange=(X=(Max=2.000000),Y=(Max=2.000000),Z=(Min=2.500000,Max=50.000000))
        DrawStyle=PTDS_AlphaModulate_MightNotFogCorrectly
        LifetimeRange=(Min=0.600000,Max=0.600000)
        StartVelocityRange=(Z=(Min=-700.000000,Max=-700.000000))
        Name="MeshEmitter0"
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'
    bDynamicLight=true
    AmbientGlow=102
}