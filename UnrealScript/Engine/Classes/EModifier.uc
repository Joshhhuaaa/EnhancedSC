class EModifier extends Object
	native
	editinlinenew;

var() enum EModifierType
{
	MT_ENone,
	MT_EConcentricWaveX,
	MT_EConcentricWaveY,
	MT_EConcentricWaveZ
} ModifierType;

var() float
	Amplitude,
	Frequency,
	Wavelength,
	Decay;

var() vector
	ModifierOffset;

defaultproperties
{
    Amplitude=1.000000
    Frequency=1.000000
    Wavelength=1.000000
}