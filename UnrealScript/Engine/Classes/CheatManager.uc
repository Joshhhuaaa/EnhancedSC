//=============================================================================
// CheatManager
// Object within playercontroller that manages "cheat" commands
// only spawned in single player mode
//=============================================================================

class CheatManager extends Object within PlayerController
	native;

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// ***********************************************************************************************
var bool bGhost;
var Actor RadiiActorList[8];
var int iCurViewActor;

/* 
Scale the player's size to be F * default size
*/
exec function ChangeSize( float F )
{
	if ( Pawn.SetCollisionSize(Pawn.Default.CollisionRadius * F,Pawn.Default.CollisionHeight * F) )
	{
		Pawn.SetDrawScale(F);
		Pawn.SetLocation(Pawn.Location);
	}
}

exec function CauseEvent( name EventName )
{
	TriggerEvent( EventName, Pawn, Pawn);
}

exec function Fly()
{
	Pawn.SetCollision(true, true , true);
	Pawn.bCollideWorld = true;
	Outer.GotoState('PlayerFlying');
}

exec function Walk()
{	
	if ( Pawn != None )
	{
		Pawn.SetCollision(true, true , true);
		Pawn.SetPhysics(PHYS_Walking);
		Pawn.bCollideWorld = true;
		ClientReStart();
	}
}

exec function ToggleGhost()
{
	if( Level.Pauser != None || bStopInput )
		return;
	if( Pawn.Controller == None && !bGhost )
		return;

	if(bGhost)
		Walk();
	else
		Ghost();
	bGhost = !bGhost;
}

exec function Ghost()
{
	Pawn.SetCollision(false, false, false);
	Pawn.bCollideWorld = false;
	Outer.GotoState('PlayerFlying');
}

exec function Invisible(bool B)
{
	Pawn.bHidden = B;

	if (B)
		Pawn.Visibility = 0;
	else
		Pawn.Visibility = Pawn.Default.Visibility;
}

/* Avatar()
Possess a pawn of the requested class
*/
exec function Avatar( string ClassName )
{
	local class<actor> NewClass;
	local Pawn P;
		
	NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
	if( NewClass!=None )
	{
		Foreach DynamicActors(class'Pawn',P)
		{
			if ( (P.Class == NewClass) && (P != Pawn) )
			{
				if ( Pawn.Controller != None )
					Pawn.Controller.PawnDied();
				Possess(P);
				break;
			}
		}
	}
}

exec function Summon( string ClassName )
{
	local class<actor> NewClass;
	local vector SpawnLoc;

	log( "Fabricate " $ ClassName );
	NewClass = class<actor>( DynamicLoadObject( ClassName, class'Class' ) );
	if( NewClass!=None )
	{
		if ( Pawn != None )
			SpawnLoc = Pawn.Location;
		else
			SpawnLoc = Location;
		Spawn( NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
	}
}

exec function PlayersOnly()
{
	Level.bPlayersOnly = !Level.bPlayersOnly;
}

exec function CheatView( class<actor> aClass, optional bool bQuiet )
{
	ViewClass(aClass,bQuiet, true);
}

// ***********************************************************
// Changing viewtarget

exec function ViewSelf(optional bool bQuiet)
{
	if ( Pawn != None )
		SetViewTarget(Pawn);
	else
		SetViewtarget(outer);
	FixFOV();
}

exec function ViewClass( class<actor> aClass, optional bool bQuiet, optional bool bCheat )
{
	local actor other, first;
	local bool bFound;

	first = None;
	ForEach AllActors( aClass, other )
	{
		if ( bFound || (first == None) )
		{
			first = other;
			if ( bFound )
				break;
		}
		if ( other == ViewTarget ) 
			bFound = true;
	}  

	if ( first != None )
	{
		SetViewTarget(first);

		FixFOV();
	}
	else
		ViewSelf(bQuiet);
}

// ***********************************************************************************************
// * Purpose : For Viewing Targets in a radius outwards from player 
//		Only for Pawns - won't show a Pawn if it doesn't have a Controller. (no cams/turrets/dead ppl)
// ***********************************************************************************************
exec function ViewClassRadii( class<actor> aClass )
{
	local Actor CurActor;
	local int i;
	local float MinimumDistance, CurSize, CurrentActorDistance;

	// if list is empty, fill radiiactorlist with actors moving outwards from player
	if ( RadiiActorList[0] == none )
	{
		MinimumDistance = 0.0f;
		
		for ( i = 0; i < 8; i++ )
		{
			CurrentActorDistance = 1000000.0f;
			
			foreach AllActors( aClass, CurActor )
			{
				if ( Pawn(CurActor) != none && Pawn(CurActor).Controller != none )
				{
					CurSize = VSize(CurActor.Location - Pawn.Location);
					
					if ( CurSize > MinimumDistance && CurSize < CurrentActorDistance )
					{
						//log(i $ "==>  Considering actor:  "$ CurActor $ "   at Distance : " $ CurSize $ 
						//	"  within minimum / currentactor distances[ " $ MinimumDistance $ "," $ CurrentActorDistance $ "]");
						
						RadiiActorList[i] = CurActor;
						CurrentActorDistance = CurSize;
					}
				}					
			}		

			MinimumDistance = CurrentActorDistance;
		}
	}

	// list is built

	if ( iCurViewActor < 8 && RadiiActorList[iCurViewActor] != none )
	{
		SetViewTarget(RadiiActorList[iCurViewActor]);

		iCurViewActor++;

		ViewTarget.BecomeViewTarget();

		FixFOV();
	}
	else
	{
		// return to player view, clear the list so it will be rebuilt
		//log("Rebuilding List....");
		
		SetViewTarget(Pawn);
		iCurViewActor = 0;
		for ( i = 0; i < 8; i++ )
			RadiiActorList[i] = none;
	}

}


// dkalina - set viewtarget to actor specified by name or tag
exec function ShowActor(name InName)
{
	local Pawn NameMatch;
	local Actor Match;

	// try to match by name

	foreach DynamicActors(class'Pawn', NameMatch)
	{
		if ( NameMatch.Name == InName )
			Match = NameMatch;
	}

	// try by tag if there's no name match

	if ( Match == none )
		Match = GetMatchingActor(InName);

	if ( Match == none )
		return;

	SetViewTarget(Match);
	ViewTarget.BecomeViewTarget();
	FixFOV();
}


