//=============================================================================
// EchelonEnums
//		UC file kept in Engine package to store any enums we need to find
//		globally in the Echelon package.
//		
//		Enums must be referred to with class identifier, e.g.:
//			EchelonEnums.SOUND_SawSomething;
//
//		Easier than placing an enum in a base Actor class .. 
//		but I have no idea if there are performance issues.
//
//=============================================================================


class EchelonEnums extends Object
	native;



// GOAL enums ..

enum GoalStatus 
{
	GS_Executing, 
	GS_Complete, 
	GS_Failure,
	GS_Continue
};


enum GoalType
{
	GOAL_Guard,
	GOAL_Defend,
	GOAL_Patrol,					
	GOAL_Action,  				
	GOAL_MoveTo,					
	GOAL_Search,
	GOAL_Attack,
	GOAL_InteractWith,				
	GOAL_Transmission,
	GOAL_Wait,
	GOAL_Follow,
	GOAL_Attack_Follow,
	GOAL_Wander,
	GOAL_QuickSearch,
	GOAL_Charge,
	GOAL_MoveAndAttack,
	GOAL_Stop,
	GOAL_ThrowGrenade,
	GOAL_PlaceWallMine,
	GOAL_SprayFire,
	GOAL_TEMP_1,
	GOAL_TEMP_2,
	GOAL_TEMP_3,
	GOAL_TEMP_4
};

//AI stuff



// from Fred, for transmissions

enum eTransmissionType
{
	TR_NONE,
	TR_CONSOLE,
	TR_NPCS,
	TR_HEADQUARTER,
	TR_CONVERSATION,
    TR_INVENTORY,
    TR_HINT,
    TR_MENUSPEECH,
	TR_COMMWARNING
};

// FSchelling, for Secondary Viewport
enum eSVMode
{
	SV_CLOSE,
	SV_CONVERSATION,
	SV_KEYPAD,
	SV_CAMERA,
	SV_SNIPER,
	SV_IDLE
};

//AI Zones
enum eZoneType
{
	EZT_NONE,
	EZT_TABLE,
	EZT_CHAIR,
	EZT_PLANT,
	EZT_CORNER
};

//AI Sectors
enum eSectorType
{
	SC_NONE,
	SC_ELEVATOR,
	SC_KITCHEN,
	SC_STAIRCASE,
	SC_DEADEND,
	SC_BATHROOMS,
	SC_HALLWAY
};


enum eVocStart
{
	VS_NONE,
	VS_I_THINK,
	VS_I_KNOW
};

enum eVocSubject
{
	SU_NONE,
	SU_YOU_ARE,
	SU_HE_IS
};

enum eVocPosition
{
	PO_NONE,
	PO_BEHIND,
	PO_IN_FRONT_OF,
	PO_BESIDE,
	PO_IN,
	PO_RUNNING_OUT_OF,
	PO_RUNNING_IN
};

enum eKEY_BIND
{
    KEY_NONE,
    KEY_MOVE_UP,
    KEY_MOVE_DOWN,
    KEY_MOVE_LEFT,
    KEY_MOVE_RIGHT,
    KEY_LOOK_UP,
    KEY_LOOK_DOWN,    
    KEY_LOOK_LEFT,
    KEY_LOOK_RIGHT,
    KEY_INTERACTION,
    KEY_SCOPE,
    KEY_JUMP,
    KEY_DUCK,
    KEY_FIRE,
    KEY_ALT_FIRE,
    KEY_CHANGE_ROF,
    KEY_QUICK,
    KEY_MENU,
    KEY_RESETCAMERA,
	KEY_WORLDINTERACT,
	KEY_SWITCHROF,
	KEY_BACK,
};
