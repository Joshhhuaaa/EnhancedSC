class ECameraTrigger extends PhysicsVolume
	placeable;


var	   bool				 bAlreadyVisited;
var()  bool			     bTriggerOnlyOnce;
var()  bool				 bStartFix;
var()  Name				 CamLocation;
var()  Name				 CamTarget;
var	   float			 TriggerTime;


/*-----------------------------------------------------------*\
|															 |
| Touch                                                      |
|                                                            |
\*-----------------------------------------------------------*/
function Touch(actor Other)
{
	local EPlayerController P;
    local Actor  aPos, aTarget;

	if (!((bAlreadyVisited) && (bTriggerOnlyOnce)))
	{
		if (Other.bIsPawn && Pawn(Other).IsPlayerPawn())
		{
			//if (Level.TimeSeconds - TriggerTime < 0.2)
			//	return;
			//TriggerTime = Level.TimeSeconds;

			//set visited flag
			bAlreadyVisited = true;

			P = EPlayerController(Pawn(Other).controller);

			if (bStartFix)
			{
				EMainHUD(P.myHUD).GoToState('');
    			P.m_camera.GoToState('s_Fixed');

				// Move the camera //
				if (CamLocation != '')
				{
					aPos = GetMatchingActor(CamLocation);
					if (aPos != None)
						P.SetLocation(aPos.Location);
				}

				// Rotate the camera //
				if (CamTarget != '')
				{
					aTarget = GetMatchingActor(CamTarget);
					if (aTarget != None)
					{
						if (aPos != None)
						{
							P.SetRotation(Rotator(aTarget.Location - aPos.Location));
						}
						else
							P.SetRotation(Rotator(aTarget.Location - P.Location));
					}
				}
			}
			else
			{
		        EMainHUD(P.myHUD).NormalView();
				P.m_camera.GoToState('s_Following');
			}
		}
	}
}

defaultproperties
{
    bStartFix=True
    CollisionRadius=40.000000
    CollisionHeight=40.000000
}