//=============================================================================
/// Time-management class.
/// Not yet implemented.
/// This is a built-in Unreal class and it shouldn't be modified.
///
/// Coordinated Universal Time or UCT is the world standard time 
/// representation which is independent of time zone and daylight
/// savings time.  The UCT standard supercedes the obsolete Grenwich
/// Mean Time (GMT).
///
/// UCT is technically the time on the zeroth meridian plus 12 hours.
/// For example, to convert UCT to EST (Eastern Standard Time), subtract 
/// 5 hours from UCT and then (??if dst).
///
/// By definition, UCT experiences a discontinuity when a leap second 
/// is reached. However, this discontinuity is never exposed while Unreal is
/// running, as UCT is determined at startup time, and UCT is updated
/// continuously during gameplay according to the CPU clock.
///
/// Unreal time is exposed as a long (a 64-bit signed quantity) and
/// is defined as nanoseconds elapsed since 
/// midnight (00:00:00), January 1, 1970.
///
/// For more information about UCT and time, see
///  http://www.bldrdoc.gov/timefreq/faq/faq.htm
///  http://www.boulder.nist.gov/timefreq/glossary.htm
///  http://www.jat.org/jtt/datetime.html
///  http://www.eunet.pt/ano2000/gen_8601.htm
//=============================================================================
class Time
	extends Object
	transient;

/*
/// Returns current globally-consistent Coordinated Universal Time.
static final function long GetGlobalTime();

/// Converts global time to local time, taking into account the
/// local timezone and daylight savings time.
static final function long GlobalToLocal();

/// Converts local time to global time, taking into account the
/// local timezone and daylight savings time.
static final function long LocalToGlobal();

/// Return nanoseconds part of Time, 0-999.
static final invariant function long GetNSecs( long Time );

/// Returns microseconds part of Time, 0-999.
static final invariant function long GetUSecs( long Time );

/// Returns milliseconds part of Time, 0-999.
static final invariant function long GetMSecs( long Time );

/// Returns seconds part of Time, 0-59.
static final invariant function long GetSeconds( long Time );

/// Returns minutes part of Time, 0-59.
static final invariant function long GetMinutes( long Time );

/// Returns hours part of Time, 0-23.
static final invariant function long GetHours( long Time );

/// Returns days part of Time, 0 (first day of month)-31 (or last day, depends on month)
static final invariant function long GetDays( long Time );

/// Return day of week, 0 (Sunday)-6 (Saturday)
static final invariant function long DayOfWeek( long Time );

/// Return months part of Time, 0 (January) - 11 (December)
static final invariant function long GetMonths( long Time );

/// Return year.
static final invariant function long GetYears( long Time );

/// Convert the difference between times Later and Earlier to
/// a floating point value expressed in seconds.
static final invariant function float SpanSeconds( long Later, long Earlier );
*/
