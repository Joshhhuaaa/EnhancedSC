//=============================================================================
// MapList.
//
// contains a list of maps to cycle through
//
//=============================================================================
class MapList extends Info;

var(Maps) config string Maps[32];
var config int MapNum;

function string GetNextMap()
{
	return "";
}
