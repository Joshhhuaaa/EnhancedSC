//=============================================================================
//  EPCInGameInventoryArea.uc : Area displaying info on inventory elements
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/11 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameInventoryArea extends UWindowDialogClientWindow
                    native;

var EPCTextButton   m_sc20kButton, m_GadgetsButton, m_ItemsButton, m_SelectedButton;
var INT             m_IFirstButtonsXPos, m_IXButtonOffset, m_IButtonsHeight, m_IButtonsWidth, m_IButtonsYPos;

var Actor.eInvCategory    m_CurrentCategory;


var EPCInGameInvButtons   m_ArrowLeftButton, m_ArrowRightButton;
var EPCInGameInvButtons   m_InventoryButtons[4];

var INT             m_IArrowLeftXPos, m_IArrowRightXPos, m_IArrowButtonWidth,
                    m_IInvButtonWidth, m_IInvButtonHeight, m_IFirstInvButtonXPos,
                    m_IInvButtonXOffset, m_IInvYPos;

var INT             m_ISelectedItem;

var BOOL            m_bGadgetVideoIsPlaying;

var INT             m_IXVideoPos,m_IYVideoPos,m_IVideoWidth,m_IXVideoHeight;


var   EPCVScrollBar     m_ScrollBar;
var   BOOL              m_BInitScrollBar;
var INT                 m_INbScroll, m_INbLinesDisplayed;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
// Joshua - Controller navigation variables
var bool m_bControllerEnabled;  // True when controller navigation is active
var int  m_selectedTab;         // 0=SC-20K, 1=Gadgets, 2=Items
var bool m_bInContent;          // True = navigating items, False = tab selection

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Joshua - If true, prevents gadget video from restarting when the Inventory area is selected
var bool  m_bSuppressVideoOnSetCurrentItem;

