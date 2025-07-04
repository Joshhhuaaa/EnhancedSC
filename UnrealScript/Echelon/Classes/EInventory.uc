////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Name: InteractObject
//
// Description: Basic object for interactions
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////

class EInventory extends Actor
	native;

struct InvItemInfo
{
	var Array<EInventoryItem>	Items;
};

var Array<InvItemInfo>	InventoryList;

var	EInventoryItem		BackPackPrimSelectedItem;	// MainGun or picked up weapons
var	EInventoryItem		BackPackSecSelectedItem;	// HandGun, devices, extras, etc ...

var EInventoryItem		PreviousEquipedItem;		// Any of the above

const NumberOfCat		= 3;

native(1210) final function AddInventoryItem( EInventoryItem Item );
native(1211) final function bool CanAddItem( EInventoryItem Item );
native(1212) final function RemoveItem( EInventoryItem Item, optional int Quantity, optional bool bRemoveAll );
native(1213) final function int GetNbItemInCategory( eInvCategory Category );
native(1214) final function EInventoryItem GetItemInCategory( eInvCategory Category, int ItemNumber );
native(1215) final function EInventoryItem GetItemByClass( Name ClassName );
native(1216) final function bool Possesses( EInventoryItem Item );

//------------------------------------------------------------------------
// Description		
//		Call this instead of calling GetSelected == item
//------------------------------------------------------------------------
event bool IsSelected( EInventoryItem Item )
{
	return Item == BackPackPrimSelectedItem || 
		   Item == BackPackSecSelectedItem;
}

//------------------------------------------------------------------------
// Description		
//		Use last selected item
//------------------------------------------------------------------------
function SetPreviousConfig()
{
	//Log("Use previous config * * * * * * * * * * *"@PreviousEquipedItem);
	if( PreviousEquipedItem != None )
	{
		if( EPawn(Owner).Controller.bIsPlayer && !EPlayerController(EPawn(Owner).Controller).CanSwitchToHandItem(PreviousEquipedItem) )
			return;

		//Log("... equiping"@PreviousEquipedItem);
		SetSelectedItem(PreviousEquipedItem);
	}
	else if( GetSelectedItem() != None )
	{
		// Sam specific
		if( !GetSelectedItem().IsA('EMainGun') )
		{
			//Log("... unequiping"@GetSelectedItem());
			UnEquipItem(GetSelectedItem());
		}
	}
}	

//------------------------------------------------------------------------
// Description		
//		Select the item in the right package
//------------------------------------------------------------------------
event SetSelectedItem( EInventoryItem Item )
{
	if( Item == None )
	{
		//Log(self$" WARNING: SetSelecteditem with Item = None");
		return;
	}
	else if( !Possesses(Item) )
	{
		Log(self$" WARNING: SetSelectedItem with Item not present "$Item);
		return;
	}

	//Log("SetSelectedItem"@Item);

	if( Item.IsA('EAbstractGoggle') )
	{
		if( EPawn(Owner).Controller.bIsPlayer )
			EPlayerController(EPawn(Owner).Controller).ChangeHeadObject(Item);
	}
	else if( !Item.IsA('ESecondaryAmmo') ) // primary
	{
		// UnEquip the current selected primary
		if( Item.bEquipable )
		{
			if( BackPackPrimSelectedItem != None && BackPackPrimSelectedItem != Item )
				UnEquipItem(BackPackPrimSelectedItem, true, Item);

			BackPackPrimSelectedItem = Item;
		}

		Item.Select(self);
		// It's possible that a pickup change handItem without changing selected item. Force Selected Item to be handItem
		if( EPawn(Owner).Controller.bIsPlayer && Item.bEquipable )
			EPlayerController(EPawn(Owner).Controller).ChangeHandObject(Item);
	}
	else
	{
		// UnEquip the current selected secondary
		if( BackPackSecSelectedItem != None )
			UnEquipItem(BackPackSecSelectedItem, false, Item);

		BackPackSecSelectedItem = Item;
		
		Item.Select(self);
	}
}

//------------------------------------------------------------------------
// Description		
//		Get the current selected item (hie never used i think)
//------------------------------------------------------------------------
function EInventoryItem GetSelectedItem( optional int hie )
{
	if( hie == 0 )
		return BackPackPrimSelectedItem;
	else
		return BackPackSecSelectedItem;
}

//------------------------------------------------------------------------
// Description		
//		Unequip the current selected item
//------------------------------------------------------------------------
event UnEquipItem( EInventoryItem Item, optional bool bNoUpdate, optional EInventoryItem NewItem )
{
	if ( Item == None ) 
		return;

	//Log("UnEquipItem"@Item@bNoUpdate@NewItem);

	// Keep last item equiped
	if( Item == None || NewItem == None || Item.class != NewItem.class )
	{
		//Log("BACKUPING"@Item);
		PreviousEquipedItem	= Item;
	}
	//else
	//	Log("NO BACKUP"@Item == None@NewItem == None@Item.class != NewItem.class);

	if( Item == BackPackPrimSelectedItem )
	{
		BackPackPrimSelectedItem.UnSelect(self);
		BackPackPrimSelectedItem = None;

		// send message handitem changed
		if( Owner != none && EPawn(Owner).Controller.bIsPlayer && !bNoUpdate )
			EPlayerController(EPawn(Owner).Controller).ChangeHandObject(None);
	}
	else if( Item == BackPackSecSelectedItem )
	{
		BackPackSecSelectedItem.UnSelect(self);
		BackPackSecSelectedItem = None;
	}
	else
	{
		Log("PROBLEM .. trying to unequip invalid item"@Item);
		return;
	}
}

//------------------------------------------------------------------------
// Description		
//		Viva le dynamisme et la flexibilite
//------------------------------------------------------------------------
event int GetNumberOfCategories()
{
	return NumberOfCat;
}
event string GetPackageName()
{	
	return Localize("HUD", "BACKPACK", "Localization\\HUD");
}
event string GetCategoryName(eInvCategory Category)
{
	switch( Category )
	{
		case CAT_MAINGUN: return Localize("HUD", "FN2000", "Localization\\HUD"); break;
		case CAT_GADGETS: return Localize("HUD", "GADGETS", "Localization\\HUD"); break;
		case CAT_ITEMS:  return Localize("HUD", "ITEMS", "Localization\\HUD");  break;
	}
}

defaultproperties
{
    bHidden=true
}