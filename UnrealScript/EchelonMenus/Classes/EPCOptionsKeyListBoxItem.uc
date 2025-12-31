//=============================================================================
//  EPCOptionsKeyListBoxItem.uc : Items in the list of key mappings
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/27 * Created by Alexandre Dionne
//=============================================================================


class EPCOptionsKeyListBoxItem extends UWindowListBoxItem
                    native;

var bool            m_bisTitle;
var bool            m_bIsNotSelectable;
var string			m_szActionKey;			// the value of the action key in user.ini
var UWindowWindow   m_Control;              // This is to allow drawing a control
var string          HelpText2;              // The alternate key config for this action
var bool            m_bDrawFlipped;         // Hack to invert temporarily PRIM and ALT Key
var bool            bIsCheckBoxLine;        // Not very clean, but will do.

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var bool            bIsCompactLine;        // Joshua - Compact line spacing
var UWindowWindow   m_InfoButton;          // Joshua - Optional info button for tooltips