function Created()
{
    SetAcceptsFocus();  // Joshua - Enable controller input

    m_sc20kButton = EPCTextButton(CreateControl(class'EPCTextButton', m_IFirstButtonsXPos, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_GadgetsButton = EPCTextButton(CreateControl(class'EPCTextButton', m_sc20kButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_ItemsButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_GadgetsButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));

    m_ArrowLeftButton  = EPCInGameInvButtons(CreateControl(class'EPCInGameInvButtons', m_IArrowLeftXPos, m_IInvYPos, m_IArrowButtonWidth, m_IInvButtonHeight, self));
    m_ArrowRightButton = EPCInGameInvButtons(CreateControl(class'EPCInGameInvButtons', m_IArrowRightXPos, m_IInvYPos, m_IArrowButtonWidth, m_IInvButtonHeight, self));

    m_InventoryButtons[0] = EPCInGameInvButtons(CreateControl(class'EPCInGameInvButtons', m_IFirstInvButtonXPos, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));
    m_InventoryButtons[1] = EPCInGameInvButtons(CreateControl(class'EPCInGameInvButtons', m_InventoryButtons[0].WinLeft + m_IInvButtonXOffset, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));
    m_InventoryButtons[2] = EPCInGameInvButtons(CreateControl(class'EPCInGameInvButtons', m_InventoryButtons[1].WinLeft + m_IInvButtonXOffset, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));
    m_InventoryButtons[3] = EPCInGameInvButtons(CreateControl(class'EPCInGameInvButtons', m_InventoryButtons[2].WinLeft + m_IInvButtonXOffset, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));

    m_InventoryButtons[0].m_bHideWhenDisabled = true;
    m_InventoryButtons[1].m_bHideWhenDisabled = true;
    m_InventoryButtons[2].m_bHideWhenDisabled = true;
    m_InventoryButtons[3].m_bHideWhenDisabled = true;

    m_sc20kButton.SetButtonText(Caps(Localize("HUD",   "FN2000","Localization\\HUD"))        ,TXT_CENTER);
    m_GadgetsButton.SetButtonText(Caps(Localize("HUD", "GADGETS","Localization\\HUD"))       ,TXT_CENTER);
    m_ItemsButton.SetButtonText(Caps(Localize("HUD",   "ITEMS","Localization\\HUD"))         ,TXT_CENTER);

    m_ArrowLeftButton.SetupTextures(EchelonLevelInfo(GetLevel()).TICON.inv_fleche_icones, EchelonLevelInfo(GetLevel()).TICON);
    m_ArrowRightButton.m_bInvertHorizontalCoord = true;
    m_ArrowRightButton.SetupTextures(EchelonLevelInfo(GetLevel()).TICON.inv_fleche_icones, EchelonLevelInfo(GetLevel()).TICON);

    m_sc20kButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;
    m_GadgetsButton.Font    = EPCMainMenuRootWindow(Root).TitleFont;
    m_ItemsButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;

    m_ScrollBar =  EPCVScrollBar(CreateWindow(class'EPCVScrollBar', 422, 126, LookAndFeel.Size_ScrollbarWidth, 118));

}

function Reset()
{
	if (m_ItemsButton.m_bSelected)
		ChangeMenuSection(m_ItemsButton);
	else if (m_GadgetsButton.m_bSelected)
		ChangeMenuSection(m_GadgetsButton);
	else
		ChangeMenuSection(m_sc20kButton);
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);

    if (m_BInitScrollBar)
    {
        if (m_INbScroll > m_INbLinesDisplayed)
        {
            m_ScrollBar.ShowWindow();
            m_ScrollBar.SetRange(0, m_INbScroll,m_INbLinesDisplayed);
        }
        else
            m_ScrollBar.HideWindow();

        m_BInitScrollBar= false;
    }
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    if ((m_ScrollBar != None) && (Y >= m_ScrollBar.WinTop))
	    m_ScrollBar.MouseWheelDown(X,Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    if ((m_ScrollBar != None) && (Y >= m_ScrollBar.WinTop))
        m_ScrollBar.MouseWheelUp(X,Y);
}


function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_sc20kButton:
        case m_GadgetsButton:
        case m_ItemsButton:
            // Joshua - Exit content mode when clicking tabs with mouse
            // Prevents staying in scroll mode when switching to empty tabs
            // Also fixes softlock when controller was in content mode
            m_bInContent = false;
            // Joshua - Clear held key state to prevent auto-repeat issues
            m_heldKey = 0;
            m_keyHoldTime = 0;
            m_nextRepeatTime = 0;
            // Joshua - Temporarily disable controller mode so ChangeMenuSection
            // shows video/content normally for mouse clicks
            m_bControllerEnabled = false;
            ChangeMenuSection(EPCTextButton(C));
            break;
        case m_ArrowLeftButton:
            SetupInventory(m_InventoryButtons[0].m_iButtonID  -1);
            break;
        case m_ArrowRightButton:
            SetupInventory(m_InventoryButtons[0].m_iButtonID  +1);
            break;
        case m_InventoryButtons[0]:
        case m_InventoryButtons[1]:
        case m_InventoryButtons[2]:
        case m_InventoryButtons[3]:
            // Joshua - If clicking the same item we're already on, don't restart video
            if (EPCInGameInvButtons(C).m_iButtonID == m_ISelectedItem)
                break;

            m_InventoryButtons[0].m_bSelected = false;
            m_InventoryButtons[1].m_bSelected = false;
            m_InventoryButtons[2].m_bSelected = false;
            m_InventoryButtons[3].m_bSelected = false;

            EPCInGameInvButtons(C).m_bSelected = true;
            SetCurrentItem(EPCInGameInvButtons(C).m_iButtonID);
            break;
        }
    }
}

