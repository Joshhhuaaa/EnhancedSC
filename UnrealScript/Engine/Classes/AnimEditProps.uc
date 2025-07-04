//=============================================================================
// Object to facilitate properties editing
//=============================================================================
//  Animation / Mesh editor object to expose/shuttle only selected editable 
//  parameters from UMeshAnim/ UMesh objects back and forth in the editor.
//  

class AnimEditProps extends Object
	noexport
	hidecategories(Object)
	native;	

var(Compression) float   GlobalCompression;
var(Compression) float   MaxAngleError;
var(Compression) float   MaxPosError;

defaultproperties
{
    GlobalCompression=1.000000
    MaxAngleError=0.002500
    MaxPosError=0.010000
}