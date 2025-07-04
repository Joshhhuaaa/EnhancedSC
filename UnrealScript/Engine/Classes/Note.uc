//=============================================================================
// A sticky note.  Level designers can place these in the level and then
// view them as a batch in the error/warnings window.
//=============================================================================
class Note extends Actor
	placeable
	native;

#exec Texture Import File=Textures\Note.pcx  Name=S_Note Mips=Off MASKED=1 NOCONSOLE

var() string Text;

defaultproperties
{
    bStatic=true
    bHidden=true
    bNoDelete=true
    Texture=Texture'S_Note'
    bMovable=false
}