class UWindowHTMLTextArea extends UWindowDynamicTextArea;

/*

HTML Currently Supported
========================

Parsed on add
-------------
<body bgcolor=#ffffff link=#ffffff alink=#ffffff>...</body>
<font color=#ffffff bgcolor=#ffffff>...</font>
<br>
<center>....</center>
<p>
<h1>...</h1>

Parsed on add and display
-------------------------
<nobr>...</nobr>
<a href="...">...</a>
<b>...</b>
<u>...</u>
<blink>...</blink>

Parsed only on display
----------------------
&gt;
&lt;
&amp;
&nbsp;

Planned improvements
--------------------
<ul><li>item 1<li>item 2...</ul>
<table>...</table>

Bugs
----
The parsing is pretty slack!

*/

// default styles
var Color TextColor;
var Color BGColor;
var Color LinkColor;
var Color ALinkColor;
var float LastBlinkTime;
var bool bShowBlink;
var bool bReleased;

function SetHTML(string HTML)
{
	Clear();
	ReplaceText(HTML, Chr(13)$Chr(10), " ");
	ReplaceText(HTML, Chr(13), " ");
	ReplaceText(HTML, Chr(10), " ");
	AddText(HTML);
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	Cursor = Root.NormalCursor;
}

function Paint(Canvas C, float X, float Y)
{
	C.DrawColor = BGColor;
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'WhiteTexture');
	Super.Paint(C, X, Y);
	bReleased = False;
}

function Click(float X, float Y)
{
	Super.Click(X, Y);
	bReleased = True;
}

function ProcessURL(string URL)
{
	Log("Clicked Link: >>"$URL$"<<");

	if( Left(URL, 7) ~= "mailto:" )
		GetPlayerOwner().ConsoleCommand("start "$URL);
	if( Left(URL, 7) ~= "http://" )
		GetPlayerOwner().ConsoleCommand("start "$URL);
	if( Left(URL, 6) ~= "ftp://" )
		GetPlayerOwner().ConsoleCommand("start "$URL);
	if( Left(URL, 9) ~= "telnet://" )
		GetPlayerOwner().ConsoleCommand("start "$URL);
	if( Left(URL, 9) ~= "gopher://" )
		GetPlayerOwner().ConsoleCommand("start "$URL);
	if( Left(URL, 4) ~= "www." )
		GetPlayerOwner().ConsoleCommand("start http://"$URL);
	if( Left(URL, 4) ~= "ftp." )
		GetPlayerOwner().ConsoleCommand("start ftp://"$URL);
	else
	if( Left(URL, 9) ~= "unreal://" )
		LaunchUnrealURL(URL);
}

function OverURL(string URL)
{
}

function LaunchUnrealURL(string URL)
{
	GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
}

function TextAreaTextSize(Canvas C, string Text, out float W, out float H)
{
	ReplaceText(Text, "&nbsp;", " ");
	ReplaceText(Text, "&gt;", ">");
	ReplaceText(Text, "&lt;", "<");
	ReplaceText(Text, "&amp;", "&");

	TextSize(C, Text, W, H);
}

function TextAreaClipText(Canvas C, float DrawX, float DrawY, coerce string Text, optional bool bCheckHotkey)
{
	ReplaceText(Text, "&nbsp;", " ");
	ReplaceText(Text, "&gt;", ">");
	ReplaceText(Text, "&lt;", "<");
	ReplaceText(Text, "&amp;", "&");

	ClipText(C, DrawX, DrawY, Text, bCheckHotKey);
}

///////////////////////////////////////////////////////
// Overloaded functions from UWindowDynamicTextArea
///////////////////////////////////////////////////////

function WrapRow(Canvas C, UWindowDynamicTextRow L)
{
	local HTMLStyle CurrentStyle;
	local UWindowHTMLTextRow R;
	local string Input, LeftText, HTML, RightText;

	Super.WrapRow(C, L);

	// Generate the DisplayString and StyleString lines for each row
	R = UWindowHTMLTextRow(L);
	while(R != None && (R == L || R.WrapParent == L))
	{
		R.DisplayString = "";
		R.StyleString = "";

		CurrentStyle = R.StartStyle;
		
		Input = R.Text;
		while(Input != "")
		{
			ParseHTML(Input, LeftText, HTML, RightText);

			if(LeftText != "" || R.DisplayString == "")
			{
				R.DisplayString = R.DisplayString $ LeftText;
				R.StyleString = R.StyleString $ WriteStyleText(CurrentStyle, Len(LeftText));
			}

			ProcessInlineHTML(HTML, CurrentStyle);
			SetCanvasStyle(C, CurrentStyle);

			Input = RightText;
		}

		R = UWindowHTMLTextRow(R.Next);
	}	
}

