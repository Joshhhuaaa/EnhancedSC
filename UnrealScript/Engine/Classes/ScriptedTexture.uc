//=============================================================================
// ScriptedTexture: A scriptable Unreal texture
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class ScriptedTexture extends Texture 
	//native noexport;
	safereplace;

// A SciptedTexture calls its Script's Render() method to draw to the texture at
// runtime
var Actor NotifyActor;
var() Texture SourceTexture;

var transient const int Junk1;	// C++ stuff
var transient const int Junk2;	// C++ stuff
var transient const int Junk3;	// C++ stuff
var transient const float LocalTime;	// C++ stuff


native(473) final function DrawTile( float X, float Y, float XL, float YL, float U, float V, float UL, float VL, Texture Tex, bool bMasked );
native(472) final function DrawText( float X, float Y, string Text, Font Font );
native(474) final function DrawColoredText( float X, float Y, string Text, Font Font, color FontColor );
native(475) final function ReplaceTexture( Texture Tex );
native(476) final function TextSize( string Text, out float XL, out float YL, Font Font );
