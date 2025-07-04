class UWindowBase extends Object 
        native;

// Fonts array constants
const F_Normal = 0;			// Normal font
const F_Bold = 1;			// Bold font
const F_Large = 2;			// Large font
const F_LargeBold = 3;		// Large, Bold font

struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};

struct TexRegion
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
	var() Texture T;
};

enum FrameHitTest
{
	HT_NW,
	HT_N,
	HT_NE,
	HT_W,
	HT_E,
	HT_SW,
	HT_S,
	HT_SE,
	HT_TitleBar,
	HT_DragHandle,
	HT_None
};

enum MenuSound
{
	MS_MenuPullDown,
	MS_MenuCloseUp,
	MS_MenuItem,
	MS_WindowOpen,
	MS_WindowClose,
	MS_ChangeTab
};

enum MessageBoxButtons
{
	MB_YesNo,
	MB_OKCancel,
	MB_OK,
	MB_YesNoCancel,
    MB_Cancel
};

enum MessageBoxResult
{
	MR_None,
	MR_Yes,
	MR_No,
	MR_OK,
	MR_Cancel	// also if you press the Close box.
};

enum PropertyCondition
{
	PC_None,
	PC_LessThan,
	PC_Equal,
	PC_GreaterThan,
	PC_NotEqual,
	PC_Contains,
	PC_NotContains
};

struct HTMLStyle
{
	var int BulletLevel;			// 0 = no bullet depth
	var string LinkDestination;
	var Color TextColor;
	var Color BGColor;
	var bool bCenter;
	var bool bLink;
	var bool bUnderline;
	var bool bNoBR;
	var bool bHeading;
	var bool bBold;
	var bool bBlink;
};

function Region NewRegion(float X, float Y, float W, float H)
{
	local Region R;
	R.X = X;
	R.Y = Y;
	R.W = W;
	R.H = H;
	return R;
}

function TexRegion NewTexRegion(float X, float Y, float W, float H, Texture T)
{
	local TexRegion R;
	R.X = X;
	R.Y = Y;
	R.W = W;
	R.H = H;
	R.T = T;
	return R;
}

function Region GetRegion(TexRegion T)
{
	local Region R;

	R.X = T.X;
	R.Y = T.Y;
	R.W = T.W;
	R.H = T.H;

	return R;
}

static function int InStrAfter(string Text, string Match, int Pos)
{
	local int i;
	
	i = InStr(Mid(Text, Pos), Match);
	if(i != -1)
		return i + Pos;
	return -1;
}

static function Object BuildObjectWithProperties(string Text)
{
	local int i;
	local string ObjectClass, PropertyName, PropertyValue, Temp;
	local class<Object> C;
	local Object O;
	
	i = InStr(Text, ",");
	if(i == -1)
	{
		ObjectClass=Text;
		Text="";
	}
	else
	{
		ObjectClass=Left(Text, i);
		Text=Mid(Text, i+1);
	}
	
	//Log("Class: "$ObjectClass);

	C = class<Object>(DynamicLoadObject(ObjectClass, class'Class'));
	O = new C;

	while(Text != "")
	{
		i = InStr(Text, "=");
		if(i == -1)
		{
			Log("Missing value for property "$ObjectClass$"."$Text);
			PropertyName=Text;
			PropertyValue="";
		}
		else
		{
			PropertyName=Left(Text, i);
			Text=Mid(Text, i+1);
		}

		if(Left(Text, 1) == "\"")
		{
			i = InStrAfter(Text, "\"", 1);
			if(i == -1)
			{
				Log("Missing quote for "$ObjectClass$"."$PropertyName);
				return O;
			}
			PropertyValue = Mid(Text, 1, i-1);
			
			Temp = Mid(Text, i+1, 1);
			if(Temp != "" && Temp != ",")
				Log("Missing comma after close quote for "$ObjectClass$"."$PropertyName);
			Text = Mid(Text, i+2);	
		}
		else
		{
			i = InStr(Text, ",");
			if(i == -1)
			{
				PropertyValue=Text;
				Text="";
			}
			else
			{
				PropertyValue=Left(Text, i);
				Text=Mid(Text, i+1);
			}
		}
				
		//Log("Property: "$PropertyName$" => "$PropertyValue);
		O.SetPropertyText(PropertyName, PropertyValue);
	}

	return O;
}
