//=============================================================================
// P_4_2_2_Abt_Studio
//=============================================================================
class P_4_2_2_Abt_Studio extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int GdeadPass1;
var int OnBoard;


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
        if(P.name == 'ENikoladze0')
            Characters[1] = P.controller;
        if(P.name == 'EGrinko1')
            Characters[2] = P.controller;
        if(P.name == 'EEliteForce0')
            Characters[3] = P.controller;
        if(P.name == 'EEliteForce1')
            Characters[4] = P.controller;
        if(P.name == 'EGeorgianSoldier35')
            Characters[5] = P.controller;
        if(P.name == 'EAzeriColonel4')
            Characters[6] = P.controller;
        if(P.name == 'EMercenaryTechnician0')
            Characters[7] = P.controller;
        if(P.name == 'EGeorgianSoldier38')
            Characters[8] = P.controller;
        if(P.name == 'EGeorgianSoldier37')
            Characters[9] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    GdeadPass1=0;
    OnBoard=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
NikoladzeOut:
    Log("Get Nikoladze out of here");
JumpFin:
    Log("");
    End();
GrinkoSpeach1:
    Log("");
    Sleep(0.5);
    AddGoal('ProtectHostages', "", 2, "", "P_4_2_2_Abt_Studio", "Goal_0008L", "Localization\\P_4_2_2_Abattoir", "P_4_2_2_Abt_Studio", "Goal_0018L", "Localization\\P_4_2_2_Abattoir");
    Speech(Localize("P_4_2_2_Abt_Studio", "Speech_0009L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_55_01', 2, 0, TR_NPCS, 0, false);
    Close();
    End();
GrinkoSpeach2:
    Log("");
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).GDstopLambertGoal,TRUE,'GrinkoGO');
    Speech(Localize("P_4_2_2_Abt_Studio", "Speech_0010L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_60_01', 2, 0, TR_NPCS, 0, false);
    Close();
    Sleep(1);
    Speech(Localize("P_4_2_2_Abt_Studio", "Speech_0011L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_60_02', 2, 0, TR_NPCS, 0, false);
    Close();
GrinkoGO:
    SendPatternEvent('EGroupAI21','Main');
    End();
GrinkoDead:
    Log("");
    DisableMessages(TRUE, TRUE);
    Sleep(0.5);
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).GrinkoCombatEnded,TRUE,'GDa');
    Jump('GDb');
GDa:
    Log("GDa");
    //PlayerMove(false); // Joshua - Removing the player movement lock after completing the objective
GDb:
    Log("GDb");
    CheckFlags(GdeadPass1,TRUE,'GDc');
    SetFlags(V4_2_2_Abattoir(Level.VarObject).GDstopLambertGoal,TRUE);
    GoalCompleted('KillGrinko');
    Speech(Localize("P_4_2_2_Abt_Studio", "Speech_0013L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_70_01', 1, 2, TR_NPCS, 0, false);
    Speech(Localize("P_4_2_2_Abt_Studio", "Speech_0014L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_70_02', 1, 0, TR_NPCS, 0, false);
    Speech(Localize("P_4_2_2_Abt_Studio", "Speech_0015L", "Localization\\P_4_2_2_Abattoir"), Sound'S4_2_2Voice.Play_42_70_03', 1, 0, TR_NPCS, 0, false);
    Close();
    SetFlags(GdeadPass1,TRUE);
GDc:
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).GrinkoCombatEnded,FALSE,'GDend');
    SendPatternEvent('EGroupAI28','LambertLastCall');
    End();
GDend:
    Log("GDend");
    DisableMessages(FALSE, FALSE);
    SendPatternEvent('EGroupAI2','Start');
    End();

}

