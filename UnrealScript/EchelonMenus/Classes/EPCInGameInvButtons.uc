//=============================================================================
//  EPCInGameInvButtons.uc : InGame Top Inventory Buttons
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/11 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameInvButtons extends UWindowButton
				native;

var Texture     m_BackGroundTexture;
var Bool        m_bInvertHorizontalCoord;
var Bool        m_bHideWhenDisabled;
var INT         m_CoordModifier;

function SetupTextures(INT _TextureId, ETextureManager _TM)
{

    UpRegion.X =	_TM.ArrayTexture[_TextureId].Origin.X;
    UpRegion.Y =	_TM.ArrayTexture[_TextureId].Origin.Y;
    UpRegion.W =	_TM.ArrayTexture[_TextureId].Size.X;
    UpRegion.H =	_TM.ArrayTexture[_TextureId].Size.Y;
    UpTexture  =	_TM.ArrayTexture[_TextureId].TextureOwner;

    DownRegion.X =	_TM.ArrayTexture[_TextureId].Origin.X;
    DownRegion.Y =	_TM.ArrayTexture[_TextureId].Origin.Y;
    DownRegion.W =	_TM.ArrayTexture[_TextureId].Size.X;
    DownRegion.H =	_TM.ArrayTexture[_TextureId].Size.Y;
    DownTexture  =  _TM.ArrayTexture[_TextureId].TextureOwner;

    OverRegion.X =	_TM.ArrayTexture[_TextureId].Origin.X;
    OverRegion.Y =	_TM.ArrayTexture[_TextureId].Origin.Y;
    OverRegion.W =	_TM.ArrayTexture[_TextureId].Size.X;
    OverRegion.H =	_TM.ArrayTexture[_TextureId].Size.Y;
    OverTexture  =  _TM.ArrayTexture[_TextureId].TextureOwner;

    DisabledRegion.X =	_TM.ArrayTexture[_TextureId].Origin.X;
    DisabledRegion.Y =	_TM.ArrayTexture[_TextureId].Origin.Y;
    DisabledRegion.W =	_TM.ArrayTexture[_TextureId].Size.X;
    DisabledRegion.H =	_TM.ArrayTexture[_TextureId].Size.Y;
    DisabledTexture  =  _TM.ArrayTexture[_TextureId].TextureOwner;


    ImageX = (WinWidth - UpRegion.W) /2;
    ImageY = (WinHeight - UpRegion.H) /2;

    if (m_bInvertHorizontalCoord)
    {
        UpRegion.X   += UpRegion.W;
        DownRegion.X += DownRegion.W;
        OverRegion.X += OverRegion.W;
        DisabledRegion.X += DisabledRegion.W;

        UpRegion.W   = UpRegion.W * -1;
        DownRegion.W = DownRegion.W * -1;
        OverRegion.W = OverRegion.W * -1;
        DisabledRegion.W = DisabledRegion.W * -1;

        m_CoordModifier= -1;

    }
}

function Paint(Canvas C, float X, float Y)
{

    if (m_bHideWhenDisabled && bDisabled)
        return;

    Render(C, X, Y);

    if (m_bDrawButtonBorders)
	{
		DrawSimpleBorder(C);
	}
}

defaultproperties
{
    m_BackGroundTexture=Texture'UWindow.WhiteTexture'
    m_CoordModifier=1
    bUseRegion=True
    m_BorderColor=(R=51,G=51,B=51,A=255)
}