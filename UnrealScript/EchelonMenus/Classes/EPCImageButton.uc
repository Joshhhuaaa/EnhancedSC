//=============================================================================
// EPCImageButton - Joshua - A button that displays different textures for normal/hover/pressed states
//=============================================================================

class EPCImageButton extends UWindowButton;

var Texture NormalTexture;      // Texture when not interacting
var Texture HoverTexture;       // Texture when mouse is over
var Texture PressedTexture;     // Texture when being clicked
var bool    bStretch;
var bool    bCenter;

function Paint(Canvas C, float X, float Y)
{
    local Texture TextureToDraw;

    if (bMouseDown)
        TextureToDraw = PressedTexture;
    else if (MouseIsOver())
        TextureToDraw = HoverTexture;
    else
        TextureToDraw = NormalTexture;

    if (TextureToDraw != None)
    {
        C.Style = 5; // Alpha
        
        if (bStretch)
            DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, TextureToDraw);
        else if (bCenter)
        {
            // Center the texture if it's not being stretched
            DrawStretchedTexture(C, 
                (WinWidth - TextureToDraw.USize) / 2,
                (WinHeight - TextureToDraw.VSize) / 2,
                TextureToDraw.USize,
                TextureToDraw.VSize,
                TextureToDraw);
        }
        else
            DrawStretchedTexture(C, 0, 0, TextureToDraw.USize, TextureToDraw.VSize, TextureToDraw);
            
        C.Style = 1; // Normal
    }
}

defaultproperties
{
    bStretch=True
    bCenter=True
}
