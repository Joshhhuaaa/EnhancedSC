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
var()  bool				 bForceJump;   //override disable messages of the pattern
var()  bool				 ConversationTrigger;

/*-----------------------------------------------------------*\
|															 |
| IsRelevant                                                 |
|                                                            |
\*-----------------------------------------------------------*/
function bool IsRelevant( actor Other )
{
	switch( ProximityType )
	{
		case PlayerProximity:
			return Other.bIsPawn && Pawn(Other).IsPlayerPawn();
		case NPCProximity:
			return Other.bIsPawn && ( EAIController(Pawn(Other).controller) != None) ;
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

	//if ( ConversationTrigger && EchelonLevelInfo(Level).MusicObj.GetStateName() != 'Idle' )
	//	return;

	if(!( (bAlreadyVisited) && (bTriggerOnlyOnce) ))
	{
		if(IsRelevant(Other))
		{
			//if ( Level.TimeSeconds - TriggerTime < 0.2 )
			//	return;
			//TriggerTime = Level.TimeSeconds;

			//set visited flag
			bAlreadyVisited=true;

			foreach DynamicActors( class'EGroupAI', Group, GroupTag)
			{
				Group.SendJumpEvent(JumpLabel,bAffectLastZone,bForceJump);
				break; 
			}			
		}
		
	}
}

defaultproperties
{
    bAffectLastZone=true
    bHidden=true
    CollisionRadius=40.000000
    CollisionHeight=40.000000
    bCollideActors=true
}