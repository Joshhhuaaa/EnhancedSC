//=============================================================================
// P_3_4_3_SevE3_Help
//=============================================================================
class P_3_4_3_SevE3_Help extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DrumsPlayed;
var int EndSafe;
var int MafiaDead;
var int SafeCable;
var int SearchPlayed;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('ShootMafia');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ShootMafia');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'EMafiaMuscle3')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    DrumsPlayed=0;
    EndSafe=0;
    MafiaDead=0;
    SafeCable=1;
    SearchPlayed=0;
    }

    SetPatternAlwaysTick();
}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This was the pattern for the E3 pop-up help. This entire pattern can be deleted.");
eeStartingGoalsee:
    Log("This label gives instructions for the free cam and also sets up the goals");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0012L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_DOWN_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK | KEY_LOOK_UP_MASK | KEY_LOOK_DOWN_MASK | KEY_LOOK_LEFT_MASK | KEY_LOOK_RIGHT_MASK, FALSE);
    FreezeTraining();
    SendPatternEvent('LambertAI','InitGoals');
    End();
eeShootMafiaee:
    Log("This blurb suggests that the player shoot the mafioso");
    CheckIfIsDead(1,'SearchTip');
    CheckIfIsUnconscious(1,'SearchTip');
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0001L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_SCOPE_MASK | KEY_FIRE_MASK, FALSE);
    FreezeTraining();
    End();
eeOtherRouteee:
    Log("The player gets told to go inthe vent");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0002L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    End();
eeSneakMasseee:
    Log("Told to sneak up on Masse");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0003L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    End();
eeBackDooree:
    Log("Does Sam have a memory stick?");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0006L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    End();
eeNightVisionee:
    Log("Player is told to use his NV");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0007L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_QUICK_MASK, FALSE);
    FreezeTraining();
    End();
eeOCDisableee:
    Log("Disabling Optic Cable Note");
    SetFlags(SafeCable,FALSE);
    End();
eeOCEnableee:
    Log("Enabling Optic Cable Note");
    SetFlags(SafeCable,TRUE);
    End();
eeOpticCableee:
    Log("Player is told to use the Optic Cable");
    CheckFlags(SafeCable,TRUE,'SafeToPlay');
eeSafeToPlayee:
    Log("it is safe to play the Optic Cable Note");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0010L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_FIRE_MASK, FALSE);
    FreezeTraining();
    End();
eeOilDrumsee:
    Log("Player is told to shoot the oil drums");
    CheckFlags(DrumsPlayed,TRUE,'DoNothing');
    SetFlags(DrumsPlayed,TRUE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0008L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_FIRE_MASK, FALSE);
    FreezeTraining();
    End();
eePipeClimbee:
    Log("Player is told to climb the pipe");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0009L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_MOVE_UP_MASK, FALSE);
    FreezeTraining();
    End();
eeDoNothingee:
    Log("Doing nothing");
    End();
eeFinishedee:
    Log("End the Microsoft demo");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0011L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, FALSE);
    FreezeTraining();
    Sleep(1);
    GameOver(true, 0);
    End();
eeSearchTipee:
    Log("Mafia is dead so player can search for a medkit");
    CheckFlags(SearchPlayed,TRUE,'DoNothing');
    Sleep(3);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0016L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    SetFlags(SearchPlayed,TRUE);
    End();
eeTimerWarningee:
    Log("The player is warned about the timer.");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0017L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    End();
eeStickyCamee:
    Log("The player is told to use the sticky cam to get a better view of the courtyard");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0018L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0019L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0037L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_QUICK_MASK, FALSE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0044L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_ALT_FIRE_MASK, FALSE);
    FreezeTraining();
    FreezeTraining();
    FreezeTraining();
    FreezeTraining();
    End();
eeBackToWallee:
    Log("sending E3 tip suggesting back to wall if player has not already interfered with the hallway mafiosos");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0020L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK | KEY_SCOPE_MASK, FALSE);
    FreezeTraining();
    End();
eeStashee:
    Log("Suggesting that the player should hide the body.");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0022L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    End();
eeFlashLightee:
    Log("Warning player about guard with flashlight");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0027L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    End();
eeRappellingee:
    Log("Telling player to use rappelling");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0028L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0029L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    FreezeTraining();
    FreezeTraining();
    End();
eeHeatVisionee:
    Log("Telling player to use his heat vision");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0030L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0031L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0032L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    FreezeTraining();
    FreezeTraining();
    FreezeTraining();
    End();
eeOkayToEndee:
    Log("Setting flag to make it okay to end E3 Map");
    SetFlags(EndSafe,TRUE);
    End();
eeSafeToEndee:
    Log("Is it safe to end the E3 Map");
    CheckFlags(EndSafe,FALSE,'BackToLambert');
    Jump('EndE3Map');
    End();
eeBackToLambertee:
    Log("Not safe to end, going back to Lambert");
    SendPatternEvent('LambertAI','SkippedSAM');
    End();
eeEndE3Mapee:
    Log("This is the end of the E3 Map");
    Sleep(1);
    CinCamera(0, 'SAM01Cam', 'SAM1Boom',);
    Sleep(0.25);
    SendUnrealEvent('SAM1Boom');
    Sleep(1);
    SendUnrealEvent('SAM1Boom');
    Sleep(3);
    CinCamera(0, 'SAM02Cam', 'SAM2Boom',);
    Sleep(0.25);
    SendUnrealEvent('SAM2Boom');
    Sleep(1);
    SendUnrealEvent('SAM2Boom');
    Sleep(3);
    CinCamera(1, , ,);
    Sleep(1);
    GameOver(true, 0);
    End();
eeZipLineee:
    Log("Player is told how to use a zipline");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0039L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
    FreezeTraining();
    End();
eeAddMemee:
    Log("Adding Memory stick");
    AddNote("", "P_3_4_3_SevE3_Help", "Note_0046L", "Localization\\P_3_4_3Severonickel");
    AddTrainingData(Localize("P_3_4_3_SevE3_Help", "Training_0047L", "Localization\\P_3_4_3Severonickel"), KEY_NONE_MASK, TRUE);
    FreezeTraining();

}

