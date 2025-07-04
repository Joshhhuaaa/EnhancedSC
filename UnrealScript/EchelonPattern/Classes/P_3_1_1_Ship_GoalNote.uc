//=============================================================================
// P_3_1_1_Ship_GoalNote
//=============================================================================
class P_3_1_1_Ship_GoalNote extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int BobPass1;
var int BobPass2;
var int BobPass3;
var int BobPass4;
var int pass1;
var int pass2;


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
        if(P.name == 'ELambert2')
            Characters[1] = P.controller;
        if(P.name == 'EBobrov0')
            Characters[2] = P.controller;
        if(P.name == 'EAzeriColonel0')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    BobPass1=0;
    BobPass2=0;
    BobPass3=0;
    BobPass4=0;
    pass1=0;
    pass2=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BobTalkJump:
    Log("Jump to Bobrov talk.  Because no label in ai conversation");
    Jump('TalkBobrov');
    End();
FindBobRov:
    Log("Goal For Bobrov");
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('findbob', "", 1, "", "P_3_1_1_Ship_GoalNote", "Goal_0002L", "Localization\\P_3_1_1_ShipYard", "P_3_1_1_Ship_GoalNote", "Goal_0066L", "Localization\\P_3_1_1_ShipYard");
    Sleep(9);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0010L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0011L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(7);
    Close();
    End();
TalkBobrov:
    Log("Finding Bobrov and talking to him");
    CheckFlags(BobPass1,TRUE,'BobTalk2');
    SetFlags(BobPass1,TRUE);
    CinCamera(0, 'EFocusPoint21', 'EFocusPoint30',);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0012L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0003L", "Localization\\P_3_1_1_ShipYard"), None, 2, 2, TR_CONVERSATION, 0, false);
    GoalCompleted('findbob');
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0013L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0014L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(8);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0015L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0016L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0017L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0018L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0019L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0020L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0021L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(5);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0022L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0023L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0024L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0025L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0026L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0027L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    CinCamera(1, , ,);
    AddNote("", "P_3_1_1_Ship_GoalNote", "Note_0005L", "Localization\\P_3_1_1_ShipYard");
    SetFlags(V3_1_1_ShipYard(Level.VarObject).BobrovHadTalk,TRUE);
    Jump('OrderSubRadio');
    End();
BobTalk2:
    Log("");
    CheckFlags(BobPass2,TRUE,'BobTalk3');
    SetFlags(BobPass2,TRUE);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0043L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0044L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0045L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0046L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
BobTalk3:
    Log("");
    CheckFlags(BobPass3,TRUE,'BobTalk4');
    SetFlags(BobPass3,TRUE);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0047L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(5);
    Close();
    End();
BobTalk4:
    Log("");
    CheckFlags(BobPass4,TRUE,'BobTalk5');
    SetFlags(BobPass4,TRUE);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0048L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Close();
    End();
BobTalk5:
    Log("");
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0049L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Close();
    End();
nothing:
    End();
    End();
GameOverMan:
    Log("");
    SetProfileDeletion();
    GameOver(false, 0);
    End();
GetinCR:
    Log("sam enter the control room");
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0052L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(6);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0053L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0054L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(1);
    Close();
    End();
RaisingSub:
    Log("activating the air compressor system making the sub surface");
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0050L", "Localization\\P_3_1_1_ShipYard"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(5);
    Close();
CineSub:
    Log("trigger the ingame movie of the sub raising");
    SendUnrealEvent('MoverSub');
    CinCamera(0, 'EFocusPoint36', 'EFocusPoint37',);
    Sleep(9);
    CinCamera(1, , ,);
    GoalCompleted('RaiseSub');
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0065L", "Localization\\P_3_1_1_ShipYard"), None, 1, 2, TR_CONSOLE, 0, false);
    Sleep(2);
LamberBlaBla:
    Log("");
SubAlarm:
    Log("");
    StartAlarm('EAlarm2',1);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0063L", "Localization\\P_3_1_1_ShipYard"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(6);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0064L", "Localization\\P_3_1_1_ShipYard"), None, 3, 0, TR_NPCS, 0, false);
    Sleep(2);
CallAttack:
    Log("");
    SendPatternEvent('EGroupAI12','Start');
    Sleep(2);
    Close();
    End();
CommRoom:
    Log("destroy comm room");
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0055L", "Localization\\P_3_1_1_ShipYard"), None, 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('CommRoom', "", 3, "", "P_3_1_1_Ship_GoalNote", "Goal_0056L", "Localization\\P_3_1_1_ShipYard", "P_3_1_1_Ship_GoalNote", "Goal_0067L", "Localization\\P_3_1_1_ShipYard");
    Sleep(9);
    End();
OrderSubRadio:
    Log("labert give order to get inside sub");
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0057L", "Localization\\P_3_1_1_ShipYard"), None, 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('UseSissix', "", 9, "", "P_3_1_1_Ship_GoalNote", "Goal_0058L", "Localization\\P_3_1_1_ShipYard", "P_3_1_1_Ship_GoalNote", "Goal_0068L", "Localization\\P_3_1_1_ShipYard");
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0059L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0060L", "Localization\\P_3_1_1_ShipYard"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    End();
OrderRaiseSub:
    Log("lambert order to raise the sub");
    Speech(Localize("P_3_1_1_Ship_GoalNote", "Speech_0062L", "Localization\\P_3_1_1_ShipYard"), None, 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('RaiseSub', "", 5, "", "P_3_1_1_Ship_GoalNote", "Goal_0061L", "Localization\\P_3_1_1_ShipYard", "P_3_1_1_Ship_GoalNote", "Goal_0069L", "Localization\\P_3_1_1_ShipYard");
    Sleep(9);
    Close();
    End();

}

defaultproperties
{
}
