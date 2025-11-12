class EGObjectGroup extends Actor
	placeable
	native;


var bool bIsDead;
var int	 CurrentIndex;

var() Name			ObjectsTag;

var array<Actor>	ItemsToDestroy;



//---------------------------------------[Frederic Blais - 14 NOV 2001]-----
// 
// Description
//
//------------------------------------------------------------------------
function PostBeginPlay()
{
	local Actor A;
	local int	i;

	i = 0;
	CurrentIndex = 0;

	foreach AllActors(class'Actor', A, ObjectsTag)
	{
		ItemsToDestroy[i] = A;
		i++;
	}

}

//---------------------------------------[Frederic Blais - 14 NOV 2001]-----
// 
// Description
//
//------------------------------------------------------------------------
event Actor GetCurrentTarget()
{
	return ItemsToDestroy[CurrentIndex];
}


//---------------------------------------[Frederic Blais - 14 NOV 2001]-----
// 
// Description
//
//------------------------------------------------------------------------
event Actor GetNextTarget()
{
	CurrentIndex++;

	if (CurrentIndex < ItemsToDestroy.Length)
	{
		return ItemsToDestroy[CurrentIndex];
	}
	else
	{
		bIsDead = true;
		return None;
	}
}

defaultproperties
{
    bHidden=true
}