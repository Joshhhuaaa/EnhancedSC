class EEmpty extends EPattern;

state Pattern
{

Begin:
	Sleep(2);
	Jump('Begin');
}