//Refresh selectem button display current text and video
function SetCurrentItem(INT currentItem)
{

    local INT nbItems;
    local EInventory EpcInventory;
    local EPlayerController Epc;
    local EInventoryItem Item;
    local Canvas C;


    C = class'Actor'.static.GetCanvas();
    Epc = EPlayerController(GetPlayerOwner());
    EpcInventory = Epc.ePawn.FullInventory;

    nbItems = EpcInventory.GetNbItemInCategory(m_CurrentCategory);

    //Clear current text

    // If suppression flag is set (we're entering the area and don't want to
    // restart the video), skip stopping/starting playback. Still update
    // internal state for selected item and scrollbar.
    if (m_bSuppressVideoOnSetCurrentItem)
    {
        if (nbItems == 0 || !WindowIsVisible())
        {
            m_bGadgetVideoIsPlaying = false;
        }
        // Update selected item and mark scrollbar init, but don't touch video
        m_ISelectedItem = currentItem;
        m_BInitScrollBar = true;
        return;
    }

    C.VideoStop();

    if (nbItems == 0 || !WindowIsVisible())
    {
        m_bGadgetVideoIsPlaying = false;
    }
    else
    {
        Item = EpcInventory.GetItemInCategory(m_CurrentCategory, currentItem + 1);
        m_ScrollBar.Pos = 0;

        // Start the new one
        C.m_bLoopVideo = true;
        C.VideoOpen(Item.ItemVideoName, 0, false, false);
        C.VideoPlay(m_IXVideoPos,m_IYVideoPos,0);

        m_bGadgetVideoIsPlaying = true;
    }

    m_ISelectedItem = currentItem;
    m_BInitScrollBar = true;


}

function ChangeMenuSection(EPCTextButton _SelectMe)
{
    // Joshua - If clicking the same tab we're already on, don't restart video
    if (_SelectMe == m_SelectedButton)
        return;

    m_sc20kButton.m_bSelected       =  false;
    m_GadgetsButton.m_bSelected     =  false;
    m_ItemsButton.m_bSelected       =  false;

    m_SelectedButton = _SelectMe;
    m_SelectedButton.m_bSelected    =  true;

    switch (_SelectMe)
    {
    case m_sc20kButton:
        m_CurrentCategory            = CAT_MAINGUN;
        m_selectedTab = 0;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_GadgetsButton:
        m_CurrentCategory            = CAT_GADGETS;
        m_selectedTab = 1;  // Joshua - Keep m_selectedTab in sync
        break;
    case m_ItemsButton:
        m_CurrentCategory            = CAT_ITEMS;
        m_selectedTab = 2;  // Joshua - Keep m_selectedTab in sync
        break;
    }

    // Joshua - In controller mode at tab level, suppress video and clear item display
    if (m_bControllerEnabled && !m_bInContent)
    {
        m_bSuppressVideoOnSetCurrentItem = true;
        SetCurrentItem(0);
        m_bSuppressVideoOnSetCurrentItem = false;
        SetupInventory(0);
        // Clear item content display (Xbox-style)
        ClearItemContentDisplay();
    }
    else
    {
        SetCurrentItem(0);
        // Clear after SetCurrentItem so normal behavior resumes for subsequent tab changes
        m_bSuppressVideoOnSetCurrentItem = false;
        SetupInventory(0);
    }
}

//Permet de r?initialiser les boutons apr?s un changement de cat?gorie
function SetupInventory(INT _StartPos)
{
    local INT nbItems;
    local EInventory EpcInventory;
    local EPlayerController Epc;

    Epc = EPlayerController(GetPlayerOwner());
    EpcInventory = Epc.ePawn.FullInventory;

    nbItems = EpcInventory.GetNbItemInCategory(m_CurrentCategory);

    SetupButtons(_StartPos, nbItems);
}

