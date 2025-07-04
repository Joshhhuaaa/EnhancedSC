//------------------------------------------------------------------------
//
// (C) Copyright 2001 Ubisoft
//
// Author		Alain Turcotte
// Date			11 avr. 2001
//
// File			EDeleteMe.uc
// Description  An instance of this in a map means that it replaced a non-valid or old class.
//				Remove instance and resave the map
//
//------------------------------------------------------------------------
class EDeleteMe extends Actor;

#exec TEXTURE IMPORT NAME=InvalidSign FILE=..\Engine\Textures\Echelon\delete.bmp Mips=Off NOCONSOLE

defaultproperties
{
    Texture=Texture'InvalidSign'
    DrawScale=0.300000
    Style=STY_Translucent
}