//=============================================================================
//  EPCInGameDataArea.uc : Area displayin recon data
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameDataArea extends UWindowDialogClientWindow
            native;

var EPCReconListBox         m_ListBox;
var INT                     m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight;

// Joshua - Remember selected index for controller navigation
var int m_lastSelectedIndex;

function Created()
{
    m_ListBox           = EPCReconListBox(CreateControl(class'EPCReconListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_LEFT;
}

function FillListBox()
{
    local EPlayerController EPC;
	local EListNode         Node;
	local ERecon	        Recon;
    local EPCListBoxItem L;


    m_ListBox.Clear();
    EPC = EPlayerController(GetPlayerOwner());

    Node = EPC.ReconList.FirstNode;

    while (Node != None)
    {
        L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
        L.m_Object = ERecon(Node.Data);
        L.Caption  = Localize("Recon",ERecon(Node.Data).ReconName,"Localization\\HUD");

        Node = Node.NextNode;
    }

    // Joshua - Don't auto-select first item; wait for controller to press A to enter content
    // Selection will happen via SelectFirstItem() when controller enters the area

}

function Notify(UWindowDialogControl C, byte E)
{
    if (E == DE_DoubleClick && C == m_ListBox && m_ListBox.SelectedItem != None)
    {
        Root.ChangeCurrentWidget(WidgetID_InGameDataDetails);
        EPCMainMenuRootWindow(Root).m_InGameDataDetailsWidget.SetDataInfo(ERecon(EPCListBoxItem(m_ListBox.SelectedItem).m_Object));
    }
    // Joshua - Mouse clicked on list item, sync controller state to be in content
    else if (E == DE_Click && C == m_ListBox && m_ListBox.SelectedItem != None)
    {
        EPCInGameMissionInfoArea(ParentWindow).OnDataItemClicked();
    }
}


function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
}

// Joshua - Clear selection visually but remember position for re-entry
function ClearSelection()
{
    // Remember current position before clearing
    if (m_ListBox.SelectedItem != None)
    {
        m_lastSelectedIndex = GetSelectedIndex();
        // Must manually clear bSelected flag since SetSelectedItem(None) doesn't work
        m_ListBox.SelectedItem.bSelected = false;
        m_ListBox.SelectedItem = None;
    }
}

// Joshua - Get current selected index
function int GetSelectedIndex()
{
    local UWindowListBoxItem Item;
    local int Index;

    Index = 0;
    Item = UWindowListBoxItem(m_ListBox.Items.Next);
    while (Item != None)
    {
        if (Item == m_ListBox.SelectedItem)
            return Index;
        Index++;
        Item = UWindowListBoxItem(Item.Next);
    }
    return 0;
}

// Joshua - Select item by index
function SelectByIndex(int Index)
{
    local UWindowListBoxItem Item;
    local int i;

    if (m_ListBox.Items.Count() == 0)
        return;

    // Clamp index to valid range
    if (Index < 0)
        Index = 0;
    if (Index >= m_ListBox.Items.Count())
        Index = m_ListBox.Items.Count() - 1;

    Item = UWindowListBoxItem(m_ListBox.Items.Next);
    for (i = 0; i < Index && Item != None; i++)
    {
        Item = UWindowListBoxItem(Item.Next);
    }

    if (Item != None)
    {
        m_ListBox.SetSelectedItem(Item);
        m_ListBox.MakeSelectedVisible();
    }
}

// Joshua - Restore selection from remembered position
function RestoreSelection()
{
    if (m_ListBox.Items.Count() > 0)
    {
        SelectByIndex(m_lastSelectedIndex);
    }
}

// Joshua - Select first item (only used on first entry, otherwise RestoreSelection is used)
function SelectFirstItem()
{
    if (m_ListBox.Items.Count() > 0)
    {
        m_ListBox.SetSelectedItem(UWindowListBoxItem(m_ListBox.Items.Next));
        m_ListBox.MakeSelectedVisible();
        m_lastSelectedIndex = 0;
    }
}

function NavigateUp()
{
    local UWindowListBoxItem Item;

    if (m_ListBox.SelectedItem == None)
    {
        SelectFirstItem();
        return;
    }

    // Get previous item
    Item = UWindowListBoxItem(m_ListBox.SelectedItem.Prev);
    if (Item != None && Item != m_ListBox.Items)
    {
        m_ListBox.SetSelectedItem(Item);
        m_ListBox.MakeSelectedVisible();
        Root.PlayClickSound();
    }
}

function NavigateDown()
{
    local UWindowListBoxItem Item;

    if (m_ListBox.SelectedItem == None)
    {
        SelectFirstItem();
        return;
    }

    // Get next item
    Item = UWindowListBoxItem(m_ListBox.SelectedItem.Next);
    if (Item != None)
    {
        m_ListBox.SetSelectedItem(Item);
        m_ListBox.MakeSelectedVisible();
        Root.PlayClickSound();
    }
}

function ActivateSelected()
{
    if (m_ListBox.SelectedItem != None)
    {
        Root.PlayClickSound();
        Root.ChangeCurrentWidget(WidgetID_InGameDataDetails);
        EPCMainMenuRootWindow(Root).m_InGameDataDetailsWidget.SetDataInfo(ERecon(EPCListBoxItem(m_ListBox.SelectedItem).m_Object));
    }
}

defaultproperties
{
    m_IListBoxXPos=3
    m_IListBoxYPos=50
    m_IListBoxWidth=139
    m_IListBoxHeight=156
}