function float DrawTextLine(Canvas C, UWindowDynamicTextRow L, float Y)
{
	local float X, W, H, MouseX, MouseY;
	local HTMLStyle CurrentStyle;
	local float RowHeight;
	local Color OldColor;
	local int StylePos, DisplayPos, i;
	local string S;

	RowHeight = 0;

	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;
	if(CurrentStyle.bCenter)
	{
		W = CalcHTMLTextWidth(C, L.Text, CurrentStyle);
		if(VertSB.bWindowVisible)
			X = int(((WinWidth - VertSB.WinWidth) - W) / 2);
		else
			X = int((WinWidth - W) / 2);
	}
	else
		X = 2;

	if(GetTime() > LastBlinkTime + 0.5)
	{
		bShowBlink = !bShowBlink;
		LastBlinkTime = GetTime();
	}

	if(UWindowHTMLTextRow(L).DisplayString == "")
		SetCanvasStyle(C, CurrentStyle);
	else
	{
		while(DisplayPos < Len(UWindowHTMLTextRow(L).DisplayString))
		{
			i = ReadStyleText(UWindowHTMLTextRow(L).StyleString, StylePos, CurrentStyle);
			S = Mid(UWindowHTMLTextRow(L).DisplayString, DisplayPos, i);
			DisplayPos += i;					
			SetCanvasStyle(C, CurrentStyle);

			TextAreaTextSize(C, S, W, H);
			if(H > RowHeight)
				RowHeight = H;

			if(CurrentStyle.bLink)
			{
				GetMouseXY(MouseX, MouseY);
				if(X < MouseX && X + W > MouseX && Y < MouseY && Y + H > MouseY)
				{
					Cursor = Root.HandCursor;
					OverURL(CurrentStyle.LinkDestination);

					if(bMouseDown || bReleased)
					{
						if(bReleased)
						{
							ProcessURL(CurrentStyle.LinkDestination);
							bReleased = False;
						}
						else
							C.DrawColor = ALinkColor;
					}
				}
			}

			if(CurrentStyle.BGColor != BGColor)
			{	
				OldColor = C.DrawColor;
				C.DrawColor = CurrentStyle.BGColor;
				DrawStretchedTexture(C, X, Y, W, H, Texture'WhiteTexture');
				C.DrawColor = OldColor;
			}
			if(!CurrentStyle.bBlink || bShowBlink)
				TextAreaClipText(C, X, Y, S);
			if(CurrentStyle.bLink || CurrentStyle.bUnderline)
				DrawStretchedTexture(C, X, Y+H-1, W, 1, Texture'WhiteTexture');

			X += W;
		}
	}
	if(RowHeight == 0)
		TextAreaTextSize(C, "A", W, RowHeight);

	return RowHeight;
}

function UWindowDynamicTextRow SplitRowAt(UWindowDynamicTextRow L, int SplitPos)
{
	local UWindowDynamicTextRow N;
	local HTMLStyle CurrentStyle;

	N = Super.SplitRowAt(L, SplitPos);

	// update the style by processing from the start of L to the split position.
	UWindowHTMLTextRow(N).EndStyle = UWindowHTMLTextRow(L).EndStyle;
	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;
	HTMLUpdateStyle(L.Text, CurrentStyle);
	UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
	UWindowHTMLTextRow(N).StartStyle = CurrentStyle;

	return N;
}

function RemoveWrap(UWindowDynamicTextRow L)
{
	local UWindowDynamicTextRow N;

	// copy final endstyle to current row
	N = UWindowDynamicTextRow(L.Next);
	while(N != None && N.WrapParent == L)
	{
		UWindowHTMLTextRow(L).EndStyle = UWindowHTMLTextRow(N).EndStyle;
		N = UWindowDynamicTextRow(N.Next);
	}

	Super.RemoveWrap(L);
}

