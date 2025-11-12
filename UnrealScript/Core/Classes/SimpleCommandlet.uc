class SimpleCommandlet extends Commandlet;

var int intparm;

function int TestFunction()
{
	return 666;
}

function int Main(string Parms)
{
	local int temp;
	local float floattemp;
	local string textstring;
	local string otherstring;

	log("Simple commandlet says hi.");
	log("Testing function calling.");
	temp = TestFunction();
	log("Function call returned" @ temp);
	log("Testing cast to int.");
	floattemp = 3.0;
	temp = int(floattemp);
	log("Temp is cast from "$floattemp$" to "$temp);
	log("Testing min()");
	temp = Min(32, TestFunction());
	log("Temp is min(32, 666): "$Temp);
	textstring = "wookie";
	log("3 is a "$Left(textstring, 3));
	otherstring = "skywalker";
	otherstring = Mid(otherstring, InStr(otherstring, "a"));
	log("otherstring:" @ otherstring);
	return 0;
}

defaultproperties
{
    HelpCmd="Simple"
    HelpOneLiner="Simple test commandlet"
    HelpUsage="Simple (no parameters)"
}