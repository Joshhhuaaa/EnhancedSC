//=============================================================================
// P_3_1_1_Ship_BoringTV
//=============================================================================
class P_3_1_1_Ship_BoringTV extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'spetsnaz41')
            Characters[1] = P.controller;
        if(P.name == 'EAzeriColonel1')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BoringTV:
    Log("Guard complaining about tv");
Talk:
    Log("");
    Speech(Localize("P_3_1_1_Ship_BoringTV", "Speech_0005L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_BoringTV", "Speech_0006L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_BoringTV", "Speech_0007L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_BoringTV", "Speech_0008L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_BoringTV", "Speech_0009L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(12);
    Close();
Fin:
    Log("");
    End();
Hello:
    Log("tv guy look for the other");
    DisableMessages(TRUE, TRUE);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_BoringTV", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    ChangeState(1,'s_alert');
    Goal_Default(1,GOAL_Patrol,9,,,,'spetsnaz41_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    DisableMessages(FALSE, FALSE);
    End();
TVagain:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode40',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,9,,'EFocusPoint75',,'PathNode40',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ChangeState(1,'s_default');
    End();

}

defaultproperties
{
}
