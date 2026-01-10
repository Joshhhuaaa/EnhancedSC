//=============================================================================
//  EPCComboEditBox.uc : EditBox that passes through mouse wheel to parent
//  Used by EPCComboControl to allow page scrolling when combo is closed
//=============================================================================
class EPCComboEditBox extends UWindowEditBox;

// Override mouse wheel to pass through to parent when not editable
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	// If we can edit, handle it normally
	if (bCanEdit)
	{
		Super.MouseWheelDown(X, Y);
		return;
	}

	// Otherwise, pass to parent so the page can scroll
	if (ParentWindow != None)
		ParentWindow.MouseWheelDown(X, Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
	// If we can edit, handle it normally
	if (bCanEdit)
	{
		Super.MouseWheelUp(X, Y);
		return;
	}

	// Otherwise, pass to parent so the page can scroll
	if (ParentWindow != None)
		ParentWindow.MouseWheelUp(X, Y);
}

defaultproperties
{
}
