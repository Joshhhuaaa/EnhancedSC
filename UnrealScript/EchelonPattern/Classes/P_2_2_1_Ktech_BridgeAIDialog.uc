//=============================================================================
// P_2_2_1_Ktech_BridgeAIDialog
//=============================================================================
class P_2_2_1_Ktech_BridgeAIDialog extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_1Voice.uax

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
        if(P.name == 'EMafiaMuscle4')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle3')
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
AIConversation1:
    Log("Conversation between 2 mafiosos near the bridge");
    Goal_Default(1,GOAL_Guard,8,,'BridgeAIDialogFocus01',,'BridgeAIDialogNode01',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'BridgeAIDialogFocus01',,'BridgeAIDialogNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(2);
    Talk(Sound'S2_2_1Voice.Play_22_12_01', 1, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_12_02', 2, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_12_03', 1, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_12_04', 2, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_12_05', 1, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_12_06', 2, , TRUE, 0);
    Talk(Sound'S2_2_1Voice.Play_22_12_07', 1, , TRUE, 0);
    Close();
    End();
SetNPCs:
    Log("Set exclusivity false.");
    SetExclusivity(FALSE);
    End();

}

