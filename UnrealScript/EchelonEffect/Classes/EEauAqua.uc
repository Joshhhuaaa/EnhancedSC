class EEauAqua extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=EauAqua
        StaticMesh=StaticMesh'EMeshSFX.Item.AquaEau'
        RenderTwoSided=True
        Acceleration=(Z=-700.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=150
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.500000,RelativeSize=2.500000)
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.water.Aqua_Eau'
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=25.000000,Max=200.000000))
        Name="EauAqua"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.EauAqua'
    bUnlit=False
}