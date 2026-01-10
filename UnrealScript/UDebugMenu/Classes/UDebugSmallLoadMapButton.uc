// ====================================================================
//  Class:  UDebugMenu.UDebugSmallLoadMapButton
//  Parent: UWindow.UWindowSmallOKButton
//
//  <Enter a description here>
// ====================================================================

class UDebugSmallLoadMapButton extends UWindowSmallOKButton;

function Created()
{
	Super.Created();
	SetText("Load Map");
}

function Click(float X, float Y)
{
	local string MapName,NetworkName, URL;
	local UDebugMapListCW CW;
	local UDebugMapListWindow LW;

	LW = UDebugMapListWindow(GetParent(class'UDebugMapListWindow'));
	CW = UDEbugMapListCW(LW.ClientArea);

	if (CW != None)
	{
		if (CW.MapList.SelectedItem == None)
		{
			return;
		}

		URL = ""$UDebugMapList(CW.MapList.SelectedItem).MapName$"?Game="$CW.GameCombo.GetValue();
		NetworkName = CW.NetworkCombo.GetValue();
		Root.GotoState('');
		if (NetworkName=="Listen Server")
        {
            //Alex Root.Master.Travel(""$URL$"?Listen");
            Root.Console.Master.Travel(""$URL$"?Listen");
        }
		else
        {
            //Root.Master.Travel(URL);
            Root.Console.Master.Travel(URL);
        }

	}

	Super.Click(x,y);
}


