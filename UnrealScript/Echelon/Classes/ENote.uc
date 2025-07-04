class ENote extends Object native;

var String	Note;
var String	NoteShrink;
var bool	bCompleted;
var Name	ID;
var int     iPriority; // Goes from 1 to 25, 1 being most prioritary

// For localization
var string	Section;
var string	Key;
var string	Package;
var string	SectionShrink;
var string	KeyShrink;
var string	PackageShrink;

defaultproperties
{
    iPriority=25
}