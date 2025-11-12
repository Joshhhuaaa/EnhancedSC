class UWindowWrappedTextArea extends UWindowTextAreaControl
                    native;


function BeforePaint(Canvas C, float X, float Y)
{
    if (m_bWrapClipText)
    {
        m_bWrapClipText = false; // reset on clear() method only
        NewAddText(C); // we just add a fct to not allocate 3 array of szTextArraySize each time before paint was processed
    }
}


function Paint(Canvas C, float X, float Y)
{
	local FLOAT XL, YL;
	local INT   i,                // index
                j,                // index
                AddLine;          // the number of line to add depending the offset
    local bool  bUseAreaFont;     // Use the area font for display
	
    // if no lines add in TextArea...
    //log("Lines: "$Lines);
	if (Lines == 0)
		return;    

    // to verify
    bUseAreaFont = false;
   	if (AbsoluteFont != None)
    {
		C.Font = AbsoluteFont; // this is set in UWindowTextAreaControl
    }
    else
    {
        if (TextFontArea[0] != None)
        {
            bUseAreaFont = true;
            C.Font = TextFontArea[0];
        }
        else
        {
            C.Font = AbsoluteFont;
        }
    }

    // in the case of textareafont array, the empty line offset is relative (depending of all the textareafont choice)
	TextSize(C, "TEST", XL, YL); 

    // add some lines depending the initial offset 
    AddLine = m_fYOffSet / YL;
    AddLine += 1;     // give a one line of security to avoid cut line at the end
    AddLine += Lines; // add original total lines -- real total lines now

    //Calculate the visible rows
	VisibleRows = WinHeight / YL;

    i = 0;

	if (bScrollable)
	{
        //why substract 1, because the last line (depending of the offset will be cut by 
		VertSB.SetRange(0, AddLine, VisibleRows, 0);//VisibleRows - 1, 0); 
        // assign the pos of Scrollbar to index
        i = VertSB.Pos;
	}


    for (j = 0; j < VisibleRows && i + j < Lines; j++)
    {
        C.SetDrawColor(TextColorArea[i + j].R,TextColorArea[i + j].G,TextColorArea[i + j].B);

        if (bUseAreaFont) //&& (i + j < Lines)) // the last condition is to prevent the empty add line at the end
            C.Font = TextFontArea[i + j];

        //in fact the text is already clip, but for use some code of clip text fct, we use it anyway
        ClipText(C, m_fXOffSet, m_fYOffSet + (YL * j), TextArea[i + j]);   
    }

    if (i + j > Lines)
    {
        for (j = 0; j < AddLine; j++)
        {
            ClipText(C, m_fXOffSet, m_fYOffSet + (YL * j), "");
        }
    }

    
    if (bDrawBorder)
        DrawSimpleBorder(C);
}

// INTERN FONCTION FOR THIS CLASS ONLY, see before paint comment
function NewAddText(Canvas C)
{
    local INT i, iTempLines;
    local Font   TempTextFontArea[szTextArraySize];
    local color  TempTextColorArea[szTextArraySize];
    local string TempTextArea[szTextArraySize]; 

    if (Lines == 0)
    	return;

    // do a copy to not overwrite the original add text
    for (i = 0; i < Lines; i++)
    {
        TempTextFontArea[i] = TextFontArea[i];    
        TempTextColorArea[i] = TextColorArea[i];
        TempTextArea[i] = TextArea[i];
    }

    iTempLines = Lines;
    Clear(true); // array only

    for (i = 0; i < iTempLines; i++)
    {
        AddTextWithCanvas(C, m_fXOffSet, m_fYOffSet, TempTextArea[i], TempTextFontArea[i], TempTextColorArea[i]);
    }
}
