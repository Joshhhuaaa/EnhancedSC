class UWindowProgressBar extends UWindowWindow;

var float Percent;
const BlockWidth=7;

function SetPercent(float NewPercent)
{
	Percent = NewPercent;
}

function Paint(Canvas C, float X, float Y)
{
	local float BlockX, BlockW;

	DrawMiscBevel( C, 0, 0, WinWidth, WinHeight, LookAndFeel.Misc, 2 );

	C.SetDrawColor(192,192,192);

	DrawStretchedTextureSegment(
							C, 
							LookAndFeel.MiscBevelL[2].W,
							LookAndFeel.MiscBevelT[2].H, 
							WinWidth - LookAndFeel.MiscBevelL[2].W - LookAndFeel.MiscBevelR[2].W, 
							WinHeight - LookAndFeel.MiscBevelT[2].H - LookAndFeel.MiscBevelB[2].H, 
							0, 
							0, 
							1, 
							1, 
							Texture'WhiteTexture'
						);

	C.SetDrawColor(0,0,255);

	BlockX = LookAndFeel.MiscBevelL[2].W + 1;
	while( BlockX < 1 + LookAndFeel.MiscBevelL[2].W + Percent * (WinWidth - LookAndFeel.MiscBevelL[2].W - LookAndFeel.MiscBevelR[2].W - 2) / 100)
	{
		BlockW = Min(BlockWidth, WinWidth - LookAndFeel.MiscBevelR[2].W - BlockX - 1);
	


		DrawStretchedTextureSegment(
								C, 
								BlockX, 
								LookAndFeel.MiscBevelT[2].H + 1, 
								BlockW, 
								WinHeight - LookAndFeel.MiscBevelT[2].H - LookAndFeel.MiscBevelB[2].H - 1, 
								0, 
								0, 
								1, 
								1, 
								Texture'WhiteTexture'
							);

		BlockX += BlockWidth + 1;
	}

	C.SetDrawColor(255,255,255);
}
