class EOpticCableView extends EObjectHUD;

state s_Sneaking
{
	function DrawView(HUD hud, ECanvas Canvas)
	{
		if ((EchelonGameInfo(Level.Game).pPlayer).bShowScope && EchelonGameInfo(Level.Game).pPlayer.bShowHUD) // Joshua - Show scope toggle
			DrawSniperMask(Canvas);
	}
}