class ECommunicationBox extends Actor
		native;



/*-----------------------------------------------------------------------------
                      T Y P E   D E F I N I T I O N S 
-----------------------------------------------------------------------------*/

const MIN_COMBOX_HEIGHT = 42;
const OPEN_SPEED_FACTOR = 5;
const COMBOX_WIDTH  = 338;
const ICON_WIDTH = 40;
const REAL_BOX_HEIGHT = 80;

enum eSpecialEvent
{
	ST_NONE,
	ST_NOTEBOOK,
	ST_GOAL,
    ST_RECON
};

/*-----------------------------------------------------------------------------
                          M E M B E R   V A R I A B L E S 
-----------------------------------------------------------------------------*/

var ESList							HQList;				    //List of NPCs communications
var ESList							NPCList;				//List of NPCs communications
var ESList							ConsoleList;			//List of Console communications
var ESList							InventoryList;			//List of Inventory communications
var ESList							QueuedList;			    //List pended transmissions


var transient ECanvas				GCanvas;				//To access function StrLen() outside Draw.
var int								NPCNb;				    //Number of elements in NPCList
var int								ConsoleNb;			    //Number of elements in ConsoleList
var int								InventoryNb;	        //Number of elements in InventoryList
var float							TimeElapsed;			//TimeElapsed since the creation of the object
var EchelonEnums.eTransmissionType	CurrentTransmission;	//What is the current type of transmission displayed
var eSpecialEvent					CurrentSpecialEvent;
var Actor							CurrentOwner;

var float							BlinkTime;
var bool							bBlink;

var bool							bLock;
var bool							bFree;
var EListNode						ConversationNode;

var	EchelonGameInfo			        eGame;
var EchelonLevelInfo                eLevel;
var int                             openHeight;
var FLOAT                           fTimer;
var FLOAT                           fDuration;
var bool                            bWithVoice;

native(1401) final function AddTransmission(Actor Owner, EchelonEnums.eTransmissionType eType, String TextData, Sound SoundData, optional byte eEvent, optional String SpecialString); //Fblais
native(1402) final function GetCurrentSize(out float YL); //Fblais

/*-----------------------------------------------------------------------------
    Conversation
-----------------------------------------------------------------------------*/

function Lock()
{
    bLock = true;
}

function Unlock()
{
	bLock = false;
	bWithVoice = false;
	CurrentTransmission = TR_NONE;
	CurrentOwner = None;
}

function bool bIsFree()
{
    return bFree;
}

function Draw(ECanvas Canvas)
{
    GCanvas = Canvas;
}
function Tick(float Delta)
{
    fTimer += Delta;
}

function ResetContent()
{
}

function DrawMenuSpeech(ECanvas Canvas)
{
}

/*-----------------------------------------------------------------------------
 Function:      PostBeginPlay

 Description:   -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
	TimeElapsed = 0;
	NPCNb = 0;
	ConsoleNb = 0;

	bLock = false;
	bFree = true;

	SetTimer(0.5,false);

    eGame  = EchelonGameInfo(Level.Game);
    eLevel = EchelonLevelInfo(Level);
}

/*-----------------------------------------------------------------------------
 Function:      GetCurrentNode

 Description:   -
-----------------------------------------------------------------------------*/
event  EListNode GetCurrentNode()
{
	switch (CurrentTransmission)
	{
    case TR_HINT:
	case TR_CONSOLE:
		return ConsoleList.FirstNode;
		break;
	case TR_NPCS:
		return NPCList.FirstNode;
		break;
	case TR_HEADQUARTER:
		//return HQList.FirstNode;
		//break;
    case TR_MENUSPEECH:
	case TR_CONVERSATION:
		return ConversationNode;
		break;
    case TR_INVENTORY:
	case TR_COMMWARNING:
		return InventoryList.FirstNode;
		break;
	default:
		break;
	}

	return None;
}

