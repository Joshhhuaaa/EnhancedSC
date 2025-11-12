class EPatternTrigger extends Actor
	placeable;

var	   bool				 bAlreadyVisited;
var	   float			 TriggerTime;

var()  bool			     bTriggerOnlyOnce;
var()  class<EPattern>   PatternClass;
var()  bool				 bLinkedToAGroup;
var()  Name				 GroupTag;
var()  Name				 JumpLabel;
var()  bool				 bEventExclusivity;  //It means we want our scripted event the only one to filter event

var EPattern			 Pattern;

/*-----------------------------------------------------------*\
|															 |
| Touch                                                      |
|                                                            |
\*-----------------------------------------------------------*/
function PostBeginPlay()
{ 
	bAlreadyVisited = false;

	if (!bLinkedToAGroup)
	{
		//spawn and start the pattern
		Pattern  = Spawn(PatternClass,self);

	}
}




/*-----------------------------------------------------------*\
|															 |
| Touch                                                      |
|                                                            |
\*-----------------------------------------------------------*/
function Touch(actor Other)
{
	local vector HitNormal, HitLocation;

	local EGroupAI Group;
	local Pawn P;

	//cast the actor in Pawn
	P = Pawn(Other);
	if (P != None)
	{
		//if (Level.TimeSeconds - TriggerTime < 0.2)
		//	return;
		//TriggerTime = Level.TimeSeconds;

		//check if the player is colliding
		if (P.controller.bIsPlayer)
		{
			if (Pattern != None)
			{
				if (!Pattern.PatternIsRunning())
				{
					// make sure not touching through wall
					if (Trace(HitNormal, HitLocation, Other.Location, Location, true, vect(0,0,0)) == Other)
					{
						if (!((bAlreadyVisited) && (bTriggerOnlyOnce)))
						{
							bAlreadyVisited = true;
							Pattern.StartPattern(JumpLabel);
						}
					}
				}
			}
			else
			{
				// make sure not touching through wall
				if (Trace(HitNormal, HitLocation, Other.Location, Location, true, vect(0,0,0)) == Other)
				{
					if (!((bAlreadyVisited) && (bTriggerOnlyOnce)))
					{
						bAlreadyVisited = true;

						if (bLinkedToAGroup)
						{
							log("Pattern trigger "$self$" was touched and will try to match group "$GroupTag);
							//try to find the groupAI
							foreach DynamicActors(class'EGroupAI', Group, GroupTag)
							{
								log("Group "$Group$" found...");						
								Group.RequestPatternChange(PatternClass,bEventExclusivity);
								break; 
							}			
						}
						
					}
				}
			}
		}
	}
}

defaultproperties
{
    bTriggerOnlyOnce=true
    bEventExclusivity=true
    bHidden=true
    CollisionRadius=40.000000
    CollisionHeight=40.000000
    bCollideActors=true
}