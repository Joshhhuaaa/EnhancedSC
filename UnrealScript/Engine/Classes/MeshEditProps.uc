//=============================================================================
// Object to facilitate properties editing
//=============================================================================
//  Animation / Mesh editor object to expose/shuttle only selected editable
//  parameters from UMeshAnim/ UMesh objects back and forth in the editor.
//

class MeshEditProps extends Object
	noexport
	hidecategories(Object)
	native;

// abstract, editinlinenew ?

var(Mesh) vector			 NewScale;
var(Mesh) vector             NewTranslation;
var(Mesh) rotator            NewRotation;
var(Mesh) vector             NewMinVisBound;
var(Mesh) vector			 NewMaxVisBound;
var(Redigest) int            NewLODStyle; //Make drop-down box w. styles...
var(Animation) MeshAnimation NewDefaultAnimation;

var(Skin) Material       Material0;
var(Skin) Material       Material1;
var(Skin) Material       Material2;
var(Skin) Material       Material3;
var(Skin) Material       Material4;
var(Skin) Material       Material5;
var(Skin) Material       Material6;
var(Skin) Material       Material7;
var(Skin) Material       Material8;
var(Skin) Material       Material9;

var(RenderOrder) int    MaterialOrder0;
var(RenderOrder) int    MaterialOrder1;
var(RenderOrder) int    MaterialOrder2;
var(RenderOrder) int    MaterialOrder3;
var(RenderOrder) int    MaterialOrder4;
var(RenderOrder) int    MaterialOrder5;
var(RenderOrder) int    MaterialOrder6;
var(RenderOrder) int    MaterialOrder7;
var(RenderOrder) int    MaterialOrder8;
var(RenderOrder) int    MaterialOrder9;

var(OriginalMaterial) name       OrigMat0;
var(OriginalMaterial) name       OrigMat1;
var(OriginalMaterial) name       OrigMat2;
var(OriginalMaterial) name       OrigMat3;
var(OriginalMaterial) name       OrigMat4;
var(OriginalMaterial) name       OrigMat5;
var(OriginalMaterial) name       OrigMat6;
var(OriginalMaterial) name       OrigMat7;
var(OriginalMaterial) name       OrigMat8;
var(OriginalMaterial) name       OrigMat9;

defaultproperties
{
    NewScale=(X=1.000000,Y=1.000000,Z=1.000000)
}