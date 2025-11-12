class UWindowComboListItem extends UWindowList;

var string					Value;
var string					Value2;		// A second, non-displayed value
var int						SortWeight;

var float					ItemTop;

function int Compare(UWindowList T, UWindowList B)
{
	local UWindowComboListItem TI, BI;
	local string TS, BS;

	TI = UWindowComboListItem(T);
	BI = UWindowComboListItem(B);

	if (TI.SortWeight == BI.SortWeight)
	{
		TS = caps(TI.Value);
		BS = caps(BI.Value);

		if (TS == BS)
			return 0;

		if (TS < BS)
			return -1;

		return 1;

	}
	else
		return TI.SortWeight - BI.SortWeight;
}