function int GetWrapPos(Canvas C, UWindowDynamicTextRow L, float MaxWidth)
{
	local float W, LineWidth, NextWordWidth;
	local string Input, NextWord;
	local int WordsThisRow, WrapPos;
	local HTMLStyle CurrentStyle;

	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;

	// quick check
	if(CalcHTMLTextWidth(C, L.Text, CurrentStyle) <= MaxWidth)
		return -1;

	Input = L.Text;
	WordsThisRow = 0;
	LineWidth = 0;
	WrapPos = 0;
	NextWord = "";
	CurrentStyle = UWindowHTMLTextRow(L).StartStyle;

	while(Input != "" || NextWord != "")
	{
		if(NextWord == "")
		{
			RemoveNextWord(Input, NextWord);
			NextWordWidth = CalcHTMLTextWidth(C, NextWord, CurrentStyle);
		}
		if(WordsThisRow > 0 && LineWidth + NextWordWidth > MaxWidth)
		{
			return WrapPos;
		}
		else
		{
			WrapPos += Len(NextWord);
			LineWidth += NextWordWidth;
			NextWord = "";
			WordsThisRow++;
		}
	}
	return -1;
}

// Find the next word - but don't split up HTML tags.
function RemoveNextWord(out string Text, out string NextWord)
{
	local int i;
	local bool bInsideTag;
	local string Ch;
	
	bInsideTag = False;

	for(i=0;i<Len(Text);i++)
	{
		Ch = Mid(Text, i, 1);
		if(Ch == ">")
			bInsideTag = False;
		if(Ch == "<")
			bInsideTag = True;
		if(Ch == " " && !bInsideTag)
			break;
	}
	while(Mid(Text, i, 1) == " ")
		i++;	
	NextWord = Left(Text, i);
	Text = Mid(Text, i);
}

