class UWindowPageControlPage extends UWindowTabControlItem;

var UWindowPageWindow	Page;

function RightClickTab()
{
	Page.RightClickTab();
}

function UWindowPageControlPage NextPage()
{
	return UWindowPageControlPage(Next);
}
