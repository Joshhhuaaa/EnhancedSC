//=============================================================================
// PatrolPoint
//
// Used to define a patrol network by level designers.
// m_sNextPatrolPointTag is the variable that matches the next PatrolPoint Tag
// in the network.
//
// m_rSleepTime defines how long an NPC will stop at a given PatrolPoint
//
// PatrolPoint networks can either be circular or round-trip.
// If a network is defined as non-circular, the NPC will then
// traverse it in reverse.
//
//    EVERYTHING MOVED TO NAVIGATIONPOINT
//	  Functionality should be the same - keeping this class for legacy reasons.
//=============================================================================


class PatrolPoint extends NavigationPoint
    native
    notplaceable;
