using Vapi.Win32;

namespace OpenSage {
	public class Win32 {
		public static bool LaunchDebugger(){
			//https://stackoverflow.com/a/20387632
			string sysdir = string.nfill(MAX_PATH + 1, 0x00);
			uint nChars = GetSystemDirectory(sysdir, MAX_PATH + 1);
			if(nChars == 0){
				stderr.printf("Failed to obtain system directory\n");
				return false;
			}
			stdout.printf("SystemDirectory: %s\n", sysdir);
			
			uint32 pid = GetCurrentProcessId();
			
			StringBuilder sb = new StringBuilder(sysdir);
			sb.append("\\");
			sb.append("vsjitdebugger.exe -p ");
			sb.append(pid.to_string());
			string cmdline = sb.str;
			
			stdout.printf("Cmdline: %s\n", cmdline);
			
			STARTUPINFO si = STARTUPINFO();
			PROCESS_INFORMATION pi = PROCESS_INFORMATION();
		
			ZeroMemory((PVOID)&pi, sizeof(PROCESS_INFORMATION));
			if(!CreateProcess(
				null, 
				cmdline,
				null,
				null,
				(BOOL)false,
				0,
				null,
				null,
				&si,
				&pi
			)){
				stderr.printf("CreateProcess failed\n");
				return false;
			}
			
			CloseHandle(pi.hThread);
			CloseHandle(pi.hProcess);
			
			while(!IsDebuggerPresent())
				Sleep(100);
			
			DebugBreak();
			return true;
		}
	}
}