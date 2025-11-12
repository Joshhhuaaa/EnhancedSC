//=============================================================================
// P_5_2_EmissionThree
//=============================================================================
class P_5_2_EmissionThree extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EGeorgianPalaceGuard6')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianPalaceGuard2')
            Characters[2] = P.controller;
        if (P.name == 'EGeorgianPalaceGuard4')
            Characters[3] = P.controller;
        if (P.name == 'EGeorgianPalaceGuard1')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneEmi:
    Log("MilestoneEmi");
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ResetGoals(4);
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'KitchenSweep2end',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Guard,8,,'OtherWaitDoorA','PLAYER','KitchenSweep2end',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveTo,9,,,,'pathgydrfe',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,'OtherWaitDoorA','PLAYER','pathgydrfe',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'Pathgygygyg',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Guard,8,,'ESwingingDoorToLongeA','PLAYER','Pathgygygyg',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(4,GOAL_MoveTo,9,,,,'WaitForHimA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Guard,8,,'ESwingingDoorToLongeA','PLAYER','WaitForHimA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Speech(Localize("P_5_2_EmissionThree", "Speech_0002L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_65_03', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
BarkTenseIt:
    Log("BarkTenseIt");
    Sleep(1);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Sleep(1);
    ePawn(Characters[3].Pawn).Bark_Type = BARK_LookingForYou;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    End();

}

