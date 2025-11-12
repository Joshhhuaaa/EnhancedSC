//=============================================================================
/// UnrealScript Commandlet (command-line applet) class.
///
/// Commandlets are executed from the ucc.exe command line utility, using the
/// following syntax:
///
///     UCC.exe package_name.commandlet_class_name [parm=value]...
///
/// for example:
///
///     UCC.exe Core.HelloWorldCommandlet
///     UCC.exe Editor.MakeCommandlet
///
/// In addition, if you list your commandlet in the public section of your
/// package's .int file (see Engine.int for example), then your commandlet
/// can be executed without requiring a fully qualified name, for example:
///
///     UCC.exe MakeCommandlet
///
/// As a convenience, if a user tries to run a commandlet and the exact
/// name he types isn't found, then ucc.exe appends the text "commandlet"
/// onto the name and tries again.  Therefore, the following shortcuts
/// perform identically to the above:
///
///     UCC.exe Core.HelloWorld
///     UCC.exe Editor.Make
///     UCC.exe Make
///
/// It is also perfectly valid to call the Main method of a
/// commandlet class directly, for example from within the body
/// of another commandlet.
///
/// Commandlets are executed in a "raw" UnrealScript environment, in which
/// the game isn't loaded, the client code isn't loaded, no levels are
/// loaded, and no actors exist.
//=============================================================================
class Commandlet
	extends Object
	abstract
	transient
	noexport
	native;

/// Command name to show for "ucc help".
var localized string HelpCmd;

/// Command description to show for "ucc help".
var localized string HelpOneLiner;

/// Usage template to show for "ucc help".
var localized string HelpUsage;

/// Hyperlink for more info.
var localized string HelpWebLink;

/// Parameters and descriptions for "ucc help <this command>".
var localized string HelpParm[16];
var localized string HelpDesc[16];

/// Whether to redirect log output to console stdout.
var bool LogToStdout;

/// Whether to load objects required in server, client, and editor context.
var bool IsServer, IsClient, IsEditor;

/// Whether to load objects immediately, or only on demand.
var bool LazyLoad;

/// Whether to show standard error and warning count on exit.
var bool ShowErrorCount;

/// Whether to show Unreal banner on startup.
var bool ShowBanner;

/// Entry point.
native event int Main(string Parms);

defaultproperties
{
    LogToStdout=true
    IsServer=true
    IsClient=true
    IsEditor=true
    LazyLoad=true
    ShowBanner=true
}