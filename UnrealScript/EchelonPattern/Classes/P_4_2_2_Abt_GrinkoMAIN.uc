//=============================================================================
// P_4_2_2_Abt_GrinkoMAIN
//=============================================================================
class P_4_2_2_Abt_GrinkoMAIN extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int GrinkoAttackPass1;
var int GrinkoAttackPass2;


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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'EGrinko1')
            Characters[1] = P.controller;
        if(P.name == 'EAzeriColonel4')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'EGrinko0')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    GrinkoAttackPass1=0;
    GrinkoAttackPass2=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("MP Setup");
Main:
    Log("");
GrinkoSpeach1:
    Log("");
    SendPatternEvent('EGroupAI27','GrinkoSpeach1');
HostageCover:
    Log("");
FirstTeams:
    Log("FIRST TEAMS");
    SendPatternEvent('EGroupAI11','Main');
    SendPatternEvent('EGroupAI14','Main');
    Log("Start ending combat chek pattern.  GrinkoDeadChek");
    SendPatternEvent('EGroupAI2','Start');
    Log("Start spawning pattern.  SpawnOrder");
    SendPatternEvent('EGroupAI3','Start');
HostageCrouch:
    Log("");
    Sleep(2);
    SendPatternEvent('EGroupAI22','GetCover');
    End();
Fin:
    Log("");
    End();
SquadCount:
    Log("");
    CheckFlags(GrinkoAttackPass2,TRUE,'Fin');
SC1:
    Log("");
    CheckFlags(GrinkoAttackPass1,TRUE,'SC2');
    SetFlags(GrinkoAttackPass1,TRUE);
    End();
SC2:
    Log("");
    SetFlags(GrinkoAttackPass2,TRUE);
    //SendPatternEvent('EGroupAI27','GrinkoSpeach2'); // Joshua - Colonel Bagrat fix
    End();
OrderLeft:
    Log("A1 - C1");
OrderMiddleRight:
    Log("A2 - C2");
    End();

}