function UWindowDynamicTextRow AddText(string NewLine)
{
	local string Input, Output, LeftText, RightText, HTML, Temp;
	local int i;
	local UWindowDynamicTextRow L;
	local HTMLStyle CurrentStyle, StartStyle;

	if(List.Last == List)
	{
		CurrentStyle.BulletLevel = 0;
		CurrentStyle.LinkDestination = "";
		CurrentStyle.TextColor = TextColor;
		CurrentStyle.BGColor = BGColor;
		CurrentStyle.bCenter = bHCenter;
		CurrentStyle.bLink = False;
		CurrentStyle.bUnderline = False;
		CurrentStyle.bNoBR = False;
		CurrentStyle.bHeading = False;
		CurrentStyle.bBold = False;
		CurrentStyle.bBlink = False;
	}
	else
		CurrentStyle = UWindowHTMLTextRow(List.Last).EndStyle;
	StartStyle = CurrentStyle;

	// convert \\n's -> <br>'s
	i = InStr(NewLine, "\\n");
	while(i != -1)
	{
		NewLine = Left(NewLine, i) $ "<br>" $ Mid(NewLine, i + 2);
		i = InStr(NewLine, "\\n");
	}

	Input = NewLine;
	Output = "";
	while(Input != "")
	{
		ParseHTML(Input, LeftText, HTML, RightText);
		
		switch(GetTag(HTML))
		{
		// multiline HTML tags
		case "P":
			if((Output $ LeftText) != "")
			{
				L = Super.AddText(Output $ LeftText);
				Output = "";
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			}
			StartStyle = CurrentStyle;
			L = Super.AddText("");
			UWindowHTMLTextRow(L).StartStyle = StartStyle;
			UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			break;
		case "BR":
			L = Super.AddText(Output $ LeftText);
			Output = "";
			UWindowHTMLTextRow(L).StartStyle = StartStyle;
			UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			StartStyle = CurrentStyle;
			break;
		case "BODY":
			Temp = GetOption(HTML, "BGCOLOR=");
			if(Temp != "")
			{
				BGColor = ParseColor(Temp);
				CurrentStyle.BGColor = BGColor;
				StartStyle.BGColor = BGColor;
			}

			Temp = GetOption(HTML, "LINK=");
			if(Temp != "")
				LinkColor = ParseColor(Temp);

			Temp = GetOption(HTML, "ALINK=");
			if(Temp != "")
				ALinkColor = ParseColor(Temp);

			Temp = GetOption(HTML, "TEXT=");
			if(Temp != "")
			{
				TextColor = ParseColor(Temp);
				CurrentStyle.TextColor = TextColor;
			}
			Output = Output $ LeftText;
			break;
		case "CENTER":
			if((Output $ LeftText) != "")
			{
				L = Super.AddText(Output $ LeftText);
				Output = "";
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			}
			CurrentStyle.bCenter = True;
			StartStyle = CurrentStyle;
			break;
		case "/CENTER":
			L = Super.AddText(Output $ LeftText);
			Output = "";
			UWindowHTMLTextRow(L).StartStyle = StartStyle;
			UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			CurrentStyle.bCenter = False;
			StartStyle = CurrentStyle;
			break;			
		// Inline HTML tags
		case "H1":
			if((Output $ LeftText) != "")
			{
				L = Super.AddText(Output $ LeftText);
				Output = "";
				UWindowHTMLTextRow(L).StartStyle = StartStyle;
				UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			}
			CurrentStyle.bHeading = True;
			StartStyle = CurrentStyle;
			break;
		case "/H1":
			L = Super.AddText(Output $ LeftText);
			Output = "";
			UWindowHTMLTextRow(L).StartStyle = StartStyle;
			UWindowHTMLTextRow(L).EndStyle = CurrentStyle;
			CurrentStyle.bHeading = False;
			StartStyle = CurrentStyle;
			break;			
		case "FONT":
			Output = Output $ LeftText $ HTML;
			Temp = GetOption(HTML, "COLOR=");
			if(Temp != "")
				CurrentStyle.TextColor = ParseColor(Temp);
			Temp = GetOption(HTML, "BGCOLOR=");
			if(Temp != "")
				CurrentStyle.BGColor = ParseColor(Temp);
			break;
		case "/FONT":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.TextColor = TextColor;
			CurrentStyle.BGColor = BGColor;
			break;
		case "B":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bBold = True;
			break;
		case "/B":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bBold = False;
			break;
		case "U":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bUnderline = True;
			break;
		case "/U":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bUnderline = False;
			break;
		case "A":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bLink = True;
			CurrentStyle.LinkDestination = GetOption(HTML, "HREF=");
			break;
		case "/A":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bLink = False;
			CurrentStyle.LinkDestination = "";
			break;
		case "NOBR":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bNoBR = True;
			break;
		case "/NOBR":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bNoBR = False;
			break;
		case "BLINK":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bBlink = True;
			break;
		case "/BLINK":
			Output = Output $ LeftText $ HTML;
			CurrentStyle.bBlink = False;
			break;
		default:
			Output = Output $ LeftText;
			break;
		}
		Input = RightText;
	}

	L = Super.AddText(Output);
	UWindowHTMLTextRow(L).StartStyle = StartStyle;
	UWindowHTMLTextRow(L).EndStyle = CurrentStyle;

	return L;
}

///////////////////////////////////////////////////
// HTML Text Processing
///////////////////////////////////////////////////

// Get the next HTML tag, the text before it and everthing after it.
function ParseHTML(string Input, out string LeftText, out string HTML, out string RightText)
{
	local int i;
	
	i = InStr(Input, "<");
	if(i == -1)
	{
		LeftText = Input;
		HTML = "";
		RightText = "";
		return;
	}

	LeftText = Left(Input, i);
	HTML = Mid(Input, i);

	i = InStr(HTML, ">");
	if(i == -1)
	{
		RightText = "";
		return;
	}

	RightText = Mid(HTML, i+1);
	HTML = Left(HTML, i+1);	
}

function float CalcHTMLTextWidth(Canvas C, string Text, out HTMLStyle CurrentStyle)
{
	local string Input, LeftText, HTML, RightText;
	local float W, H, Width;

	Width = 0;
	Input = Text;
	while(Input != "")
	{
		ParseHTML(Input, LeftText, HTML, RightText);

		SetCanvasStyle(C, CurrentStyle);
		TextAreaTextSize(C, LeftText, W, H);
		Width += W;
					
		ProcessInlineHTML(HTML, CurrentStyle);

		Input = RightText;
	}

	return Width;
}