/*-----------------------------------------------------------------------------
 Function:      DrawBox

 Description:   -
-----------------------------------------------------------------------------*/
function DrawBox(ECanvas Canvas, int xPos, int yPos, int width, int height, bool bExpand)
{
    // FILL BACKGROUND //
    Canvas.DrawLine(xPos + 5, yPos + 6, width - 10, height - 12, Canvas.white, -1, eLevel.TGAME);

    Canvas.SetDrawColor(128, 128, 128);

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

    // INSIDE BORDERS //
    Canvas.DrawRectangle(xPos + 5, yPos + 6, width - 10, height - 12, 1, Canvas.black, 77/*INSIDE_BORDER_ALPHA*/, eLevel.TGAME);

    if (bExpand)
    {
        Canvas.SetDrawColor(64, 64, 64);
        Canvas.Style = ERenderStyle.STY_Modulated;

        Canvas.SetPos(xPos + width - 6 - ICON_WIDTH, yPos + 7);
        eLevel.TICON.DrawTileFromManager(Canvas, eLevel.TICON.com_ic_console, ICON_WIDTH, height - 14, 0, 0, 1, 1);

        Canvas.Style = ERenderStyle.STY_Normal;
    }
}

/*-----------------------------------------------------------------------------
 Function:      DrawBoxBackground

 Description:   -
-----------------------------------------------------------------------------*/
function DrawBoxBackground(ECanvas Canvas, int xPos, int yPos, int width, int height)
{
    Canvas.SetDrawColor(64, 64, 64, 255);
    Canvas.Style = ERenderStyle.STY_Modulated;

    Canvas.SetPos(xPos + 5, yPos + 6);
    Canvas.DrawTile(Texture'HUD.HUD.ETMenuBar', width - 10, height - 12, 0, 0, 128, 2);

    Canvas.Style = ERenderStyle.STY_Normal;
}

/*-----------------------------------------------------------------------------
 Function:      DrawIcon

 Description:   -
-----------------------------------------------------------------------------*/
function DrawIcon(ECanvas Canvas, int iconIndex, int xBoxPos, int yBoxPos, int boxWidth, int boxHeight)
{
    local  int iconWidth, iconHeight;
    local float fillHeight;

    iconWidth = eLevel.TICON.GetWidth(iconIndex);
    iconHeight = eLevel.TICON.GetHeight(iconIndex);

    // DRAW ICON IN THE CENTER //
    Canvas.SetDrawColor(64, 64, 64);
    Canvas.Style = ERenderStyle.STY_Modulated;

    Canvas.SetPos(xBoxPos + boxWidth - 6 - ICON_WIDTH + (ICON_WIDTH - iconWidth) / 2, yBoxPos + (boxHeight - iconHeight) / 2);
    eLevel.TICON.DrawTileFromManager(Canvas, iconIndex, iconWidth, iconHeight, 0, 0, iconWidth, iconHeight);

    // FILL BACKGROUND //

    // TOP //
    Canvas.SetPos(xBoxPos + boxWidth - 6 - ICON_WIDTH, yBoxPos + 7);
    eLevel.TICON.DrawTileFromManager(Canvas, eLevel.TICON.com_ic_console, ICON_WIDTH, (boxHeight - 14 - iconHeight) / 2, 0, 0, 1, 1);

    // BOTTOM //
    Canvas.SetPos(xBoxPos + boxWidth - 6 - ICON_WIDTH, yBoxPos + 7 + (boxHeight - 14 - iconHeight) / 2 + iconHeight);
    fillHeight = (boxHeight - 14 - iconHeight) / 2;
    if (fillHeight > int(fillHeight))
        fillHeight = int(fillHeight) + 1;
    eLevel.TICON.DrawTileFromManager(Canvas, eLevel.TICON.com_ic_console, ICON_WIDTH, fillHeight, 0, 0, 1, 1);

    // LEFT //
    Canvas.SetPos(xBoxPos + boxWidth - 6 - ICON_WIDTH, yBoxPos + 7 + (boxHeight - 14 - iconHeight) / 2);
    eLevel.TICON.DrawTileFromManager(Canvas, eLevel.TICON.com_ic_console, (ICON_WIDTH - iconWidth) / 2, iconHeight, 0, 0, 1, 1);

    // RIGHT //
    Canvas.SetPos(xBoxPos + boxWidth - 6 - (ICON_WIDTH - iconWidth) / 2, yBoxPos + 7 + (boxHeight - 14 - iconHeight) / 2);
    eLevel.TICON.DrawTileFromManager(Canvas, eLevel.TICON.com_ic_console, (ICON_WIDTH - iconWidth) / 2, iconHeight, 0, 0, 1, 1);

    Canvas.Style = ERenderStyle.STY_Normal;
}

