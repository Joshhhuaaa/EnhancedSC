class EAntennaSwitchAba extends ESwitchObject;

state s_On
{
	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		if( Other.IsA('EPattern') )
		{
			if( Interaction != None )
				Interaction.SetCollision(!Interaction.bCollideActors);
			return;
		}

		Super.Trigger(Other, EventInstigator, InTag);
	}
}

state s_Off
{
	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		if( Other.IsA('EPattern') )
		{
			if( Interaction != None )
				Interaction.SetCollision(!Interaction.bCollideActors);
			return;
		}

		Super.Trigger(Other, EventInstigator, InTag);
	}
}
