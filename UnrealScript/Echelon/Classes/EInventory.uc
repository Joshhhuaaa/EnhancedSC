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

native(1210) final function AddInventoryItem(EInventoryItem Item);
native(1211) final function bool CanAddItem(EInventoryItem Item);
native(1212) final function RemoveItem(EInventoryItem Item, optional int Quantity, optional bool bRemoveAll);
native(1213) final function int GetNbItemInCategory(eInvCategory Category);
native(1214) final function EInventoryItem GetItemInCategory(eInvCategory Category, int ItemNumber);
native(1215) final function EInventoryItem GetItemByClass(Name ClassName);
native(1216) final function bool Possesses(EInventoryItem Item);

//------------------------------------------------------------------------
// Description		
//		Call this instead of calling GetSelected == item
//------------------------------------------------------------------------
event bool IsSelected(EInventoryItem Item)
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
	if (PreviousEquipedItem != None)
	{
		if (EPawn(Owner).Controller.bIsPlayer && !EPlayerController(EPawn(Owner).Controller).CanSwitchToHandItem(PreviousEquipedItem))
			return;

		//Log("... equiping"@PreviousEquipedItem);
		SetSelectedItem(PreviousEquipedItem);
	}
	else if (GetSelectedItem() != None)
	{
		// Sam specific
		if (!GetSelectedItem().IsA('EMainGun'))
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
event SetSelectedItem(EInventoryItem Item)
{
	if (Item == None)
	{
		//Log(self$" WARNING: SetSelecteditem with Item = None");
		return;
	}
	else if (!Possesses(Item))
	{
		Log(self$" WARNING: SetSelectedItem with Item not present "$Item);
		return;
	}

	//Log("SetSelectedItem"@Item);

	if (Item.IsA('EAbstractGoggle'))
	{
		if (EPawn(Owner).Controller.bIsPlayer)
			EPlayerController(EPawn(Owner).Controller).ChangeHeadObject(Item);
	}
	else if (!Item.IsA('ESecondaryAmmo')) // primary
	{
		// UnEquip the current selected primary
		if (Item.bEquipable)
		{
			if (BackPackPrimSelectedItem != None && BackPackPrimSelectedItem != Item)
				UnEquipItem(BackPackPrimSelectedItem, true, Item);

			BackPackPrimSelectedItem = Item;
		}

		Item.Select(self);
		// It's possible that a pickup change handItem without changing selected item. Force Selected Item to be handItem
		if (EPawn(Owner).Controller.bIsPlayer && Item.bEquipable)
			EPlayerController(EPawn(Owner).Controller).ChangeHandObject(Item);
	}
	else
	{
		// UnEquip the current selected secondary
		if (BackPackSecSelectedItem != None)
			UnEquipItem(BackPackSecSelectedItem, false, Item);

		BackPackSecSelectedItem = Item;
		
		Item.Select(self);
	}
}

//------------------------------------------------------------------------
// Description		
//		Get the current selected item (hie never used i think)
//------------------------------------------------------------------------
function EInventoryItem GetSelectedItem(optional int hie)
{
	if (hie == 0)
		return BackPackPrimSelectedItem;
	else
		return BackPackSecSelectedItem;
}

//------------------------------------------------------------------------
// Description		
//		Unequip the current selected item
//------------------------------------------------------------------------
event UnEquipItem(EInventoryItem Item, optional bool bNoUpdate, optional EInventoryItem NewItem)
{
	if (Item == None) 
		return;

	//Log("UnEquipItem"@Item@bNoUpdate@NewItem);

	// Keep last item equiped
	if (Item == None || NewItem == None || Item.class != NewItem.class)
	{
		//Log("BACKUPING"@Item);
		PreviousEquipedItem	= Item;
	}
	//else
	//	Log("NO BACKUP"@Item == None@NewItem == None@Item.class != NewItem.class);

	if (Item == BackPackPrimSelectedItem)
	{
		BackPackPrimSelectedItem.UnSelect(self);
		BackPackPrimSelectedItem = None;

		// send message handitem changed
		if (Owner != none && EPawn(Owner).Controller.bIsPlayer && !bNoUpdate)
			EPlayerController(EPawn(Owner).Controller).ChangeHandObject(None);
	}
	else if (Item == BackPackSecSelectedItem)
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
	switch (Category)
	{
		case CAT_MAINGUN: return Localize("HUD", "FN2000", "Localization\\HUD"); break;
		case CAT_GADGETS: return Localize("HUD", "GADGETS", "Localization\\HUD"); break;
		case CAT_ITEMS:  return Localize("HUD", "ITEMS", "Localization\\HUD");  break;
	}
}

//---------------------------------------[Joshua - 4 Dec 2025]------------
// 
// Description
//		Returns the sort priority for an inventory item.
//		Lower values appear at the bottom of the inventory list.
// 
//------------------------------------------------------------------------
function int GetInventorySortPriority(EInventoryItem Item)
{
	local Name ClassName;
	
	if (Item == None)
		return 999;
	
	ClassName = Item.class.Name;

	// CAT_MAINGUN
	if (ClassName == 'EF2000')              return 0;
	if (ClassName == 'ERingAirfoilRound')   return 1;
	if (ClassName == 'EStickyShocker')      return 2;
	if (ClassName == 'ESmokeGrenade')       return 3;
	if (ClassName == 'EDiversionCamera')    return 4;
	if (ClassName == 'EStickyCamera')       return 5;

	// CAT_GADGETS
	if (ClassName == 'EFn7')                return 100;
	if (ClassName == 'ELockpick')           return 101;
	if (ClassName == 'EDisposablePick')     return 102;
	if (ClassName == 'EOpticCable')         return 103;
	if (ClassName == 'ELaserMic')           return 104;
	if (ClassName == 'ECameraJammer')       return 105;

	// CAT_ITEMS
	if (ClassName == 'EMedKit')             return 200;
	if (ClassName == 'EFlare')              return 201;
	if (ClassName == 'EChemFlare')          return 202;
	if (ClassName == 'EFragGrenade')        return 203;
	if (ClassName == 'EConcussionGrenade')  return 204;
	if (ClassName == 'EWallMine')           return 205;

	// Unknown items get sorted to end of their category
	return 999;
}

//---------------------------------------[Joshua - 4 Dec 2025]------------
// 
// Description
//		Sorts a single category of the inventory so items appear in
//		a consistent order.
// 
//------------------------------------------------------------------------
function SortCategory(eInvCategory Category)
{
	local int i, j, NumItems;
	local array<EInventoryItem> TempItems;
	local EInventoryItem Temp;
	local int PriorityI, PriorityJ;
	local bool bSwapped;

	NumItems = GetNbItemInCategory(Category);
	
	if (NumItems <= 1)
		return;

	// Copy items to temp array
	for (i = 1; i <= NumItems; i++)
	{
		TempItems[TempItems.Length] = GetItemInCategory(Category, i);
	}

	for (i = 0; i < TempItems.Length - 1; i++)
	{
		bSwapped = false;
		for (j = 0; j < TempItems.Length - i - 1; j++)
		{
			PriorityI = GetInventorySortPriority(TempItems[j]);
			PriorityJ = GetInventorySortPriority(TempItems[j+1]);

			// Lower priority first
			if (PriorityI > PriorityJ)
			{
				Temp = TempItems[j];
				TempItems[j] = TempItems[j+1];
				TempItems[j+1] = Temp;
				bSwapped = true;
			}
		}
		if (!bSwapped)
			break;
	}

	// Remove all items from this category (don't destroy them)
	for (i = 0; i < TempItems.Length; i++)
	{
		RemoveItem(TempItems[i], 0, true);
	}

	// Re-add items in sorted order
	for (i = 0; i < TempItems.Length; i++)
	{
		AddInventoryItem(TempItems[i]);
	}
}

//---------------------------------------[Joshua - 4 Dec 2025]------------
// 
// Description
//		Sorts all categories in the inventory.
// 
//------------------------------------------------------------------------
function SortInventory()
{
	SortCategory(CAT_MAINGUN);
	SortCategory(CAT_GADGETS);
	SortCategory(CAT_ITEMS);
}

defaultproperties
{
    bHidden=True
}