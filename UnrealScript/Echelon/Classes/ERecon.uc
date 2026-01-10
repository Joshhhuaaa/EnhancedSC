class ERecon extends Object native;

/*
enum eReconType
{
	eRT_FullScreen,
	eRT_Map,
	eRT_SplitScreen,
	eRT_Text
};
*/

struct sReconPos
{
	var String RoomDesc;
    var int x;
    var int y;
};

var int ReconType; // 1- Full screen
				   // 2- Map
				   // 3- Split screen
                   // 4- Text
				   // 5- Data Stick

var String	  ReconName;           // Name in the list
var Texture	  ReconPicName;        // Picture name (preview & full)
var String    ReconPreviewText;    // Preview text displayed under the preview picture
var String	  ReconText;		   // Full text description
var array<sReconPos> ReconDynMapArray;
var int       NbrOfCoord;          // if a map type, nbr of coord
var bool      bIsRead;             // false if never looked


function InitRecon();


