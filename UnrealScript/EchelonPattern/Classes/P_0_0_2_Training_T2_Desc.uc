//=============================================================================
// P_0_0_2_Training_T2_Desc
//=============================================================================
class P_0_0_2_Training_T2_Desc extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int BackToWallPlayed;
var int CrouchPlayed;
var int FenceClimbingPlayed;
var int JumpAndLedgePlayed;
var int LadderPlayed;
var int PipeHangCrouchPlayed;
var int PipeHangPlayed;
var int PipePlayed;
var int speedplayed;
var int SplitJumpPlayed;
var int WallJumpPlayed;
var int ZipLinePlayed;


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
    BackToWallPlayed=0;
    CrouchPlayed=0;
    FenceClimbingPlayed=0;
    JumpAndLedgePlayed=0;
    LadderPlayed=0;
    PipeHangCrouchPlayed=0;
    PipeHangPlayed=0;
    PipePlayed=0;
    speedplayed=0;
    SplitJumpPlayed=0;
    WallJumpPlayed=0;
    ZipLinePlayed=0;
    }

    SetPatternAlwaysTick();
}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
PlayerLook:
    Log("");
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0033L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_LOOK_UP_MASK | KEY_LOOK_DOWN_MASK | KEY_LOOK_LEFT_MASK | KEY_LOOK_RIGHT_MASK, FALSE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0035L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_RESETCAMERA_MASK, FALSE);
    End();
PlayerMove:
    Log("");
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0036L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_MOVE_UP_MASK | KEY_MOVE_DOWN_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK, FALSE);
    End();
JumpAndLedge:
    Log("");
    CheckFlags(JumpAndLedgePlayed,TRUE,'DoNothing');
    SetFlags(JumpAndLedgePlayed,FALSE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0001L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_MOVE_LEFT_MASK | KEY_MOVE_RIGHT_MASK | KEY_JUMP_MASK, FALSE);
    End();
speed:
    // Joshua - Unused tip for keyboard variable speeds
    Log("");
    CheckFlags(speedplayed,TRUE,'DoNothing');
    SetFlags(speedplayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0041L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    End();
Ladder:
    Log("");
    CheckFlags(LadderPlayed,TRUE,'DoNothing');
    SetFlags(LadderPlayed,TRUE);
    if (EPlayerController(Characters[0]).bCrouchDrop)
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0005L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    else
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0006L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    End();
ZipLine:
    Log("");
    CheckFlags(ZipLinePlayed,TRUE,'DoNothing');
    SetFlags(ZipLinePlayed,TRUE);
    if (EPlayerController(Characters[0]).bCrouchDrop)
    {
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0009L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_1000L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
    }
    else
    {
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0010L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_1001L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
    }
    End();
Pipe:
    Log("");
    CheckFlags(PipePlayed,TRUE,'DoNothing');
    SetFlags(PipePlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0012L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    End();
SplitJump:
    Log("");
    CheckFlags(SplitJumpPlayed,TRUE,'DoNothing');
    SetFlags(SplitJumpPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0039L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0040L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    End();
PipeHang:
    Log("");
    CheckFlags(PipeHangPlayed,TRUE,'DoNothing');
    SetFlags(PipeHangPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0014L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
    End();
Crouch:
    Log("");
    CheckFlags(CrouchPlayed,TRUE,'DoNothing');
    SetFlags(CrouchPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0025L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_DUCK_MASK, FALSE);
    End();
PipeHangCrouch:
    Log("");
    CheckFlags(PipeHangCrouchPlayed,TRUE,'DoNothing');
    SetFlags(PipeHangCrouchPlayed,TRUE);
    if (EPlayerController(Characters[0]).bCrouchDrop)
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0017L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_DUCK_MASK, FALSE);
    else
        AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0018L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_DUCK_MASK, FALSE);
    End();
BackToWall:
    Log("");
    CheckFlags(BackToWallPlayed,TRUE,'DoNothing');
    SetFlags(BackToWallPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0032L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    End();
WallJump:
    Log("");
    CheckFlags(WallJumpPlayed,TRUE,'DoNothing');
    SetFlags(WallJumpPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0023L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0024L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_JUMP_MASK, FALSE);
    End();
FenceClimbing:
    Log("");
    CheckFlags(FenceClimbingPlayed,TRUE,'DoNothing');
    SetFlags(FenceClimbingPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_T2_Desc", "Training_0028L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK, TRUE);
    End();
SwitchJumpAndLedge:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoJumpAndLedge');
    SendPatternEvent('DescLatent','LatentDesc');
GoJumpAndLedge:
    SetFlags(JumpAndLedgePlayed,FALSE);
    Jump('JumpAndLedge');
    End();
SwitchLadder:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoLadder');
    SendPatternEvent('DescLatent','LatentDesc');
GoLadder:
    SetFlags(LadderPlayed,FALSE);
    Jump('Ladder');
    End();
SwitchZipLine:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoZipLine');
    SendPatternEvent('DescLatent','LatentDesc');
GoZipLine:
    SetFlags(ZipLinePlayed,FALSE);
    Jump('ZipLine');
    End();
SwitchPipe:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoPipe');
    SendPatternEvent('DescLatent','LatentDesc');
GoPipe:
    SetFlags(PipePlayed,FALSE);
    Jump('Pipe');
    End();
SwitchSplitJump:
    Log("testing split jump trigger.");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoSplitJump');
    SendPatternEvent('DescLatent','LatentDesc');
GoSplitJump:
    SetFlags(SplitJumpPlayed,FALSE);
    Jump('SplitJump');
    End();
SwitchPipeHang:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoPipeHang');
    SendPatternEvent('DescLatent','LatentDesc');
GoPipeHang:
    SetFlags(PipeHangPlayed,FALSE);
    Jump('PipeHang');
    End();
SwitchCrouch:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoCrouch');
    SendPatternEvent('DescLatent','LatentDesc');
GoCrouch:
    SetFlags(CrouchPlayed,FALSE);
    Jump('Crouch');
    End();
SwitchPipeHangCrouch:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoPipeHangCrouch');
    SendPatternEvent('DescLatent','LatentDesc');
GoPipeHangCrouch:
    SetFlags(PipeHangCrouchPlayed,FALSE);
    Jump('PipeHangCrouch');
    End();
SwitchBackToWall:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoBackToWall');
    SendPatternEvent('DescLatent','LatentDesc');
GoBackToWall:
    SetFlags(BackToWallPlayed,FALSE);
    Jump('BackToWall');
    End();
SwitchWallJump:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoWallJump');
    SendPatternEvent('DescLatent','LatentDesc');
GoWallJump:
    SetFlags(WallJumpPlayed,FALSE);
    Jump('WallJump');
    End();
SwitchFenceClimbing:
    Log("");
    CheckFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE,'GoFenceClimbing');
    SendPatternEvent('DescLatent','LatentDesc');
GoFenceClimbing:
    SetFlags(FenceClimbingPlayed,FALSE);
    Jump('FenceClimbing');
    End();
DoNothing:
    End();

}

