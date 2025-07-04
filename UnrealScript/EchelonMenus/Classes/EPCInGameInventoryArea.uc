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


function Created()
{
    
    m_sc20kButton = EPCTextButton(CreateControl( class'EPCTextButton', m_IFirstButtonsXPos, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_GadgetsButton = EPCTextButton(CreateControl( class'EPCTextButton', m_sc20kButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_ItemsButton  = EPCTextButton(CreateControl( class'EPCTextButton', m_GadgetsButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));

    m_ArrowLeftButton  = EPCInGameInvButtons(CreateControl( class'EPCInGameInvButtons', m_IArrowLeftXPos, m_IInvYPos, m_IArrowButtonWidth, m_IInvButtonHeight, self));
    m_ArrowRightButton = EPCInGameInvButtons(CreateControl( class'EPCInGameInvButtons', m_IArrowRightXPos, m_IInvYPos, m_IArrowButtonWidth, m_IInvButtonHeight, self));

    m_InventoryButtons[0] = EPCInGameInvButtons(CreateControl( class'EPCInGameInvButtons', m_IFirstInvButtonXPos, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));
    m_InventoryButtons[1] = EPCInGameInvButtons(CreateControl( class'EPCInGameInvButtons', m_InventoryButtons[0].WinLeft + m_IInvButtonXOffset, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));
    m_InventoryButtons[2] = EPCInGameInvButtons(CreateControl( class'EPCInGameInvButtons', m_InventoryButtons[1].WinLeft + m_IInvButtonXOffset, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));
    m_InventoryButtons[3] = EPCInGameInvButtons(CreateControl( class'EPCInGameInvButtons', m_InventoryButtons[2].WinLeft + m_IInvButtonXOffset, m_IInvYPos, m_IInvButtonWidth, m_IInvButtonHeight, self));

    m_InventoryButtons[0].m_bHideWhenDisabled = true;
    m_InventoryButtons[1].m_bHideWhenDisabled = true;
    m_InventoryButtons[2].m_bHideWhenDisabled = true;
    m_InventoryButtons[3].m_bHideWhenDisabled = true;

    m_sc20kButton.SetButtonText( Caps(Localize("HUD",   "FN2000","Localization\\HUD"))        ,TXT_CENTER);    
    m_GadgetsButton.SetButtonText( Caps(Localize("HUD", "GADGETS","Localization\\HUD"))       ,TXT_CENTER);
    m_ItemsButton.SetButtonText( Caps(Localize("HUD",   "ITEMS","Localization\\HUD"))         ,TXT_CENTER);

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
	if(m_ItemsButton.m_bSelected)
		ChangeMenuSection(m_ItemsButton);    
	else if(m_GadgetsButton.m_bSelected)
		ChangeMenuSection(m_GadgetsButton);    
	else
		ChangeMenuSection(m_sc20kButton);
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);

    if(m_BInitScrollBar)
    {
        if(m_INbScroll > m_INbLinesDisplayed )
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
    if( (m_ScrollBar != None) && (Y >= m_ScrollBar.WinTop) )
	    m_ScrollBar.MouseWheelDown(X,Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    if( (m_ScrollBar != None) && (Y >= m_ScrollBar.WinTop) )
        m_ScrollBar.MouseWheelUp(X,Y); 
}


function Notify(UWindowDialogControl C, byte E)
{

	if(E == DE_Click)
	{
        switch(C)
        {
        case m_sc20kButton:
        case m_GadgetsButton:
        case m_ItemsButton:                     
            ChangeMenuSection(EPCTextButton(C));            
            break;
        case m_ArrowLeftButton:           
            SetupInventory( m_InventoryButtons[0].m_iButtonID  -1);
            break;
        case m_ArrowRightButton:
            SetupInventory( m_InventoryButtons[0].m_iButtonID  +1);
            break;
        case m_InventoryButtons[0]:
        case m_InventoryButtons[1]:
        case m_InventoryButtons[2]:
        case m_InventoryButtons[3]:
            
            m_InventoryButtons[0].m_bSelected=false;
            m_InventoryButtons[1].m_bSelected=false;
            m_InventoryButtons[2].m_bSelected=false;
            m_InventoryButtons[3].m_bSelected=false;
            
            EPCInGameInvButtons(C).m_bSelected=true;                        
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

    C.VideoStop();

    if(nbItems == 0 || !WindowIsVisible())
    {
        m_bGadgetVideoIsPlaying = false;        
    }
    else
    {
        Item = EpcInventory.GetItemInCategory(m_CurrentCategory, currentItem+1);          
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

function ChangeMenuSection( EPCTextButton _SelectMe)
{
    m_sc20kButton.m_bSelected       =  false;
    m_GadgetsButton.m_bSelected     =  false;
    m_ItemsButton.m_bSelected       =  false; 

    m_SelectedButton = _SelectMe;
    m_SelectedButton.m_bSelected    =  true;        

    switch(_SelectMe)
    {
    case m_sc20kButton:        
        m_CurrentCategory            = CAT_MAINGUN;
        break;    
    case m_GadgetsButton:        
        m_CurrentCategory            = CAT_GADGETS;
        break;
    case m_ItemsButton:        
        m_CurrentCategory            = CAT_ITEMS;
        break;
    }
    
    SetCurrentItem(0);
    SetupInventory(0);
}

//Permet de r?initialiser les boutons apr?s un changement de cat?gorie
function SetupInventory( INT _StartPos)
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
   i=_StartPos;   
   for(j=0; j < 4; j++ )
   {       
       if(i < _MaxElements)
       {            
           Item = EpcInventory.GetItemInCategory(m_CurrentCategory, i+1);          

           if(i == m_ISelectedItem)
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
   if( _StartPos > 0)
        m_ArrowLeftButton.bDisabled = false;    
   else 
        m_ArrowLeftButton.bDisabled = true;    

   if(_StartPos + 4 < _MaxElements) //Since we have 4 inv buttons
        m_ArrowRightButton.bDisabled = false;
    else
        m_ArrowRightButton.bDisabled = true;
    
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
}