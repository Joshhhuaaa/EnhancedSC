//=============================================================================
// UWindowList - a generic linked list class
//=============================================================================
class UWindowList extends UWindowBase
        native;

var UWindowList	Next;
var UWindowList	Last;		// Only valid for sentinel
var UWindowList	Prev;
var UWindowList	Sentinel;
var int			InternalCount;
var bool		bItemOrderChanged;

var bool		bSuspendableSort;

var int			CompareCount;
var bool		bSortSuspended;
var UWindowList CurrentSortItem;

// Binary tree variables for sentinel
var bool		bTreeSort;

// Binary tree variables for each element
var UWindowList BranchLeft;
var UWindowList BranchRight;
var UWindowList ParentNode;

var int Tag;

/* Tree Sorting:

- Items must be added with AppendItem()
- Items which require resorting must call MoveItemSorted()
- Should call Tick and set bSuspendableSort - for large sorts!

*/

/********** These things can be called on any element **********/

function UWindowList CreateItem(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = New C;
	return NewElement;
}

function GraftLeft(UWindowList NewLeft)
{
	assert(Sentinel.bTreeSort);

	BranchLeft = NewLeft;
	if (NewLeft != None)
		NewLeft.ParentNode = Self;
}

function GraftRight(UWindowList NewRight)
{
	assert(Sentinel.bTreeSort);

	BranchRight = NewRight;
	if (NewRight != None)
		NewRight.ParentNode = Self;
}

// Return rightmost child of subtree
function UWindowList RightMost()
{
	local UWindowList L;

	assert(Sentinel.bTreeSort);

	if (BranchRight == None)
		return None;

	L = Self;
	while (L.BranchRight != None)
		L = L.BranchRight;

	return L;
}

// Return leftmost child of subtree
function UWindowList LeftMost()
{
	local UWindowList L;

	assert(Sentinel.bTreeSort);

	if (BranchLeft == None)
		return None;

	L = Self;
	while (L.BranchLeft != None)
		L = L.BranchLeft;

	return L;
}

function Remove()
{
	local UWindowList T;

	if (Next != None)
		Next.Prev = Prev;
	
	if (Prev != None)
		Prev.Next = Next;
	
	if (Sentinel != None)
	{
		if (Sentinel.bTreeSort && ParentNode != None)
		{
			if (BranchLeft != None)
			{
				if (ParentNode.BranchLeft == Self)
					ParentNode.GraftLeft(BranchLeft);
				if (ParentNode.BranchRight == Self)
					ParentNode.GraftRight(BranchLeft);

				// If we had a right branch we better move it
				// into the far right of the left branch.

				T = BranchLeft.Rightmost();
				if (T != None)
					T.GraftRight(BranchRight);
			}
			else
			{
				if (ParentNode.BranchLeft == Self)
					ParentNode.GraftLeft(BranchRight);
				if (ParentNode.BranchRight == Self)
					ParentNode.GraftRight(BranchRight);

				// no left branch to worry about.
			}
	
			ParentNode = None;
			BranchLeft = None;
			BranchRight = None;
		}

		Sentinel.InternalCount--;
		Sentinel.bItemOrderChanged = true;

		if (Sentinel.Last == Self)
			Sentinel.Last = Prev;

		Prev = None;
		Next = None;
	
	/*	Sentinel.Validate();  */
		Sentinel = None;
	}
}

function int Compare(UWindowList T, UWindowList B)
{
	// declare actual sort method in subclass
	return 0;
}

// Inserts a new element before us.  DO NOT CALL on the sentinel.
function UWindowList InsertBefore(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	InsertItemBefore(NewElement);

	return NewElement;
}

function UWindowList InsertAfter(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	InsertItemAfter(NewElement);

	return NewElement;
}


// Inserts an element before us.  DO NOT CALL on the sentinel.
function InsertItemBefore(UWindowList NewElement)
{
	assert(Sentinel != Self);

	NewElement.BranchLeft = None;
	NewElement.BranchRight = None;
	NewElement.ParentNode = None;
	NewElement.Sentinel = Sentinel;	
	NewElement.BranchLeft = None;
	NewElement.BranchRight = None;
	NewElement.ParentNode = None;
	NewElement.Prev = Prev;	
	Prev.Next = NewElement;
	Prev = NewElement;
	NewElement.Next = Self;

	if (Sentinel.Next == Self)
		Sentinel.Next = NewElement;

	Sentinel.InternalCount++;
	Sentinel.bItemOrderChanged = true;
}

