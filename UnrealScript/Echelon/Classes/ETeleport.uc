class ETeleport extends Actor
	placeable;

var	   bool				bAlreadyVisited;
var    actor			Target;
var()  bool				bTriggerOnlyOnce;
var() class<EInventoryItem>	TeleportInventory[16];
var()  Name				GroupTag;
var()  Name				JumpLabel;
var()  Name				TargetTag;
var() array<Name>		EnableGroupTags;
var() array<Name>		DisableGroupTags;
var()  int              LimitBullets;
var()  int              LimitClips;


/*-----------------------------------------------------------*\
|															 |
| PostBeginPlay                                                      |
|                                                            |
\*-----------------------------------------------------------*/
function PostBeginPlay()
{ 
	bAlreadyVisited = false;
	if (TargetTag != '')
	{
		Target = GetMatchingActor(TargetTag);
	}
}


function GiveTeleportInventory(actor Other)
{
	local EInventoryItem spawnedItem;
	local EPawn PlayerPawn;
	local int i;
	local EWeapon			WeaponItem;
	
	// fill up the player's inventory
	PlayerPawn = EPawn(Other);
	if (PlayerPawn != None)
	{
		log("Giving inventory to " @ PlayerPawn);

		for (i = 0; i < ArrayCount(TeleportInventory); i++)
		{
			if (TeleportInventory[i] != none)
			{
				// special case for weapons, just reset the ammo if we hold one already.
				WeaponItem = EWeapon(PlayerPawn.FullInventory.GetItemByClass(TeleportInventory[i].name));
				if (WeaponItem == None)
				{
					// not a weapon, or not holding one yet
					spawnedItem = Spawn(TeleportInventory[i], PlayerPawn.Controller);
				}
				else
				{
					// if the item is a weapon, and already in the inventory, just reset its ammo.                    
                    if (LimitBullets != -1)
                    {
					    WeaponItem.Ammo = LimitBullets;
                    }
                    else
                    {
                        WeaponItem.Ammo = WeaponItem.MaxAmmo;
                    }

                    if (LimitClips != -1)
                    {
                        WeaponItem.ClipAmmo = LimitClips;
                    }
                    else
                    {
                        WeaponItem.ClipAmmo = WeaponItem.ClipMaxAmmo;
                    }
					
					// skip to the next inventory item
					continue;
				}
				
				if (spawnedItem != none)
				{
					// validate if the inventory can hold more of the item we spawned.
					// If it can, then add it. Otherwise, destroy it right away.
					if (PlayerPawn.FullInventory.CanAddItem(spawnedItem))
					{
                        WeaponItem = EWeapon(spawnedItem);

                        if (WeaponItem != None)
                        {
                            if (LimitBullets != -1)
                            {
					            WeaponItem.Ammo = LimitBullets;
                            }
                            else
                            {
                                WeaponItem.Ammo = WeaponItem.MaxAmmo;
                            }

                            if (LimitClips != -1)
                            {
                                WeaponItem.ClipAmmo = LimitClips;
                            }
                            else
                            {
                                WeaponItem.ClipAmmo = WeaponItem.ClipMaxAmmo;
                            }
                        }

						spawnedItem.Add(PlayerPawn.Controller, PlayerPawn.Controller, PlayerPawn.FullInventory);
					}
					else
					{
						spawnedItem.Destroy();
					}
				}
				else
				{
					log("=== ERROR, could not allocate inventory item, spawn failed for " @ PlayerPawn.DynInitialInventory[i]);
				}
			}
		}
	}
}

/*-----------------------------------------------------------*\
|															 |
| ProcessZoning                                              |
|                                                            |
\*-----------------------------------------------------------*/
function ProcessZoning()
{
	local int i;
	local EAIPawn NPC;

	//try to find the NPCs
	foreach DynamicActors(class'EAIPawn', NPC)
	{
		for (i = 0; i < EnableGroupTags.Length; i++)
		{
			if (NPC.m_GroupTag == EnableGroupTags[i])
			{
				//log("NPC "$NPC$" was reenabled...");
				NPC.bDisableAI = false;
				NPC.bDisableAIforSound = false;
			}
		}

		for (i = 0; i < DisableGroupTags.Length; i++)
		{
			if (NPC.m_GroupTag == DisableGroupTags[i])
			{				
				//log("NPC "$NPC$" was disabled...");
				NPC.bDisableAI = true;
				NPC.bDisableAIforSound = true;
			}
		}
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
	local Pawn P;
	local EGroupAI Group;
    local EGameplayObject	EGOResetter;
    local EPawn EP;
    local Mover             MoverResetter;

	if (bAlreadyVisited && bTriggerOnlyOnce)
		return;

	//log(Other @ " ETeleportTriggering to " @ Target);
	//cast the actor in Pawn
	P = Pawn(Other);
	if (P != None)
	{
		//check if the player is colliding
		if (P.controller.bIsPlayer)
		{
			bAlreadyVisited = true;

			//send an EventTrigger when the glass breaks
			if (GroupTag != '')
			{
				foreach DynamicActors(class'EGroupAI', Group, GroupTag)
				{
					Group.SendJumpEvent(JumpLabel,false,false);
					break;
				}	
			}

			//reset all changed actors
			Level.ChangedActorsList = None;

			// Reset all gameplay objects; for use in DemoX for E3, among others
			foreach DynamicActors(class 'EGameplayObject', EGOResetter)
			{
				EGOResetter.Reset();
			}

            foreach DynamicActors(class 'Mover', MoverResetter)
			{
				MoverResetter.Reset();
			}

			ProcessZoning();


			// If we want a fade what we will need to do here is set Sam in a "teleport" state, where we handle
			// the fade out, teleport, inventory handling then the fade in. Can't do the latent stuff in a
			// function call.
			//... change the state in Sam

			// for now, just do it in the same frame
			// teleporting the player
			if (Target != none)
			{
				P.SetLocation(Target.Location);
				P.SetRotation(Target.Rotation);
			}

			GiveTeleportInventory(Other);

            // Put out fire if player is fiery
            EP = EPawn(P);

            if (EP != None)
            {
                EP.AttenuateFire(1.0);
            }

            // Reset HP
            P.Health = 400;

			//reset all changed actors
			//Level->ChangedActorsList = None;

		}
	}
}

defaultproperties
{
    bTriggerOnlyOnce=True
    LimitBullets=-1
    LimitClips=-1
    bHidden=True
    CollisionRadius=40.000000
    CollisionHeight=40.000000
    bCollideActors=True
}