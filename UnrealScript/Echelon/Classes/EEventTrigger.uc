class EEventTrigger extends Actor
	placeable;


var() enum EProximity
{
	PlayerProximity,
	NPCProximity,
	PawnProximity

} ProximityType;



var	   bool				 bAlreadyVisited;
var	   float			 TriggerTime;

var()  Name				 GroupTag;
var()  Name				 JumpLabel;
var()  bool			     bTriggerOnlyOnce;
var()  bool				 bAffectLastZone;
var()  bool				 bForceJump; 			// Override disable messages of the pattern
var()  bool				 ConversationTrigger;
var()  bool				 bNPCMustBeConscious;	// Joshua - If true, NPCProximity only triggers for conscious NPCs

/*-----------------------------------------------------------*\
|															 |
| IsRelevant                                                 |
|                                                            |
\*-----------------------------------------------------------*/
function bool IsRelevant(actor Other)
{
	switch (ProximityType)
	{
		case PlayerProximity:
			return Other.bIsPawn && Pawn(Other).IsPlayerPawn();
		case NPCProximity:
			if (!Other.bIsPawn || EAIController(Pawn(Other).controller) == None)
				return false;
			// Joshua - Reject unconscious, carried, or dead NPCs
			if (bNPCMustBeConscious &&
				!((EAIController(Pawn(Other).controller).GetStateName() != 's_Unconscious') &&
				  (EAIController(Pawn(Other).controller).GetStateName() != 's_Carried') &&
				  (Pawn(Other).Health > 0)))
				return false;
			return true;
		case PawnProximity:
			return Other.bIsPawn;
	}
}



/*-----------------------------------------------------------*\
|															 |
| Touch                                                      |
|                                                            |
\*-----------------------------------------------------------*/
function Touch(actor Other)
{
	local EGroupAI Group;
	local Pawn P;

	//if (ConversationTrigger && EchelonLevelInfo(Level).MusicObj.GetStateName() != 'Idle')
	//	return;

	if (!((bAlreadyVisited) && (bTriggerOnlyOnce)))
	{
		if (IsRelevant(Other))
		{
			//if (Level.TimeSeconds - TriggerTime < 0.2)
			//	return;
			//TriggerTime = Level.TimeSeconds;

			//set visited flag
			bAlreadyVisited = true;

			foreach DynamicActors(class'EGroupAI', Group, GroupTag)
			{
				Group.SendJumpEvent(JumpLabel,bAffectLastZone,bForceJump);
				break;
			}
		}

	}
}

defaultproperties
{
    bAffectLastZone=True
    bHidden=True
    CollisionRadius=40.000000
    CollisionHeight=40.000000
    bCollideActors=True
}