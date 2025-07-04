//=============================================================================
// Object to facilitate properties editing
//=============================================================================
//  Sequence / Mesh editor object to expose/shuttle only selected editable 
//  

class SequEditProps extends Object
	noexport
	hidecategories(Object)
	native;	

var() float             NewRate;
var() float             NewCompression;
var(Name) name          NewSeqName;


