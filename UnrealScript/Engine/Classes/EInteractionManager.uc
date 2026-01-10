////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name: InteractionManager
//
// Description: Manager of in-game interactions
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

class EInteractionManager extends Actor;

const MAXITEM = 5;
var int             SelectedInteractions;
var array<EInteractObject> Interactions;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SelectedInteractions = -1;
}

function int GetNbInteractions()
{
	return Interactions.Length;
}

function EInteractObject GetCurrentInteraction()
{
	//Log("GetCurrentInteraction"@Interactions.Length@SelectedInteractions@Interactions[SelectedInteractions]);
	return Interactions[SelectedInteractions];
}

function bool IsPresent(class<EInteractObject> InteractionClass, out EInteractObject InteractObj)
{
	local int i;
	for (i = 0; i < Interactions.Length; i++)
	{
		if (Interactions[i].class == InteractionClass)
		{
			InteractObj = Interactions[i];
			return true;
		}
	}
}

function bool SelectNextItem()
{
	if (SelectedInteractions < Interactions.Length - 1)
	{
		SelectedInteractions++;
		return true;
	}
	else
	{
		SelectedInteractions = 0;
		return true;
	}
	return false;
}

function bool SelectPreviousItem()
{
	if (SelectedInteractions > 0)
	{
		SelectedInteractions--;
		return true;
	}
	else
	{
		SelectedInteractions = Interactions.Length - 1;
		return true;
	}
	return false;
}

function ShowExit(EInteractObject ExitInt)
{
	if (ExitInt != None)
	{
		Interactions.Insert(0,1);
		Interactions[0] = ExitInt;
	}
	else
	{
		Interactions.Remove(0,1);
	}
}

function Calc(EInteractObject Obj, out float Dot, out float Dist)
{
	local vector interactionDir, tmpLoc;

	tmpLoc = Obj.InteractionPlayerController.Pawn.Location;
	tmpLoc.Z = Obj.Location.Z;
	interactionDir = Obj.Location - tmpLoc;
	// get distance
	Dist = VSize(interactionDir);

	interactionDir = Normal(interactionDir);

	// get dot result
	Dot = interactionDir DOT Vector(Obj.InteractionPlayerController.Pawn.Rotation);
}

//------------------------------------------------------------------------
// Description
//		0 - return, 1 - insert, 2 - replace, 3 - do nothing
//------------------------------------------------------------------------
function int CheckPriority(EInteractObject CurrentObj, EInteractObject NewObj)
{
	local float CurrentDot, NewDot, CurrentDist, NewDist;

	// interaction already queued
	if (NewObj == CurrentObj)
		return 0;

	// different priority, insert new before current
	if (NewObj.iPriority < CurrentObj.iPriority)
		return 1;

	// if same class and same priority, look for priority based on distance and direction
	// else let it be filtered by upper if case.
	if (NewObj.class == CurrentObj.class && NewObj.iPriority == CurrentObj.iPriority)
	{
		Calc(NewObj, NewDot, NewDist);
		Calc(CurrentObj, CurrentDot, CurrentDist);

		if (NewDot > CurrentDot)
			return 2;
		else
			return 0;
	}

	return 3;
}

function AddInteractionObj(EInteractObject Object)
{
	local int i;
	local int Res;

	for (i = 0; i < Interactions.Length; i++)
	{
		// check and compare priority
		Res = CheckPriority(Interactions[i], Object);
		switch (Res)
		{
		case 0:
			//Log("Already queued["$Object.Owner$"]["$Object.iPriority$"] at position["$i$"]");
			return;

		case 1:
			if (Interactions.Length >= MAXITEM)
				return;

			//Log("Inserting ["$Object.Owner$"]["$Object.iPriority$"] at position["$i$"]");
			Interactions.Insert(i, 1);
			Interactions[i] = Object;
			return;

		case 2:
			//log("Interaction["$Object.Owner$"]["$Object.iPriority$"] to replace higher priority["$Interactions[i].Owner$"]["$Interactions[i].iPriority$"]");
			Interactions[i] = Object;
			return;
		}
	}

	if (Interactions.Length >= MAXITEM)
		return;

	// Enqueue new interaction
	//Log("Interaction["$Object.Owner$"]["$Object.iPriority$"] enqueued");
	Interactions.Length = Interactions.Length + 1;
	Interactions[Interactions.Length - 1] = Object;
}

function RemoveInteractionObj(EInteractObject Object)
{
	local int  i;
	for (i = 0; i < Interactions.Length; i++)
	{
		if (Interactions[i] == Object)
		{
			//Log("REmoving interaction"@Object@Object.owner);
			Interactions.Remove(i,1);
			break;
		}
	}

	// If removed interaction is the selected one
	if (SelectedInteractions == GetNbInteractions())
		SelectedInteractions = GetNbInteractions() - 1;
}

defaultproperties
{
    bHidden=True
}