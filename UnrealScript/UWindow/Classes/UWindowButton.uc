//=============================================================================
// UWindowButton - A button
//=============================================================================
class UWindowButton extends UWindowDialogControl
        native;


var texture		UpTexture, DownTexture, DisabledTexture, OverTexture;
var Region		UpRegion,  DownRegion,  DisabledRegion,  OverRegion;

var FLOAT		RegionScale;
var FLOAT		ImageX, ImageY;

var INT			m_iButtonID;	         // Can be used to set a special Id to this button


var BOOL		bStretched;
var BOOL		bUseRegion;

//Button is Selected
var BOOL		    m_bSelected;
var BOOL		    bDisabled;


var BOOL		    m_bDrawButtonBorders;

var sound		    OverSound, DownSound;

var FLOAT			m_fLMarge;
var FLOAT			m_fFontSpacing;


//Different State TextColor
var Color   m_SelectedTextColor;
var Color   m_DisabledTextColor;
var Color   m_OverTextColor;


function Created()
{
	Super.Created();	
	RegionScale = 1;
}

function SetButtonText(string _Text, ECanvas.ETextAligned _Align)
{
    text = _Text;    
    Align = _Align;    
}


function Paint(Canvas C, float X, float Y)
{    

    Render(C , X, Y);    

    if (m_bDrawButtonBorders)
	{
		DrawSimpleBorder(C);
	}
}


function Click(float X, float Y) 
{
    if (bDisabled)
        return;

	Notify(DE_Click);

//R6CODE    
//    log("CLICK Sound =" @ DownSound);
    if (DownSound != None)
		GetPlayerOwner().PlaySound(DownSound, SLOT_Interface);
//END R6CODE        
}

function DoubleClick(float X, float Y) 
{
    if (!bDisabled)
	Notify(DE_DoubleClick);
}

function RClick(float X, float Y) 
{
    if (!bDisabled)
	Notify(DE_RClick);
}

function MClick(float X, float Y) 
{
    if (!bDisabled)
	Notify(DE_MClick);
}

function MouseEnter()
{
    Super.MouseEnter();
    Notify(DE_Enter);
}

function MouseLeave()
{
	Super.MouseLeave();
    Notify(DE_Exit);
}

defaultproperties
{
    RegionScale=1.000000
    m_SelectedTextColor=(R=0,G=0,B=0,A=255)
    m_DisabledTextColor=(R=0,G=0,B=0,A=255)
    m_OverTextColor=(R=0,G=0,B=0,A=255)
    bNoKeyboard=True
    bIgnoreLDoubleClick=True
    bIgnoreMDoubleClick=True
    bIgnoreRDoubleClick=True
}