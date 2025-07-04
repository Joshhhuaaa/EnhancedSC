class TexOscillator extends TexModifier
	editinlinenew
	native;

enum ETexOscillationType
{
	OT_Pan,
	OT_Stretch
};

var() Float UOscillationRate;
var() Float VOscillationRate;
var() Float UOscillationPhase;
var() Float VOscillationPhase;
var() Float UOscillationAmplitude;
var() Float VOscillationAmplitude;
var() ETexOscillationType UOscillationType;
var() ETexOscillationType VOscillationType;

var Matrix M;

defaultproperties
{
    UOscillationRate=1.000000
    VOscillationRate=1.000000
    UOscillationAmplitude=0.100000
    VOscillationAmplitude=0.100000
}