//=============================================================================
// P_1_6_1_1_ServerAccessed
//=============================================================================
class P_1_6_1_1_ServerAccessed extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int HallLightA;
var int HallLightB;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    if (!bInit)
    {
    bInit=TRUE;
    HallLightA=1;
    HallLightB=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneServerAccessed:
    Log("MilestoneServerAccessed");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorInOpen,TRUE,'ServerCarry');
    SendUnrealEvent('BigDoorsTest');
    SendUnrealEvent('InDoorLight');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorInOpen,TRUE);
ServerCarry:
    Log("ServerCarry");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).FirstLazer,FALSE,'ServerCarryB');
    SendUnrealEvent('FirstLazerz');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).FirstLazer,FALSE);
ServerCarryB:
    Log("ServerCarryB");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).PreServerLazer,FALSE,'ServerCarryC');
    SendUnrealEvent('Vanish');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).PreServerLazer,FALSE);
ServerCarryC:
    Log("ServerCarryC");
    SendUnrealEvent('SaveVolOne');
    SendUnrealEvent('LambertCallVol');
    AddRecon(class 'EReconPicAlekseevich');
    AddRecon(class 'EReconFullTextAlek');
    GoalCompleted('Server');
    AddGoal('Retinal', "", 4, "", "P_1_6_1_1_ServerAccessed", "Goal_0001L", "Localization\\P_1_6_1_1KolaCell", "P_1_6_1_1_ServerAccessed", "Goal_0002L", "Localization\\P_1_6_1_1KolaCell");
    AddNote("", "P_1_6_1_1_ServerAccessed", "Note_0003L", "Localization\\P_1_6_1_1KolaCell");
    SendPatternEvent('GroupRadioFirst','Tel');
    SendPatternEvent('Flashers','LightsOff');
    SendPatternEvent('GroupLoneForSplit','Tel');
    SendPatternEvent('GroupBasementAmbush','Tel');
    SendPatternEvent('GroupExtincteur','Tel');
    SendPatternEvent('Lockerz','TelOut');
    SendPatternEvent('GroupAlek','HeadOnASpike');
    SendUnrealEvent('Vanish');
    Sleep(0.5);
    CheckFlags(HallLightA,FALSE,'MakeLightAOn');
    CheckFlags(HallLightB,FALSE,'MakeLightBOn');
    End();
HallLightA:
    Log("HallLightA");
    CheckFlags(HallLightA,TRUE,'HallLightAOff');
HallLightAOn:
    Log("HallLightAOn");
    SetFlags(HallLightA,TRUE);
    End();
HallLightAOff:
    Log("HallLightAOff");
    SetFlags(HallLightA,FALSE);
    End();
HallLightB:
    Log("HallLightB");
    CheckFlags(HallLightB,TRUE,'HallLightBOff');
HallLightBOn:
    Log("HallLightBOn");
    SetFlags(HallLightB,TRUE);
HallLightBOff:
    Log("HallLightBOff");
    SetFlags(HallLightB,FALSE);
    End();
MakeLightAOn:
    Log("MakeLightAOn");
    SendUnrealEvent('halllightswitchA');
    CheckFlags(HallLightB,FALSE,'MakeLightBOn');
    End();
MakeLightBOn:
    Log("MakeLightBOn");
    SendUnrealEvent('halllightswitchB');
    End();

}

defaultproperties
{
}