function InsertItemAfter(UWindowList NewElement, optional bool bCheckShowItem)
{
	local UWindowList N;
	
	N = Next;
	if (bCheckShowItem)
		while (N != None && !N.ShowThisItem())
			N = N.Next; 

	if (N != None)
		N.InsertItemBefore(NewElement);
	else
		Sentinel.DoAppendItem(NewElement);
	Sentinel.bItemOrderChanged = true;
}

function ContinueSort()
{
	local UWindowList N;

	CompareCount = 0;
	bSortSuspended = false;

	while (CurrentSortItem != None)
	{
		N = CurrentSortItem.Next;
		AppendItem(CurrentSortItem);
		CurrentSortItem = N;

		// split sort over multiple frames, if it's BIG
		if (CompareCount >= 10000 && bSuspendableSort)
		{
			bSortSuspended = true;
			return;
		}
	}		
}

function Tick(float Delta)
{
	if (bSortSuspended)
		ContinueSort();
}

function UWindowList Sort()
{
	local UWindowList S;
	local UWindowList CurrentItem;
	local UWindowList Previous;
	local UWindowList Best;
	local UWindowList BestPrev;

	if (bTreeSort)
	{
		if (bSortSuspended)
		{
			ContinueSort();
			return Self;
		}

		CurrentSortItem = Next;
		DisconnectList();
		ContinueSort();
		return Self;
	}

	CurrentItem = Self;

	while (CurrentItem != None)
	{
		S = CurrentItem.Next;	Best = CurrentItem.Next;
		Previous = CurrentItem;	BestPrev = CurrentItem;
		
		// Find the best server
		while (S != None)
		{
			if (CurrentItem.Compare(S, Best) <= 0) 
			{
				Best = S;
				BestPrev = Previous;
			}
			
			Previous = S;
			S = S.Next;
		}

		// If we're not already in the right order, move the best one next.
		if (Best != CurrentItem.Next)
		{
			// Delete Best's old position
			BestPrev.Next = Best.Next;
			if (BestPrev.Next != None)
				BestPrev.Next.Prev = BestPrev;

			// Fix Self and Best
			Best.Prev = CurrentItem;
			Best.Next = CurrentItem.Next;
			CurrentItem.Next.Prev = Best; 
			CurrentItem.Next = Best;
			
			// Fix up Sentinel if Best was also Last 
			if (Sentinel.Last == Best)
			{
				Sentinel.Last = BestPrev;
				if (Sentinel.Last == None)
					Sentinel.Last = Sentinel;
			}
		}

		CurrentItem = CurrentItem.Next;
	}

	//Validate();
	return Self;
}

function DisconnectList() 
{
	Next = None;
	Last = Self;
	Prev = None;
	BranchLeft = None;
	BranchRight = None;
	ParentNode = None;
	InternalCount = 0;
	Sentinel.bItemOrderChanged = true;
}

function DestroyList() 
{
	local UWindowList L, Temp;
	L = Next;

	InternalCount = 0;
	if (Sentinel != None)
		Sentinel.bItemOrderChanged = true;

	while (L != None)
	{
		Temp = L.Next;
		L.DestroyListItem();
		L = Temp;
	}
	DestroyListItem();
}

function DestroyListItem()
{
	Next = None;
	Last = Self;
	Sentinel = None;
	Prev = None;
	BranchLeft = None;
	BranchRight = None;
	ParentNode = None;
}

function int CountShown() 
{
	local int C;
	local UWindowList I;

	for (I = Next;I != None; I = I.Next)
		if (I.ShowThisItem())
			C++;

	return C;
}

function UWindowList CopyExistingListItem(Class<UWindowList> ItemClass, UWindowList SourceItem)
{
	local UWindowList I;

	I = Append(ItemClass);
	Sentinel.bItemOrderChanged = true;

	return I;
}

// for Listboxes only (so far)
function bool ShowThisItem()
{
	return True;
}

/********** These things can only be called on the sentinel **********/
function int Count() 
{
	return InternalCount;
}

function MoveItemSorted(UWindowList Item)
{
	local UWindowList L;

	if (bTreeSort)
	{
		Item.Remove();
		AppendItem(Item);
	}
	else
	{
		for (L = Next; L != None; L = L.Next)
			if (Compare(Item, L) <= 0) break;

		if (L != Item)
		{
			Item.Remove();
			if (L == None)
				AppendItem(Item);
			else
				L.InsertItemBefore(Item);
		}
	}
}

function SetupSentinel(optional bool bInTreeSort)
{
	Last = Self;
	Next = None;
	Prev = None;
	BranchLeft = None;
	BranchRight = None;
	ParentNode = None;
	Sentinel = Self;
	InternalCount = 0;
	bItemOrderChanged = true;
	bTreeSort = bInTreeSort;
}