///Permet de mettre la bonne texture en fonction du scroll et de la cat?gorie sr chaque bouton
function SetupButtons(INT _StartPos, INT _MaxElements)
{
   local INT i, j;
   local EInventoryItem Item;
   local BOOL bMaxReached;
   local EInventory EpcInventory;
   local EPlayerController Epc;

   Epc = EPlayerController(GetPlayerOwner());
   EpcInventory = Epc.ePawn.FullInventory;

   //Loop ? travers les 4 boutons
   i = _StartPos;
   for (j = 0; j < 4; j++)
   {
       if (i < _MaxElements)
       {
           Item = EpcInventory.GetItemInCategory(m_CurrentCategory, i + 1);

           if (i == m_ISelectedItem)
               m_InventoryButtons[j].m_bSelected= true;
           else
               m_InventoryButtons[j].m_bSelected= false;

           m_InventoryButtons[j].SetupTextures(Item.InventoryTex, EchelonLevelInfo(GetLevel()).TICON);
           m_InventoryButtons[j].m_iButtonID = i;
           m_InventoryButtons[j].bDisabled = false;

       }
       else
       {
           m_InventoryButtons[j].bDisabled = true;
       }
       i++;
   }

   //Setup Arrows
   if (_StartPos > 0)
        m_ArrowLeftButton.bDisabled = false;
   else
        m_ArrowLeftButton.bDisabled = true;

   if (_StartPos + 4 < _MaxElements) //Since we have 4 inv buttons
        m_ArrowRightButton.bDisabled = false;
    else
        m_ArrowRightButton.bDisabled = true;

}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    m_bControllerEnabled = bEnable;
    if (bEnable)
    {
        // Bring window to front to receive input
        BringToFront();

        // Start at tab selection level
        m_bInContent = false;

        // Joshua - Only update tab visual, don't reset item selection
        // This preserves the current item when switching input modes
        UpdateTabSelectionVisualOnly();

        // Joshua - Clear item content display when entering at tab level (similar to Xbox)
        ClearItemContentDisplay();
    }
    else
    {
        // Clear held key state to prevent auto-scroll on re-entry
        m_heldKey = 0;
        m_keyHoldTime = 0;
        m_nextRepeatTime = 0;
        // In controller mode, hide tab selection bar when not in this section
        if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
        {
            ClearTabSelections();
        }
    }
}

// Joshua - Clear all tab selection visuals (for controller mode when section is not active)
function ClearTabSelections()
{
    m_sc20kButton.m_bSelected = false;
    m_GadgetsButton.m_bSelected = false;
    m_ItemsButton.m_bSelected = false;
}

// Joshua - Clear item selection and hide video/description when exiting on controller (similar to Xbox)
function ClearItemContentDisplay()
{
    local Canvas C;

    // Clear all inventory button selections
    m_InventoryButtons[0].m_bSelected = false;
    m_InventoryButtons[1].m_bSelected = false;
    m_InventoryButtons[2].m_bSelected = false;
    m_InventoryButtons[3].m_bSelected = false;

    // Stop any playing video
    C = class'Actor'.static.GetCanvas();
    if (C != None)
        C.VideoStop();
    m_bGadgetVideoIsPlaying = false;

    // Hide the scrollbar
    if (m_ScrollBar != None)
        m_ScrollBar.HideWindow();
}

// Joshua - Restore item selection and show video/description
// Called when entering content mode on controller, or switching to mouse
function RestoreItemContentDisplay()
{
    local int nbItems;

    nbItems = GetCurrentTabItemCount();
    if (nbItems > 0)
    {
        // Re-setup buttons to restore the selection highlight
        SetupButtons(m_InventoryButtons[0].m_iButtonID, nbItems);

        // Only restart video if it's not already playing
        if (!m_bGadgetVideoIsPlaying)
        {
            m_bSuppressVideoOnSetCurrentItem = false;
            SetCurrentItem(m_ISelectedItem);
        }
    }
}

// Joshua - Restore tab selection based on m_selectedTab (when switching to keyboard/mouse)
// Only updates visuals, does not reset item selection
function RestoreTabSelection()
{
    UpdateTabSelectionVisualOnly();
}