function ScrollText(ECanvas Canvas, float _yLen, int iNbrOfBoxLine, int iNbrOfLine, String _MyText)
{
	local int iStartLine, iEndLine, i;
	local float fTimePerLine;
	local String sTempMsg;

	// Text is shorter than the height of box, so display everything
	if (iNbrOfLine <= iNbrOfBoxLine)
	{
		Canvas.DrawText(_MyText, false);
	}
	else
	{		
		// Compute nbr of sec for each line 
		fTimePerLine = fDuration / iNbrOfLine;	
		
		// Find first and last line to display based on time elapsed since first line displayed.		
		iStartLine = iNbrOfLine - int((fDuration - fTimer + (iNbrOfBoxLine * fTimePerLine) - fTimePerLine) / fTimePerLine) ;		
		if (iStartLine < 1) iStartLine = 1;

		iEndLine = iStartLine + iNbrOfBoxLine - 1;		
				
		// Append all the line we want to display on the screen
		for (i = iStartLine; i <= iEndLine; i++)
		{
			sTempMsg = sTempMsg $ Canvas.GetStringAtPos(_MyText, i, 1.0f) $ " ";
		}
		
		// Display the appended lines
		Canvas.DrawText(sTempMsg, false);
	}	
}

/*-----------------------------------------------------------------------------
 Function:      SetClipZone

 Description:   -
-----------------------------------------------------------------------------*/
event SetClipZone(ECanvas C)
{
    C.Font = C.ETextFont;
	C.SetOrigin(eGame.HUD_OFFSET_X + 7,eGame.HUD_OFFSET_Y + 7);
    C.SetPos(0,0);
	C.SetClip(COMBOX_WIDTH - 16 - ICON_WIDTH,480);
}

/*-----------------------------------------------------------------------------
 Function:      ResetClipZone

 Description:   -
-----------------------------------------------------------------------------*/
event ResetClipZone(ECanvas C)
{
	C.SetOrigin(0,0);
    C.SetPos(0,0);	
	C.SetClip(640,480);
}

/*-----------------------------------------------------------------------------
 Function:      DrawConfig

 Description:   Draw Communication when set position of hud items in main menu
-----------------------------------------------------------------------------*/
function DrawConfig(ECanvas Canvas)
{
    // DRAW BOX //
    DrawBox(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, MIN_COMBOX_HEIGHT + 16, false);
    DrawBoxBackground(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, MIN_COMBOX_HEIGHT + 16);
}

//-----------------------------------------------------------------------------------------------------------------
// state : Idle
//-----------------------------------------------------------------------------------------------------------------
auto state() Idle
{            
	function Tick(float Delta)
	{
		//Get current transmission Node
		if (GetCurrentNode() != None)
		{
			GotoState('BeginDisplay');
		}
	}

	function Draw(ECanvas Canvas)
	{
		//assign canvas
		GCanvas = Canvas;
	}

}

