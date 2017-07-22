[CCode(cheader_filename = "exchndl.h")]
namespace MingwExceptionHandler {
	[CCode(cname = "ExcHndlInit")]
	public static void init();
	
	[CCode(cname = "ExcHndlSetLogFileNameA")]
	public static bool set_logfile(string logFileName);
}