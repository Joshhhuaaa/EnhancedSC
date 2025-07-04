//=============================================================================
// Subsystem: The base class all subsystems. Subsystems usually
// correspond to large C++ classes. The benefit of defining a C++ class as
// a subsystem is that you can make some of its variables script-accessible,
// and you can make some of its properties automatically saveable as part
// of the configuration.
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Subsystem extends Object
	native
	noexport;

// Internal.
var private native const int ExecVtbl;