//-----------------------------------------------------------------------------------------------------------------
// state StandardDisplay
//-----------------------------------------------------------------------------------------------------------------
state() StandardDisplay
{
	function Draw(ECanvas Canvas)
	{
        local EListNode Node;
        local float height, tmpVal, xLen, yLen;
        local int iconIndex, xTextPos, yTextPos, color, iNbrOfLine, iNbrOfBoxLine;
        local ETransmissionObj T, TT;
		local bool bIsAGoal;
		local String MyLine;

		GCanvas = Canvas;

        Canvas.Font = Canvas.ETextFont;
		Canvas.TextSize("T", xLen, yLen);

        // Get Current Transmission Node //
        Node = GetCurrentNode();

		if (bWithVoice)
		{
			// Set Communication Box height	
			height = REAL_BOX_HEIGHT;
		}
		else
		{        
			GetCurrentSize(height); 
			height += 30; //Hack to fit the word OBJECTIVE on first line
			
			if (height < MIN_COMBOX_HEIGHT)
			    height = MIN_COMBOX_HEIGHT;
		}
        
        // DRAW BOX //
        DrawBox(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, height + 16, false);

		// Reset the flag

		bIsAGoal = false;
        // SET ICON //
        if (Node != None)
        {
            switch (CurrentSpecialEvent)
			{
			    case ST_NOTEBOOK:
                    iconIndex = eLevel.TICON.com_ic_notes;						
                    break;
			    case ST_GOAL:
                    iconIndex = eLevel.TICON.com_ic_goals;
					bIsAGoal = true;					
                    break;
                case ST_RECON:
                    iconIndex = eLevel.TICON.com_ic_recon;										
                    break;
    			default:
	    			switch (CurrentTransmission)
				    {
				        case TR_CONSOLE:
                            iconIndex = eLevel.TICON.com_ic_console;														
                            break;
    				    case TR_NPCS:
                            iconIndex = eLevel.TICON.com_ic_npc;														
                            break;
    				    case TR_HEADQUARTER:
						case TR_COMMWARNING:
                            iconIndex = eLevel.TICON.com_ic_headq;														
                            break;
                        case TR_MENUSPEECH:							
				        case TR_CONVERSATION:
                            iconIndex = eLevel.TICON.com_ic_talk;														
                            break;
                        case TR_INVENTORY:
                            iconIndex = eLevel.TICON.com_ic_inventory;														
                            break;
                        case TR_HINT:
                            iconIndex = eLevel.TICON.com_ic_hints;														
                            break;
        				default:
		        			break;
				    }
				    break;
			}

			// Find nbr of line in the box, based on box height
			if (bWithVoice)
			{
				if (bIsAGoal)			
					iNbrOfBoxLine = (height - yLen) / yLen;			
				else
					iNbrOfBoxLine = height / yLen;						
			}
			

            // DRAW ICON //
            DrawIcon(Canvas, iconIndex, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, height + 16);

            // SET TEXT //            
            xTextPos = 0;
            yTextPos = 0;

            SetClipZone(Canvas);

            while (Node != None)
			{		
				T = ETransmissionObj(Node.Data);
								
				if (bWithVoice)
					iNbrOfLine = Canvas.GetNbStringLines(T.Data, 1.0f);								
												
                if ((CurrentTransmission != TR_CONVERSATION) && (CurrentTransmission != TR_HEADQUARTER) && (CurrentTransmission != TR_MENUSPEECH))
                {
                    tmpVal = (TimeElapsed - T.InsertionTime) / TimerRate;
                    if (tmpVal > 1.0f)
						tmpVal = 1.0f;

                    color = Canvas.TextBlack.R + (50 - (tmpVal * 50.0f));
                    Canvas.SetDrawColor(color, color, color);
                }
                else
                    Canvas.DrawColor = Canvas.TextBlack;

                // Display a blinking OBJECTIVE when it`s a goal 
				if (bIsAGoal)
				{
					// DRAW TEXT				
					Canvas.SetDrawColor(128, 128, 128, 153);
					Canvas.Style = ERenderStyle.STY_Alpha;
					//Canvas.DrawLine(xTextPos, yTextPos + 1, COMBOX_WIDTH - 15 - ICON_WIDTH, 15, Canvas.black, 150, eLevel.TMENU);
                    // Joshua - Adjusted objective bar for consistency (adding 1px to the right, subtracting 1px from the bottom)
                    Canvas.DrawLine(xTextPos, yTextPos + 1, COMBOX_WIDTH - 14 - ICON_WIDTH, 14, Canvas.black, 150, eLevel.TMENU);
					Canvas.SetDrawColor(128, 128, 128);
					Canvas.Style = ERenderStyle.STY_Normal;

					Canvas.SetPos(xTextPos,yTextPos);
				
					// Display the word OBJECTIVE in a blinking way
					if (!bBlink)
					{
						Canvas.DrawText(Localize("HUD", "OBJECTIVE", "Localization\\HUD"), false);						
					}
					
					Canvas.DrawColor = Canvas.TextBlack;
					Canvas.SetPos(0,18);														
				}
				else
					Canvas.SetPos(xTextPos,yTextPos);
				
				if (bWithVoice)
					ScrollText(Canvas, yLen, iNbrOfBoxLine, iNbrOfLine, T.Data);
				else
					Canvas.DrawText(T.Data,false);

				yTextPos += T.YSpace;
				Node = Node.NextNode;
            }			

            ResetClipZone(Canvas);
        }
        else
		{			
			bWithVoice = false;
			GotoState('EndDisplay');
		}

        DrawBoxBackground(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, height + 16);
	}
}

//-----------------------------------------------------------------------------------------------------------------
// state : BeginDisplay
//-----------------------------------------------------------------------------------------------------------------
state() BeginDisplay
{
	function BeginState()
	{
		openHeight = 0;
	}

	function Tick(float Delta)
	{
		openHeight += MIN_COMBOX_HEIGHT / OPEN_SPEED_FACTOR;

		if (openHeight >= MIN_COMBOX_HEIGHT)
		{
			openHeight = MIN_COMBOX_HEIGHT;
			
			GotoState('StandardDisplay');
		}
	}

	function Draw(ECanvas Canvas)
    {
		GCanvas = Canvas;
		DrawBox(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, openHeight + 16, true);
        DrawBoxBackground(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, openHeight + 16);
	}
}


