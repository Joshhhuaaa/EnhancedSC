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

    //Selects first element of the list box
    if (m_ListBox.Items.Count() > 0)
    {
        m_ListBox.SetSelectedItem(UWindowListBoxItem(m_ListBox.Items.Next));
        m_ListBox.MakeSelectedVisible(); 
    }

}

function Notify(UWindowDialogControl C, byte E)
{
    if (E == DE_DoubleClick && C == m_ListBox && m_ListBox.SelectedItem != None)
    {
        Root.ChangeCurrentWidget(WidgetID_InGameDataDetails);
        EPCMainMenuRootWindow(Root).m_InGameDataDetailsWidget.SetDataInfo(ERecon(EPCListBoxItem(m_ListBox.SelectedItem).m_Object));
    }

}
    

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
}

defaultproperties
{
    m_IListBoxXPos=3
    m_IListBoxYPos=50
    m_IListBoxWidth=139
    m_IListBoxHeight=156
}