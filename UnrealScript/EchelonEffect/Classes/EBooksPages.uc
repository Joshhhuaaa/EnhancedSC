class EBooksPages extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=BooksPages
        StaticMesh=StaticMesh'EGO_OBJ.GenObjGO.BooksPaage'
        RenderTwoSided=True
        Acceleration=(Z=-300.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOut=True
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.500000),Y=(Max=0.500000),Z=(Max=0.250000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.600000,Max=0.600000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=-50.000000),Y=(Min=50.000000,Max=-50.000000),Z=(Min=150.000000,Max=200.000000))
        VelocityLossRange=(Z=(Min=2.000000,Max=5.000000))
        Name="BooksPages"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.BooksPages'
    bUnlit=false
}