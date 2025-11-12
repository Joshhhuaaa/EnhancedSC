//=============================================================================
//  EPCInGameMenuMainButtons.uc : Button allowing menu section changes
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/05 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameMenuMainButtons extends UWindowButton
				native;

var Texture     m_BackGroundTexture;

function SetupTextures(INT _TextureId)
{
    
    UpRegion.X = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Origin.X;
    UpRegion.Y = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Origin.Y;
    UpRegion.W = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Size.X;
    UpRegion.H = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Size.Y;
    UpTexture  =  EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].TextureOwner;

    DownRegion.X = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Origin.X;
    DownRegion.Y = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Origin.Y;
    DownRegion.W = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Size.X;
    DownRegion.H = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Size.Y;
    DownTexture  =  EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].TextureOwner;

    OverRegion.X = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Origin.X;
    OverRegion.Y = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Origin.Y;
    OverRegion.W = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Size.X;
    OverRegion.H = EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].Size.Y;
    OverTexture  =  EchelonLevelInfo(GetLevel()).TICON.ArrayTexture[_TextureId].TextureOwner;

    ImageX = (WinWidth - UpRegion.W) /2;
    ImageY = (WinHeight - UpRegion.H) /2;
}

function Click(float X, float Y) 
{
	Super.Click(X, Y);
	Root.PlayClickSound();
}

defaultproperties
{
    m_BackGroundTexture=Texture'UWindow.WhiteTexture'
    bUseRegion=true
    m_bDrawButtonBorders=true
    m_BorderColor=(R=51,G=51,B=51,A=255)
}