class EAbstractGoggle extends EInventoryItem
	abstract
	notplaceable;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

var int RendType;

state s_Inventory
{
	function EndState()
	{
		Super.EndState();
		bHidden = true;
	}
}

defaultproperties
{
    Category=CAT_GADGETS
    bEquipable=false
    StaticMesh=none
}