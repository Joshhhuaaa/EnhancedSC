//=============================================================================
/// Locale: Locale management class.
/// Not yet implemented.
/// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Locale
	extends Object
	transient;

/*
//
// Information about this locale.
//

//!!System.GetLocale(language, variant, local)
///@reference: !!look at java getISO3Language for std 3-char language abbreviations
var const string ISO3Language;
var const localized string DisplayLanguage;

//
// Locale language support.
//

/// Returns the currently active language's ISO 3 language code.
native function string GetLanguage();

/// Returns the localized, human-readable display name of the ISO 3 language code Language.
native function string GetDisplayLanguage(string Language);

/// Set the current ISO 3 language. Causes all class' and objects' localized variables to be reloaded.
native function bool SetLanguage(string NewLanguage);

//
// Locale string processing.
//

/// Convert to locale-specific uppercase.
function string ToUpper(string S);

/// Convert to locale-specific lowercase.
function string ToLower(string S);

/// Compare two strings using locale-specific sorting.
function int Compare(string A, string B);

//
// Locale number and currency handling.
//

/// Leading and trailing percentage symbols.
var const localized string PrePercent, PostPercent;

/// Leading and trailing currency symbols.
var const localized string PreCurrencySymbol, PostCurrencySymbol;

/// Percentage scale, i.e. 100 for 100%.
var const localized int PercentScaler;

/// Number of digits between "thousands" delimitor.
var const localized int ThousandsCount, ThousandsCountCurrency;

/// Positive and negative currency indicators.
var const localized string
	PrePositiveCurrency, PostPositiveCurrency,
	PreNegativeCurrency, PostNegativeCurrency;

// Thousands delimitor.
var const localized string ThousandsDelimitor, ThousandsDelimitorCurrency;

// Decimal point.
var const localized string Decimal, DecimalCurrency;

// Decimal count.
var const localized int DecimalCount;

/// Convert a float number to a string using the locale's formatting instructions.
function string NumberToString(float Number);

/// Convert a float number to a currency string using the locale's formatting instructions.
function string CurrencyToString(float Currency);

/// Convert a fraction from 0.0-1.0 to a percentage string.
function string PercentToString(float Fraction)
{
	return PrePercent $ int(Fraction * PercentScaler) $ PostPercent;
}

//
// Locale date and time support.
//

/// Human readable names of months.
var const localized string Months[12];

/// Human readable names of days-of-week.
var const localized string DaysOfWeek[7];

/// Human-readable AM/PM.
var const localized string AMPM[2];

/// Whether to display AM/PM, otherwise uses 24-hour notation.
var const localized ShowAMPM;

/// List of TimeToMap fields which should be exposed for editing in this locale.
var const localized array<string> EditableTimeFields;

/// Format string for generating human-readable time in AM/PM and 24-hour formats;
/// may be ignored by Locale subclasses who display times using a different calendar,
/// for example Chinese.
var const localized string
	TimeFormatAMPM, TimeFormat24Hour,
	BriefTimeFormatAMPM, BriefTimeFormat24Hour,
	CountdownTimeFormat;

/// Format string for generating human-readable dates.
var const localized string DateFormat;

/// Return a map containing time parameters suitable for formatting.
function map<string,string> DateTimeToMap(long T)
{
	local map<string,string> M;
	M.Set("Year",       Time.GetYear(T));
	M.Set("Month",      Time.GetMonth(T));
	M.Set("MonthName",  Months(Time.GetMonth(T)));
	M.Set("Day",        Time.GetDay(T));
	M.Set("DayName",    DaysOfWeek(Time.GetDay(T)));
	M.Set("Hour24",     Time.GetHour(T));
	M.Set("Hour12",     Time.GetHour(T) % 12);
	M.Set("AMPM",       AMPM(Time.GetHour(T) / 12);
	M.Set("Minute",     Time.GetMinute(T));
	M.Set("Second",     Time.GetSecond(T));
	M.Set("MSec",       Time.GetMSec(T));
	M.Set("USec",       Time.GetUSec(T));
	M.Set("NSec",       Time.GetNSec(T));
	return M;
}

/// Convert a map of TimeToMap key-values to a time; returns true if successful.
function bool MapToDateTime(map<string,string> Map, out long T)
{
	//!!
}

/// Converts the time to a human-readable string, depending on the current locale.
function string TimeToString(long T, bool Brief, bool Countdown)
{
	local string S;
	if (Brief)
	{
		if (ShowAMPM) S = BriefTimeFormatAMPM;
		else           S = BriefTimeFormat24Hour,
	}
	else if (!Countdown)
	{
		if (ShowAMPM) S = TimeFormatAMPM;
		else           S = TimeFormat24Hour,
	}
	else
	{
		S = CountdownTimeFormat;
	}
	return string.Format(S, DateTimeToMap(T));
}

// Convert the date to a human-readable string, depending on the current locale.
function string DateToString(long T)
{
	return string.Format(DateFormat, DateTimeToMap(T));
}

_defaultproperties
{
	Months(0)=January
	Months(1)=February
	Months(2)=March
	Months(3)=April
	Months(4)=May
	Months(5)=June
	Months(6)=July
	Months(7)=August
	Months(8)=September
	Months(9)=October
	Months(10)=November
	Months(11)=December
	DaysOfWeek(0)=Sunday
	DaysOfWeek(1)=Monday
	DaysOfWeek(2)=Tuesday
	DaysOfWeek(3)=Wednesday
	DaysOfWeek(4)=Thursday
	DaysOfWeek(5)=Friday
	DaysOfWeek(6)=Saturday
	AMPM(0)=AM
	AMPM(1)=PM
	TimeFormatAMPM=%Hour12:02%.%Minute:02%.%Seconds:02% %AMPM%
	TimeFormat24Hour=%Hour24:02%.%Minute:02%.%Seconds:02%
	BriefTimeFormatAMPM=%Hour12:02%.%Minute:02% %AMPM%
	BriefTimeFormat24Hour=%Hour24:02%.%Minute:02%
	CountdownTimeFormat=%Hour24:02%.%Minute:02%.%Seconds:02%
	DateFormat=%DayName% %MonthName% %Day%, %Year%
	EditableTimeFields(0)=Year
	EditableTimeFields(1)=Month
	EditableTimeFields(2)=Day
	EditableTimeFields(3)=Hour12
	EditableTimeFields(4)=AMPM
	EditableTimeFields(5)=Minute
	EditableTimeFields(6)=Second
	PreCurrencySymbol=$
	PostCurrencySymbol=
	PrePercent=
	PostPercent=%
	PercentScaler=100
	ThousandsCount=1000
	ThousandsCountCurrency=1000
	ThousandsDelimitor=","
	ThousandsDelimitorCurrency=","
	Decimal="."
	DecimalCurrency="."
	PrePositiveCurrency=
	PostPositiveCurrency=
	PreNegativeCurrency=-
	PostNegativeCurrency=
	DecimalCount=2
}
*/
