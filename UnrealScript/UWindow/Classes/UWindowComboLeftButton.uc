class UWindowComboLeftButton extends UWindowButton;

function Created()
{
    Super.Created();
    LookAndFeel.Combo_SetupLeftButton(Self);
}   

function LMouseDown(float X, float Y)
{
	local int i;

	Super.LMouseDown(X, Y);
	if(!bDisabled)
	{
		i = UWindowComboControl(OwnerWindow).GetSelectedIndex();
		i--;
		if(i < 0)
			i = UWindowComboControl(OwnerWindow).List.Items.Count() - 1;
		UWindowComboControl(OwnerWindow).SetSelectedIndex(i);
	}
}

