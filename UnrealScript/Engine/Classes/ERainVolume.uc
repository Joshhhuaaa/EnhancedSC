class ERainVolume extends Actor 
	noexport
	native
	placeable;
   


var(RainVolume) Float			m_RainThickness;
var(RainVolume) ERainMaterial	m_RainMaterial;

var(RainVolume) Float			m_RainMatScale;
var(RainVolume) Vector			m_RainSize;
var(RainVolume) Float			m_RainFalloff;
var(RainVolume) Float			m_RainFadeScale;
var(RainVolume) Float			m_DistanceToCamera;




var native const ERainPrimitive		m_pPrimitive;
var native const Box				m_RainVolume;


//final native(3030) function Bool IsPointInside(Vector _position);
//final native(3032) function Bool IsBoxInside(Vector _min, Vector _max);
//final native(3034) function Bool IsSphereInside(Vector _position, float radius);

defaultproperties
{
    m_RainThickness=80.000000
    m_RainMatScale=35.000000
    m_RainSize=(X=250.000000,Y=250.000000,Z=450.000000)
    m_RainFadeScale=1.000000
    m_DistanceToCamera=80.000000
    DrawType=DT_Rain
}