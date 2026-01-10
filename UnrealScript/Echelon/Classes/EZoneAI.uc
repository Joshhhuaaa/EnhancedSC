class EZoneAI extends Actor
	placeable;

var	   float			 TriggerTime;


var() array<Name>				EnableGroupTags;
var() array<Name>				DisableGroupTags;

/*-----------------------------------------------------------*\
|															 |
| ProcessZoning                                              |
|                                                            |
\*-----------------------------------------------------------*/
function ProcessZoning()
{
	local int i;
	local EAIPawn NPC;
	local bool bBodyFound, bAlarmIsRunning;

	//log("ProcessZoning ZoneAI "$self);

	bBodyFound = false;


	//do a first pass to see if alarms are running
	foreach DynamicActors(class'EAIPawn', NPC)
	{
		for (i = 0; i < DisableGroupTags.Length; i++)
		{
			if (NPC.m_GroupTag == DisableGroupTags[i])
			{
				if (NPC.group != None)
				{
					//avoid to trigger an alarm if:
					//1- The Body is in a group that is attacking
					//2- The Body is in a group that is on an alarm

					if ((NPC.group.CurrentAlarm != None) || NPC.group.IsAMemberInAttack())
					{
						bAlarmIsRunning = true;
						break;
					}
				}

			}
		}

	}

	//try to find the NPCs
	foreach DynamicActors(class'EAIPawn', NPC)
	{
		for (i = 0; i < EnableGroupTags.Length; i++)
		{
			if (NPC.m_GroupTag == EnableGroupTags[i])
			{
				//log("NPC "$NPC$" was reenabled...");
				//cancel music request for that NPC
				NPC.bDisableAI = false;
				NPC.bDisableAIforSound = false;

				if (NPC.controller != None && EAIController(NPC.controller).pattern != None)
				{
					//check the current state of the default pattern
					if (EAIController(NPC.controller).pattern.GetStateName() == 'search')
					{
						EchelonLevelInfo(Level).SendMusicRequest(0,true,EAIController(NPC.controller).pattern, true);
						EchelonLevelInfo(Level).SendMusicRequest(1,false,EAIController(NPC.controller).pattern);
					}

					if (EAIController(NPC.controller).pattern.GetStateName() == 'attack')
					{
						EchelonLevelInfo(Level).SendMusicRequest(0,false,EAIController(NPC.controller).pattern);
						EchelonLevelInfo(Level).SendMusicRequest(1,true,EAIController(NPC.controller).pattern, true);
					}
				}

				//NPC.GetBoneCoords(NPC.EyeBoneName, true);
			}
		}

		for (i = 0; i < DisableGroupTags.Length; i++)
		{
			if (NPC.m_GroupTag == DisableGroupTags[i])
			{
				//check if the NPC is inert
				if ((NPC.GetStateName() == 's_Unconscious') || (NPC.GetStateName() == 's_Dying'))
				{
					if (NPC.LastRenderTime < Level.TimeSeconds - 2.0f)
					{
					//check visibility factor for each NPC
					if ((NPC.GetVisibilityFactor(true) > 30) && (!NPC.bIsDog) && (!NPC.bSniper))
					{
						if (!NPC.bBodyDetected && !bAlarmIsRunning && !NPC.AI.bWasFound && !NPC.AI.bNotInStats)
						{
							//flag the NPC as found
							NPC.bBodyDetected = true;
							EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("BodyFound");
							bBodyFound = true;
						}
					}
				}
				}

				if (NPC.controller != None && EAIController(NPC.controller).pattern != None)
				{
					//cancel music request for that NPC
					EchelonLevelInfo(Level).SendMusicRequest(0,false,EAIController(NPC.controller).pattern);
					EchelonLevelInfo(Level).SendMusicRequest(1,false,EAIController(NPC.controller).pattern);
				}

				//log("NPC "$NPC$" was disabled...");
				NPC.bDisableAI = true;
				NPC.bDisableAIforSound = true;
				NPC.StopAllVoicesActor(true);
			}
		}

	}




	if (bBodyFound)
	{
		log("** An Inert NPC was found **");

        if (!((EchelonLevelInfo(Level)).bIgnoreAlarmStage))
        {
    	    //send NPC transmission
			if (!EchelonLevelInfo(Level).bOneAlarmLevel) // Joshua - Don't send on OneAlarmLevel
		    	EchelonGameInfo(Level.Game).pPlayer.SendTransmissionMessage(Localize("Transmission", "BodyFound", "Localization\\HUD"), TR_NPCS);

			AddOneVoice();
			EchelonGameInfo(Level.Game).pPlayer.EPawn.PlaySound((EchelonLevelInfo(Level)).FindCorpseSound, SLOT_Voice);

		    //play alarm sound
		    PlaySound(Sound'Electronic.Play_Seq_AlarmFindBody', SLOT_Interface);
		    PlaySound(Sound'Electronic.Stop_Seq_AlarmFindBody', SLOT_Interface);

		    //increase alarm stage
		    EchelonLevelInfo(Level).IncreaseAlarmStage();
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
	local Pawn P;

	//cast the actor in Pawn
	P = Pawn(Other);

	//check if the player is colliding
	if (P != None && P.bIsPlayerPawn)
	{
	if (Level.TimeSeconds - TriggerTime < 0.2)
		return;

	TriggerTime = Level.TimeSeconds;

			// make sure not touching through wall
			//if (FastTrace(Other.Location, Location))
			//{
//			log("ProcessZoning pour "@Other);
				ProcessZoning();
			//}
	}
}

/*-----------------------------------------------------------*\
|															 |
| Trigger                                                    |
|                                                            |
\*-----------------------------------------------------------*/
event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
{
	ProcessZoning();
}

defaultproperties
{
    bHidden=True
    bCollideActors=True
}