class ETimer extends Actor
	placeable;

#exec Texture Import File=..\Engine\Textures\Echelon\ETimer.pcx Name=ETimer Mips=Off Flags=2 NOCONSOLE

const TIMER_WITDH_LARGE = 110;
const TIMER_WITDH_SMALL = 80;
const TIMER_HEIGHT      = 30;
const TIMER_X_OFFSET    = 16;
const TIMER_Y_OFFSET    = 343;

var() float             TimerDelay;         // Start timer value
var() float             CriticalDelay;      // Time value when timer goes red
var() name              GroupTag;
var() name              JumpLabel;
var() bool              bDisplayInterface;
var() Sound             StartSound;
var() Sound             EndSound;
var	EchelonGameInfo     eGame;
var EchelonLevelInfo    eLevel;
var int                 boxWidth;
var bool				SoundPlayed;

function PostBeginPlay()
{
    eGame  = EchelonGameInfo(Level.Game);
    eLevel = EchelonLevelInfo(Level);
}

event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
{
	GotoState('s_Running');
}

state s_Running
{
    function BeginState()
    {
        if(bDisplayInterface)
        {
            EMainHUD(eGame.pPlayer.myHUD).TimerView = self;

            if( TimerDelay < 60 )
                boxWidth = TIMER_WITDH_SMALL;
            else
                boxWidth = TIMER_WITDH_LARGE;
        }
    }

    function Tick(float DeltaTime)
    {
		local EGroupAI Group;

		if (!SoundPlayed)
		{
			PlaySound(StartSound, SLOT_Interface);
			SoundPlayed=true;
		}

        TimerDelay -= DeltaTime;
        if( TimerDelay <= 0.0f )
		{
			if( GroupTag != '' )
			{
				foreach DynamicActors( class'EGroupAI', Group, GroupTag)
				{
					Group.SendJumpEvent(JumpLabel, false, false);
					break;
				}
			}

            Destroy();
		}
    }

    function EndState()
    {
        if(bDisplayInterface)
            EMainHUD(eGame.pPlayer.myHUD).TimerView = None;

		PlaySound(EndSound, SLOT_Interface);
    }

    event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
	{
		PlaySound(EndSound, SLOT_Interface);
		Destroy();
	}
}

function PostRender(ECanvas Canvas)
{
    local int xPos, yPos;
    local int min, sec, cen;
    local string szTimer;
    local float xLen, yLen;

	
    // Set Timer pos //
    xPos = eGame.HUD_OFFSET_X + TIMER_X_OFFSET;
	yPos = eGame.HUD_OFFSET_Y + TIMER_Y_OFFSET; 		

    DrawBox(Canvas, xPos, yPos, boxWidth, TIMER_HEIGHT);

    Canvas.Font = Canvas.ETitleBoldFont;

    if(TimerDelay > CriticalDelay)
        Canvas.SetDrawColor(64,64,64);
    else
        Canvas.SetDrawColor(64,0,0);

    // Set timer value //
    min = TimerDelay / 60.0f;
    sec = TimerDelay - min * 60.0f;
    cen = int((TimerDelay - (min * 60.0f + sec)) * 100.0f);

    // Set output string //
    szTimer = "";
    if(boxWidth == TIMER_WITDH_LARGE)
    {
        if(min < 10)
            szTimer = szTimer$"0"$min;
        else
            szTimer = szTimer$min;
    
        if(sec < 10)
            szTimer = szTimer$":0"$sec;
        else
            szTimer = szTimer$":"$sec;
    }
    else
    {
        if(sec < 10)
            szTimer = szTimer$"0"$sec;
        else
            szTimer = szTimer$sec;
    }
    if(cen < 10)
        szTimer = szTimer$":0"$cen;
    else
        szTimer = szTimer$":"$cen;

    Canvas.TextSize(szTimer, xLen, yLen);
    Canvas.SetPos(xPos + (boxWidth - xLen)/2, yPos + (TIMER_HEIGHT - yLen)/2);
    Canvas.DrawText(szTimer);
}

/*-----------------------------------------------------------------------------
 Function:      DrawBox

 Description:   -
-----------------------------------------------------------------------------*/
function DrawBox(ECanvas Canvas, int xPos, int yPos, int width, int height)
{
    // FILL BACKGROUND //
    Canvas.DrawLine(xPos + 5, yPos + 6, width - 10, height - 12, Canvas.black, -1, eLevel.TGAME);

    Canvas.SetDrawColor(128,128,128);

    // CORNERS //

    // TOP LEFT CORNER //
    Canvas.SetPos(xPos, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 0, 7, 8, -7);

    // BOTTOM LEFT CORNER //
    Canvas.SetPos(xPos, yPos + height - 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 0, 0, 8, 7);

    // TOP RIGHT CORNER //
    Canvas.SetPos(xPos + width - 8, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 8, 7, -8, -7);

    // BOTTOM RIGHT CORNER //
    Canvas.SetPos(xPos + width - 8, yPos + height - 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 8, 0, -8, 7);

    // OUTSIDE BORDERS //

    // TOP BORDER //
    Canvas.SetPos(xPos + 8, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_h, width - 16, 6, 0, 6, 1, -6);

    // BOTTOM BORDER //
    Canvas.SetPos(xPos + 8, yPos + height - 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_h, width - 16, 6, 0, 0, 1, 6);

    // LEFT BORDER //
    Canvas.SetPos(xPos, yPos + 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_v, 5, height - 14, 0, 0, 5, 1);

    // RIGHT BORDER //
    Canvas.SetPos(xPos + width - 5, yPos + 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_v, 5, height - 14, 5, 0, -5, 1);
}

defaultproperties
{
    CriticalDelay=-1.000000
    bDisplayInterface=true
    bHidden=true
    Texture=Texture'ETimer'
}