//-----------------------------------------------------------------------------------------------------------------
// state : EndDisplay
//-----------------------------------------------------------------------------------------------------------------
state() EndDisplay
{
    function BeginState()
	{
		openHeight = MIN_COMBOX_HEIGHT;
	}

    function Tick(float Delta)
	{
		openHeight -= MIN_COMBOX_HEIGHT / OPEN_SPEED_FACTOR;

		if (openHeight <= 0)
		{
			openHeight = 0;
			GotoState('Idle');
		}
	}

    function Draw(ECanvas Canvas)
	{
		GCanvas = Canvas;
		DrawBox(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, openHeight + 16, true);
        DrawBoxBackground(Canvas, eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, openHeight + 16);
	}
}

//-----------------------------------------------------------------------------------------------------------------
// state : s_Cinematic
//-----------------------------------------------------------------------------------------------------------------
state s_Cinematic
{
	/*
    function Draw(ECanvas Canvas)
    {
        local EListNode Node;
        local int yTextPos;
        local ETransmissionObj T;
        local float xLen, yLen;

		GCanvas = Canvas;
        Canvas.Font = Canvas.ETextFont;
        Canvas.DrawColor = Canvas.white;
        Canvas.SetClip(600, 480);
        Canvas.TextSize("T", xLen, yLen);

        // Get Current Transmission Node //
        Node = GetCurrentNode();
        yTextPos = 430;

        while (Node != None)
		{		
			T = ETransmissionObj(Node.Data);

            //if ((CurrentTransmission != TR_CONVERSATION) && (CurrentTransmission != TR_HEADQUARTER))

            // DRAW TEXT//
            Canvas.SetPos(320,yTextPos);
			Canvas.DrawTextAligned(T.Data , TXT_CENTER);

            Canvas.SetPos(0,0);
            yTextPos += yLen * Canvas.GetNbStringLines(T.Data, 1.0f);

			//yTextPos += T.YSpace;
			Node      = Node.NextNode;
        }

        Canvas.SetClip(640, 480);
    }*/
}

//-----------------------------------------------------------------------------------------------------------------
// state : s_Menu
//-----------------------------------------------------------------------------------------------------------------
state s_Menu
{
    function DrawMenuSpeech(ECanvas Canvas)
    {
        local EListNode Node;
        local float height;
        local int xTextPos, yTextPos;
        local ETransmissionObj T;

        Canvas.Font = Canvas.ETextFont;

        // Get Current Transmission Node //
        Node = GetCurrentNode();

        // Set Communication Box height //
        GetCurrentSize(height);
        if (height < MIN_COMBOX_HEIGHT)
            height = MIN_COMBOX_HEIGHT;
        
        if (Node != None)
        {
            if (CurrentTransmission != TR_MENUSPEECH)
                return;

            // DRAW BOX //
            DrawBox(Canvas, 640 - COMBOX_WIDTH - eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, height + 16, false);

            // DRAW ICON //
            DrawIcon(Canvas, eLevel.TICON.com_ic_talk, 640 - COMBOX_WIDTH - eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, height + 16);

            // SET TEXT //
            xTextPos = 0;
            yTextPos = 0;

            Canvas.Font = Canvas.ETextFont;
	        Canvas.SetOrigin(640 - COMBOX_WIDTH - eGame.HUD_OFFSET_X + 7,eGame.HUD_OFFSET_Y + 7);
            Canvas.SetPos(0,0);
	        Canvas.SetClip(COMBOX_WIDTH - 16 - ICON_WIDTH,480);

            while (Node != None)
		    {		
			    T = ETransmissionObj(Node.Data);
                Canvas.DrawColor = Canvas.TextBlack;

                // DRAW TEXT//
                Canvas.SetPos(xTextPos,yTextPos);
			    Canvas.DrawText(T.Data,false);

			    yTextPos += T.YSpace;
			    Node      = Node.NextNode;
            }

            ResetClipZone(Canvas);

            DrawBoxBackground(Canvas, 640 - COMBOX_WIDTH - eGame.HUD_OFFSET_X, eGame.HUD_OFFSET_Y, COMBOX_WIDTH, height + 16);
        }
    }
}

defaultproperties
{
    bHidden=True
}