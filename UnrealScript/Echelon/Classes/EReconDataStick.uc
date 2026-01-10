class EReconDataStick extends ERecon native;

// stuff from needed to construct the text
var string ObjName;
var string MemoryTextSection;
var string From;
var string To;
var string SentStringID;
var string SubjectStringID;
var string MemoryTextID;

function ReplaceMemoryText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while (i != -1)
	{
		Text = Text $ Left(Input, i) $ With;
		Input = Mid(Input, i + Len(Replace));
		i = InStr(Input, Replace);
	}
	Text = Text $ Input;
}

function MakeText(string sObjName,
					string sMemoryTextSection,
					string sFrom,
					string sTo,
					string sSentStringID,
					string sSubjectStringID,
					string sMemoryTextID)
{
    local int i;

	ObjName           = sObjName;
	MemoryTextSection = sMemoryTextSection;
	From              = sFrom;
	To                = sTo;
	SentStringID      = sSentStringID;
	SubjectStringID   = sSubjectStringID;
	MemoryTextID      = sMemoryTextID;

	ReconName = "DataStick";
	ReconPreviewText = "DataStick";

    // BUILD HEADER //
    ReconText =				Localize("HUD", "From", "Localization\\HUD")    @ From    $ "\\n";
    ReconText = ReconText $ Localize("HUD", "To", "Localization\\HUD")      @ To      $ "\\n";
    ReconText = ReconText $ Localize("HUD", "Sent", "Localization\\HUD")    @ Localize(MemoryTextSection, SentStringID, "Localization\\MemoryStick") $ "\\n";
    ReconText = ReconText $ Localize("HUD", "Subject", "Localization\\HUD") @ Localize(MemoryTextSection, SubjectStringID, "Localization\\MemoryStick") $ "\\n\\n";

    // Main text //
    ReconText = ReconText $ Localize(MemoryTextSection, MemoryTextID, "Localization\\MemoryStick");

    ReplaceMemoryText(ReconText, "\\n", Chr(10));
}

defaultproperties
{
    ReconType=5
}