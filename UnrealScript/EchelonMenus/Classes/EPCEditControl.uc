class EPCEditControl extends UWindowEditControl
				native;

function Paint(Canvas C, float X, float Y)
{
	Render(C, X, Y);
}

function BeforePaint(Canvas C, float X, float Y){}

// Joshua - Move caret to end of text
function MoveCaretToEnd()
{
    if (EditBox != None)
        EditBox.CaretOffset = Len(EditBox.Value);
}

// Joshua - Select all text
function SelectAll()
{
    if (EditBox != None)
        EditBox.SelectAll();
}
