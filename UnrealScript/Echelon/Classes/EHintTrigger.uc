class EHintTrigger extends Trigger;

function Touch( actor Other )
{
	if( IsRelevant(Other) )
	{
        // Send message //
        if((Pawn(Other) != None) && (Pawn(Other).Controller != None) && (EPlayerController(Pawn(Other).Controller) != None))
        {
            EPlayerController(Pawn(Other).Controller).SendTransmissionMessage(Localize("Hint", Message, "Localization\\Hint"), TR_HINT);
        }

		if( bTriggerOnceOnly )
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}
