//=============================================================================
// UWindowListControl - Abstract class for list controls
//	- List boxes
//	- Dropdown Menus
//	- Combo Boxes, etc
//=============================================================================
class UWindowListControl extends UWindowDialogControl
            native;

var class<UWindowList>	ListClass;
var UWindowList			Items;
var Color				SelectionBkgColor;
var Color				SelectionColor;
var bool				bNoSelectionBox;

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	// Declared in Subclass
}

function Created()
{
	Super.Created();

	Items = New ListClass;
	Items.Last = Items;
	Items.Next = None;	
	Items.Prev = None;
	Items.Sentinel = Items;
}

defaultproperties
{
    SelectionBkgColor=(R=0,G=0,B=192,A=255)
    SelectionColor=(R=255,G=255,B=255,A=255)
}