// Update CurrentStyle based on the contents of the HTML tag provided
function ProcessInlineHTML(string HTML, out HTMLStyle CurrentStyle)
{
	local string Temp;

	if(HTML == "")	
		return;

	switch(GetTag(HTML))
	{
	case "H1":
		CurrentStyle.bHeading = True;
		break;
	case "/H1":
		CurrentStyle.bHeading = False;
		break;			
	case "FONT":
		Temp = GetOption(HTML, "COLOR=");
		if(Temp != "")
			CurrentStyle.TextColor = ParseColor(Temp);
		Temp = GetOption(HTML, "BGCOLOR=");
		if(Temp != "")
			CurrentStyle.BGColor = ParseColor(Temp);
		break;
	case "/FONT":
		CurrentStyle.TextColor = TextColor;
		CurrentStyle.BGColor = BGColor;
		break;
	case "B":
		CurrentStyle.bBold = True;
		break;
	case "/B":
		CurrentStyle.bBold = False;
		break;
	case "U":
		CurrentStyle.bUnderline = True;
		break;
	case "/U":
		CurrentStyle.bUnderline = False;
		break;
	case "A":
		CurrentStyle.bLink = True;
		CurrentStyle.LinkDestination = GetOption(HTML, "HREF=");
		break;
	case "/A":
		CurrentStyle.bLink = False;
		CurrentStyle.LinkDestination = "";
		break;
	case "NOBR":
		CurrentStyle.bNoBR = True;
		break;
	case "/NOBR":
		CurrentStyle.bNoBR = False;
		break;
	case "BLINK":
		CurrentStyle.bBlink = True;
		break;
	case "/BLINK":
		CurrentStyle.bBlink = False;
		break;
	}
}

// update the current style based on some text input
function HTMLUpdateStyle(string Input, out HTMLStyle CurrentStyle)
{
	local string LeftText, HTML, RightText; 

	while(Input != "")
	{
		ParseHTML(Input, LeftText, HTML, RightText);
		ProcessInlineHTML(HTML, CurrentStyle);
		Input = RightText;
	}
}

function string GetOption(string HTML, string Option)
{
	local int i, j;
	local string s;
	
	i = InStr(Caps(HTML), Caps(Option));

	if(i == 1 || Mid(HTML, i-1, 1) == " ") 
	{
		s = Mid(HTML, i+Len(Option));
		j = FirstMatching(InStr(s, ">"), InStr(s, " "));
		s = Left(s, j);

		if(Left(s, 1) == "\"")
			s = Mid(s, 1);

		if(Right(s, 1) == "\"")
			s = Left(s, Len(s) - 1);

		return s;
	}
	return "";
}

function string GetTag(string HTML)
{
	local int i;

	if(HTML == "")
		return "";

	HTML = Mid(HTML, 1); // lose <

	i = FirstMatching(InStr(HTML, ">"), InStr(HTML, " "));
	if(i == -1)
		return Caps(HTML);
	else
		return Caps(Left(HTML, i));
}

function Color ParseColor(string S)
{
	local Color C;

	if(Left(S, 1) == "#")
		S = Mid(S, 1);

	C.R = 16 * GetHexDigit(Mid(S, 0, 1)) + GetHexDigit(Mid(S, 1, 1));
	C.G = 16 * GetHexDigit(Mid(S, 2, 1)) + GetHexDigit(Mid(S, 3, 1));
	C.B = 16 * GetHexDigit(Mid(S, 4, 1)) + GetHexDigit(Mid(S, 5, 1));

	return C;
}

function int GetHexDigit(string D)
{
	switch(caps(D))
	{
	case "0": return 0;
	case "1": return 1;
	case "2": return 2;
	case "3": return 3;
	case "4": return 4;
	case "5": return 5; 
	case "6": return 6; 
	case "7": return 7; 
	case "8": return 8; 
	case "9": return 9; 
	case "A": return 10; 
	case "B": return 11; 
	case "C": return 12; 
	case "D": return 13; 
	case "E": return 14; 
	case "F": return 15; 
	}

	return 0;
}

function int FirstMatching(int i, int j)
{
	if(i == -1)
		return j;

	if(j == -1)
		return i;
	else
		return Min(i, j);
}