// Joshua - Get item count for current tab
function int GetCurrentTabItemCount()
{
    local EInventory EpcInventory;
    local EPlayerController Epc;
    local Actor.eInvCategory cat;

    Epc = EPlayerController(GetPlayerOwner());
    if (Epc == None || Epc.ePawn == None)
        return 0;

    EpcInventory = Epc.ePawn.FullInventory;
    if (EpcInventory == None)
        return 0;

    // Map tab index to category
    switch (m_selectedTab)
    {
        case 0: cat = CAT_MAINGUN; break;
        case 1: cat = CAT_GADGETS; break;
        case 2: cat = CAT_ITEMS; break;
        default: return 0;
    }

    return EpcInventory.GetNbItemInCategory(cat);
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local int nbItems;
    local EInventory EpcInventory;
    local EPlayerController Epc;

    // Don't process controller input when area is not enabled
    // Still let mouse/paint events through
    if (!m_bControllerEnabled)
    {
        // Block controller keys when area is not enabled
        if (Msg == WM_KeyDown && Key >= 196 && Key <= 215)
            return;

        Super.WindowEvent(Msg, C, X, Y, Key);
        return;
    }

    // Handle B button before Super to prevent parent from processing it
    if (Msg == WM_KeyDown && Key == 201)
    {
        if (m_bInContent)
        {
            // Inside content - go back to tab level
            m_bInContent = false;
            // Stop auto-repeat
            m_heldKey = 0;
            m_keyHoldTime = 0;
            // Joshua - Clear item selection and hide video/description (Xbox-style)
            ClearItemContentDisplay();
            Root.PlayClickSound();
        }
        else
        {
            // At tab level - exit to section selection
            Root.PlayClickSound();
            EPCInGameMenu(ParentWindow).SectionExited();
        }
        return;  // Don't let B reach any parent
    }

    Super.WindowEvent(Msg, C, X, Y, Key);

    // Track key releases for auto-repeat
    if (Msg == WM_KeyUp)
    {
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
            m_nextRepeatTime = 0;
        }
        return;
    }

    if (Msg == WM_KeyDown)
    {
        // Track repeatable keys (directional keys only)
        if (Key == 212 || Key == 196 || Key == 213 || Key == 197 ||
            Key == 214 || Key == 198 || Key == 215 || Key == 199)
        {
            if (Key != m_heldKey)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        HandleKeyAction(Key);
    }
}

// Joshua - Process a key action (called on initial press and during auto-repeat)
function HandleKeyAction(int Key)
{
    local int nbItems;
    local EInventory EpcInventory;
    local EPlayerController Epc;

    if (m_bInContent)
    {
        // Inside content - navigate items with Left/Right, scroll text with Up/Down
        switch (Key)
        {
            // Left - Previous item (repeatable)
            case 198:
            case 214:
                Epc = EPlayerController(GetPlayerOwner());
                EpcInventory = Epc.ePawn.FullInventory;
                nbItems = EpcInventory.GetNbItemInCategory(m_CurrentCategory);

                if (m_ISelectedItem > 0)
                {
                    SelectItem(m_ISelectedItem - 1, nbItems);
                    Root.PlayClickSound();
                }
                break;

            // Right - Next item (repeatable)
            case 199:
            case 215:
                Epc = EPlayerController(GetPlayerOwner());
                EpcInventory = Epc.ePawn.FullInventory;
                nbItems = EpcInventory.GetNbItemInCategory(m_CurrentCategory);

                if (m_ISelectedItem < nbItems - 1)
                {
                    SelectItem(m_ISelectedItem + 1, nbItems);
                    Root.PlayClickSound();
                }
                break;

            // Up - Scroll text up (repeatable)
            case 196:
            case 212:
                if (m_ScrollBar != None && m_ScrollBar.bWindowVisible && m_ScrollBar.Pos > m_ScrollBar.MinPos)
                {
                    m_ScrollBar.Scroll(-1);
                    Root.PlayClickSound();
                }
                break;

            // Down - Scroll text down (repeatable)
            case 197:
            case 213:
                if (m_ScrollBar != None && m_ScrollBar.bWindowVisible && m_ScrollBar.Pos < m_ScrollBar.MaxPos)
                {
                    m_ScrollBar.Scroll(1);
                    Root.PlayClickSound();
                }
                break;
        }
    }
    else
    {
        // At tab level - navigate tabs with Left/Right (wrap-around), press A to enter content
        switch (Key)
        {
            // Left - Previous tab (wrap from SC-20K to Items)
            case 198:
            case 214:
                m_selectedTab = (m_selectedTab - 1 + 3) % 3;
                UpdateTabSelection();
                Root.PlayClickSound();
                break;

            // Right - Next tab (wrap from Items to SC-20K)
            case 199:
            case 215:
                m_selectedTab = (m_selectedTab + 1) % 3;
                UpdateTabSelection();
                Root.PlayClickSound();
                break;

            // A - Enter content (start navigating items) - only if tab has items
            case 200:
                if (GetCurrentTabItemCount() > 0)
                {
                    m_bInContent = true;
                    // Joshua - Restore item selection and show video/description (Xbox-style)
                    RestoreItemContentDisplay();
                    Root.PlayClickSound();
                }
                break;
        }
    }
}