function Validate()
{
	local UWindowList I, Previous;
	local int Count;

	if (Sentinel != Self)
	{
		Log("Calling Sentinel.Validate() from "$Self);
		Sentinel.Validate();
		return;
	}

	Log("BEGIN Validate(): "$Class);

	Count = 0;
	Previous = Self;

	for (I = Next; I != None; I = I.Next)
	{
		Log("Checking item: "$Count);

		if (I.Sentinel != Self)
			Log("   I.Sentinel reference is broken");
	
		if (I.Prev != Previous)
			Log("   I.Prev reference is broken");

		if (Last == I && I.Next != None)
			Log("   Item is Sentinel.Last but Item has valid Next");

		if (I.Next == None && Last != I)
			Log("   Item is Item.Next is none, but Item is not Sentinel.Last");

		Previous = I;
		Count++;
	}

	Log("END Validate(): "$Class);		
}

// For sentinel only
function UWindowList Append(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	AppendItem(NewElement);	
	
	return NewElement;
}

function AppendItem(UWindowList NewElement)
{
	local UWindowList Node, OldNode, Temp;
	local int Test;

	if (bTreeSort)
	{
		// Check for worst cases!
		if (Next != None && Last != Self)
		{
			if (Compare(NewElement, Last) >= 0)
			{
				// put at end of list
				Node = Last;
				Node.InsertItemAfter(NewElement, False);
				Node.GraftRight(NewElement);
				return;	
			}

			if (Compare(NewElement, Next) <= 0)
			{
				// put at front of list
				Node = Next;
				Node.InsertItemBefore(NewElement);
				Node.GraftLeft(NewElement);
				return;
			}
		}

		Node = Self;
		while (True)
		{
			if (Node == Self)
				Test = 1;
			else
				Test = Compare(NewElement, Node);

			// special case for equality
			if (Test == 0)
			{
				Node.InsertItemAfter(NewElement, False);
				return;
			}
			else
			if (Test > 0)
			{
				// Traverse right
				OldNode = Node;
				Node = Node.BranchRight;
				if (Node == None)
				{
					// Move past equal values
					Temp = OldNode;
					while (Temp.Next != None && Temp.Next.ParentNode == None)
						Temp = Temp.Next;
					
					Temp.InsertItemAfter(NewElement, False);
					OldNode.GraftRight(NewElement);
					return;
				}
			}
			else
			{
				// Traverse left
				OldNode = Node;
				Node = Node.BranchLeft;
				if (Node == None)
				{
					OldNode.InsertItemBefore(NewElement);
					OldNode.GraftLeft(NewElement);
					return;
				}
			}
		}
	}
	else
		DoAppendItem(NewElement);
}

function DoAppendItem(UWindowList NewElement)
{
	NewElement.Next = None;
	Last.Next = NewElement;
	NewElement.Prev = Last;
	NewElement.Sentinel = Self;
	NewElement.BranchLeft = None;
	NewElement.BranchRight = None;
	NewElement.ParentNode = None;
	Last = NewElement;
	Sentinel.InternalCount++;
	Sentinel.bItemOrderChanged = true;
}


// For sentinel only
function UWindowList Insert(Class<UWindowList> C)
{
	local UWindowList NewElement;

	NewElement = CreateItem(C);
	InsertItem(NewElement);
	
	return NewElement;
}

function InsertItem(UWindowList NewElement)
{
	NewElement.Next = Next;
	if (Next != None)
		Next.Prev = NewElement;
	Next = NewElement;
	if (Last == Self)
		Last = Next;
	NewElement.Prev = Self;
	NewElement.Sentinel = Self;	
	NewElement.BranchLeft = None;
	NewElement.BranchRight = None;
	NewElement.ParentNode = None;
	Sentinel.InternalCount++;
	Sentinel.bItemOrderChanged = true;
}

// For sentinel only
function UWindowList FindEntry(int Index)
{
	local UWindowList l;
	local int i;

	l = Next;
	for (i = 0; i < Index; i++) 
	{
		l = l.Next;
		if (l == None) return None;
	}
	return l;
}

function AppendListCopy(UWindowList L)
{
	if (L == None)
		return;

	for (L = L.Next;L != None; L = L.Next)
		CopyExistingListItem(L.Class, L);
}

function Clear()
{
	InternalCount = 0;
	ParentNode = None;
	BranchLeft = None;
	BranchRight = None;
	bItemOrderChanged = true;
	Next = None;	
	Last = Self;
}
