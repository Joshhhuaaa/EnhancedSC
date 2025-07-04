//=============================================================================
// Console - A quick little command line console that accepts most commands.

//=============================================================================
class Console extends Interaction;
	
// BEGIN UBI MODIF
#exec TEXTURE IMPORT NAME=ConsoleBK FILE=TEXTURES\Black.PCX
#exec TEXTURE IMPORT NAME=ConsoleBdr FILE=TEXTURES\White.PCX
// END UBI MODIF
	
// Constants.
const MaxHistory=16;		// # of command history to remember.

// Variables

var globalconfig byte ConsoleKey;			// Key used to bring up the console

var int HistoryTop, HistoryBot, HistoryCur;
var string TypedStr, History[MaxHistory]; 	// Holds the current command, and the history
var bool bTyping;							// Turn when someone is typing on the console							

//-----------------------------------------------------------------------------
// Exec functions accessible from the console and key bindings.

// Begin typing a command on the console.
function Type()
{
	if(!Master.bZoufff)
	{
		TypedStr="";
		GotoState( 'Typing' );
	}
}
 
//-----------------------------------------------------------------------------
// Message - By default, the console ignores all output.
//-----------------------------------------------------------------------------

event Message( coerce string Msg, float MsgLife);

//-----------------------------------------------------------------------------
// Check for the console key.

function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	if( Action!=IST_Press )
		return false;
	else if( Key==ConsoleKey)
	{
		Type();
		return true;
	}
	else 
		return false;

} 

//-----------------------------------------------------------------------------
// State used while typing a command on the console.

state Typing
{
	function Type()
	{
		TypedStr="";
		gotoState( '' );
	}
	function bool KeyType( EInputKey Key )
	{
		if( Key>=0x20 && Key<0x100 && Key!=Asc("~") && Key!=Asc("`") )
		{
			TypedStr = TypedStr $ Chr(Key);
			return true;
		}
	}
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string Temp;
		local int i;
	
		if( Key==IK_Escape )
		{
			if( TypedStr!="" )
			{
				TypedStr="";
				HistoryCur = HistoryTop;
				return true;
			}
			else
			{
				GotoState( '' );
			}
		}
		else if( global.KeyEvent( Key, Action, Delta ) )
		{
			return true;
		}
		else if( Action != IST_Press )
		{
			return false;
		}
		else if( Key==IK_Enter )
		{
			if( TypedStr!="" )
			{
				// Print to console.
				Message( TypedStr, 6.0 );

				History[HistoryTop] = TypedStr;
				HistoryTop = (HistoryTop+1) % MaxHistory;
				
				if ( ( HistoryBot == -1) || ( HistoryBot == HistoryTop ) )
					HistoryBot = (HistoryBot+1) % MaxHistory;

				HistoryCur = HistoryTop;

				// Make a local copy of the string.
				Temp=TypedStr;
				TypedStr="";
				
				if( !ConsoleCommand( Temp ) )
					Message( Localize("Errors","Exec","Core"), 6.0 );
					
				Message( "", 6.0 );
				GotoState('');
			}
			else
				GotoState('');
				
			return true;
		}
		else if( Key==IK_Up )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryBot)
					HistoryCur = HistoryTop;
				else
				{
					HistoryCur--;
					if (HistoryCur<0)
						HistoryCur = MaxHistory-1;
				}
				
				TypedStr = History[HistoryCur];
			}
			return True;
		}
		else if( Key==IK_Down )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryTop)
					HistoryCur = HistoryBot;
				else
					HistoryCur = (HistoryCur+1) % MaxHistory;
					
				TypedStr = History[HistoryCur];
			}			

		}
		else if( Key==IK_Backspace || Key==IK_Left )
		{
			if( Len(TypedStr)>0 )
				TypedStr = Left(TypedStr,Len(TypedStr)-1);
			return true;
		}
		return true;
	}
	
	function PostRender(Canvas Canvas)
	{
			local float xl,yl;
			local string OutStr;

			// Blank out a space

			Canvas.Font	 = Canvas.ETitleFont;
			OutStr = "(>"@TypedStr$"_";
			Canvas.Strlen(OutStr,xl,yl);

			Canvas.SetPos(10,436);
			Canvas.SetDrawColor(0,0,0);
			Canvas.DrawTile(Texture'ConsoleBK', 600, yl+6,0,0,32,32);

			Canvas.SetPos(10,436);	
			Canvas.SetDrawColor(0,255,0);
			Canvas.DrawTile(Texture'ConsoleBdr', 600, 2,0,0,32,32);

			Canvas.SetPos(10,440);
		    Canvas.bCenter = False;
			Canvas.SetDrawColor(128,128,128);
			Canvas.DrawText( OutStr, false );
	}
	
	function BeginState()
	{
		bTyping = true;
		bVisible= true;
		HistoryCur = HistoryTop;
	}
	function EndState()
	{
		bTyping = false;
		bVisible = false;
	}
}

defaultproperties
{
    HistoryBot=-1
    bRequiresTick=true
}