// Joshua - Tick function for auto-repeat scrolling and tab navigation
function Tick(float Delta)
{
    Super.Tick(Delta);

    if (!m_bControllerEnabled || m_heldKey == 0)
        return;

    // Allow auto-repeat in content or for tab navigation
    if (m_bInContent)
    {
        // All directional keys repeat in content
    }
    else
    {
        // Only left/right for tabs when not in content
        if (m_heldKey != 214 && m_heldKey != 198 && m_heldKey != 215 && m_heldKey != 199)
            return;
    }

    m_keyHoldTime += Delta;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        HandleKeyAction(m_heldKey);
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

// Update tab selection visually and load items
function UpdateTabSelection()
{
    switch (m_selectedTab)
    {
        case 0: ChangeMenuSection(m_sc20kButton); break;
        case 1: ChangeMenuSection(m_GadgetsButton); break;
        case 2: ChangeMenuSection(m_ItemsButton); break;
    }
}

// Joshua - Update tab selection visually only, without resetting item selection
// Used when switching input modes to preserve current item position
function UpdateTabSelectionVisualOnly()
{
    m_sc20kButton.m_bSelected = false;
    m_GadgetsButton.m_bSelected = false;
    m_ItemsButton.m_bSelected = false;

    switch (m_selectedTab)
    {
        case 0:
            m_sc20kButton.m_bSelected = true;
            m_SelectedButton = m_sc20kButton;
            break;
        case 1:
            m_GadgetsButton.m_bSelected = true;
            m_SelectedButton = m_GadgetsButton;
            break;
        case 2:
            m_ItemsButton.m_bSelected = true;
            m_SelectedButton = m_ItemsButton;
            break;
    }
}

// Select an item and update the display, scrolling if needed
function SelectItem(int newItem, int nbItems)
{
    local int startPos;

    m_ISelectedItem = newItem;

    // Calculate which set of 4 items should be visible
    startPos = m_InventoryButtons[0].m_iButtonID;

    // If new item is before visible range, scroll left
    if (newItem < startPos)
    {
        SetupInventory(newItem);
    }
    // If new item is after visible range, scroll right
    else if (newItem >= startPos + 4)
    {
        SetupInventory(newItem - 3);
    }
    else
    {
        // Item is in visible range, just update selection
        SetupButtons(startPos, nbItems);
    }

    SetCurrentItem(newItem);
}

defaultproperties
{
    m_IFirstButtonsXPos=6
    m_IXButtonOffset=148
    m_IButtonsHeight=18
    m_IButtonsWidth=144
    m_IButtonsYPos=5
    m_IArrowLeftXPos=25
    m_IArrowRightXPos=410
    m_IArrowButtonWidth=15
    m_IInvButtonWidth=79
    m_IInvButtonHeight=46
    m_IFirstInvButtonXPos=55
    m_IInvButtonXOffset=90
    m_IInvYPos=40
    m_IXVideoPos=145
    m_IYVideoPos=192
    m_IVideoWidth=180
    m_IXVideoHeight=139
    m_initialDelay=0.5
    m_repeatRate=0.1
}