function SetCanvasStyle(Canvas C, HTMLStyle CurrentStyle)
{
	if(CurrentStyle.bLink)
		C.DrawColor = LinkColor;
	else
		C.DrawColor = CurrentStyle.TextColor;

	if(CurrentStyle.bHeading)
		C.Font = Root.Fonts[F_LargeBold];
	else
	if(CurrentStyle.bBold)
		C.Font = Root.Fonts[F_Bold];
	else
		C.Font = Root.Fonts[F_Normal];
}

function string WriteStyleText(HTMLStyle CurrentStyle, int CharCount)
{
	local string Pad;
	local string Temp;
	local string Output;

	Pad = "0000";

	Temp = string(CharCount);
	Output = Left(Pad, 4 - Len(Temp)) $ Temp;
		
	Temp = string(Len(CurrentStyle.LinkDestination));
	Output = Output $ Left(Pad, 4 - Len(Temp)) $ Temp $ CurrentStyle.LinkDestination;

	Temp = string(CurrentStyle.TextColor.R);
	Output = Output $ Left(Pad, 3 - Len(Temp)) $ Temp;
	Temp = string(CurrentStyle.TextColor.G);
	Output = Output $ Left(Pad, 3 - Len(Temp)) $ Temp;
	Temp = string(CurrentStyle.TextColor.B);
	Output = Output $ Left(Pad, 3 - Len(Temp)) $ Temp;

	Temp = string(CurrentStyle.BGColor.R);
	Output = Output $ Left(Pad, 3 - Len(Temp)) $ Temp;
	Temp = string(CurrentStyle.BGColor.G);
	Output = Output $ Left(Pad, 3 - Len(Temp)) $ Temp;
	Temp = string(CurrentStyle.BGColor.B);
	Output = Output $ Left(Pad, 3 - Len(Temp)) $ Temp;

	if(CurrentStyle.bCenter)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	if(CurrentStyle.bLink)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	if(CurrentStyle.bUnderline)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	if(CurrentStyle.bNoBR)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	if(CurrentStyle.bHeading)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	if(CurrentStyle.bBold)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	if(CurrentStyle.bBlink)
		Output = Output $ "T";
	else
		Output = Output $ "F";

	return Output;
}

function int ReadStyleText(string StyleString, out int StylePos, out HTMLStyle CurrentStyle)
{
	local string Temp;
	local int CharCount;
	local int i;	

	CharCount = Int(Mid(StyleString, StylePos, 4));
	StylePos += 4;

	i = Int(Mid(StyleString, StylePos, 4));
	StylePos += 4;
		
	CurrentStyle.LinkDestination = Mid(StyleString, StylePos, i);
	StylePos += i;

	CurrentStyle.TextColor.R = Int(Mid(StyleString, StylePos, 3));
	StylePos += 3;
	CurrentStyle.TextColor.G = Int(Mid(StyleString, StylePos, 3));
	StylePos += 3;
	CurrentStyle.TextColor.B = Int(Mid(StyleString, StylePos, 3));
	StylePos += 3;

	CurrentStyle.BGColor.R = Int(Mid(StyleString, StylePos, 3));
	StylePos += 3;
	CurrentStyle.BGColor.G = Int(Mid(StyleString, StylePos, 3));
	StylePos += 3;
	CurrentStyle.BGColor.B = Int(Mid(StyleString, StylePos, 3));
	StylePos += 3;

	CurrentStyle.bCenter = Mid(StyleString, StylePos++, 1) == "T";
	CurrentStyle.bLink = Mid(StyleString, StylePos++, 1) == "T";
	CurrentStyle.bUnderline = Mid(StyleString, StylePos++, 1) == "T";
	CurrentStyle.bNoBR = Mid(StyleString, StylePos++, 1) == "T";
	CurrentStyle.bHeading = Mid(StyleString, StylePos++, 1) == "T";
	CurrentStyle.bBold = Mid(StyleString, StylePos++, 1) == "T";
	CurrentStyle.bBlink = Mid(StyleString, StylePos++, 1) == "T";

	return CharCount;
}

defaultproperties
{
    TextColor=(R=255,G=255,B=255,A=255)
    BGColor=(R=0,G=0,B=0,A=255)
    LinkColor=(R=0,G=0,B=255,A=255)
    ALinkColor=(R=255,G=0,B=0,A=255)
    bTopCentric=true
    bAutoScrollbar=true
    bVariableRowHeight=true
    RowClass=Class'UWindowHTMLTextRow'
    bIgnoreLDoubleClick=true
}