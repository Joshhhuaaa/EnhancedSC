//=============================================================================
// P_1_7_1_1_InterroMeat
//=============================================================================
class P_1_7_1_1_InterroMeat extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax

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
        if(P.name == 'EFalseRussianSoldier2')
            Characters[1] = P.controller;
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
MilestoneInterroMeat:
    Log("MilestoneInterroMeat");
    Talk(Sound'S3_1_1Voice.Play_31_12_01', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_02', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_03', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_04', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_05', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_06', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_07', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_08', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_11', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_12', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_13', 0, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_14', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_12_15', 0, , TRUE, 0);
    EndConversation();
    End();

}

defaultproperties
{
}
