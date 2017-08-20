[CCode(cheader_filename = "windows.h")]
namespace Vapi.Win32 {
	/*** Types ***/
	[SimpleType, CCode(cname = "BYTE")]
	public struct BYTE : uint8 {}
	
	[SimpleType, CCode(cname = "BOOL")]
	public struct BOOL : bool {}
	
	[SimpleType, CCode(cname = "WORD")]
	public struct WORD : uint16 {}
	
	[SimpleType, CCode(cname = "DWORD")]
	public struct DWORD : uint32 {}
	
	[SimpleType, CCode(cname = "CHAR")]
	public struct CHAR : char {}
	
	[SimpleType, CCode(cname = "VOID")]
	public struct VOID {}
	
	[SimpleType, CCode(cname = "PVOID")]
	public struct PVOID {}
	[SimpleType, CCode(cname = "LPVOID")]
	public struct LPVOID {}
	
	[SimpleType, CCode(cname = "HANDLE")]
	public struct HANDLE : PVOID {}
	
	[SimpleType, CCode(cname = "LPBYTE")]
	public struct LPBYTE {}
	
	[SimpleType, CCode(cname = "SIZE_T")]
	public struct SIZE_T : size_t {}
	
	
	[SimpleType, CCode(cname = "LPSTR")]
	public struct LPSTR : char {}
	
	[SimpleType, CCode(cname = "LPCSTR")]
	public struct LPCSTR : char {}
	
	// NOTE: Assuming ANSI right now
	[SimpleType, CCode(cname = "LPTSTR")]
	public struct LPTSTR {}
	[SimpleType, CCode(cname = "LPCTSTR")]
	public struct LPCTSTR {}
	
	/*** Constants ***/
	
	[CCode(cname = "MAX_PATH")]
	public const int MAX_PATH;

	/*** Structs ***/
	
	[CCode(cname = "SECURITY_ATTRIBUTES")]
	public struct SECURITY_ATTRIBUTES {
		DWORD  nLength;
		LPVOID lpSecurityDescriptor;
		BOOL   bInheritHandle;
	}
	
	[CCode(cname = "PSECURITY_ATTRIBUTES")]
	public struct PSECURITY_ATTRIBUTES {}
	[CCode(cname = "LPSECURITY_ATTRIBUTES")]
	public struct LPSECURITY_ATTRIBUTES {}
	
	[CCode(cname = "STARTUPINFO")]
	public struct STARTUPINFO {
		DWORD  cb;
		LPTSTR lpReserved;
		LPTSTR lpDesktop;
		LPTSTR lpTitle;
		DWORD  dwX;
		DWORD  dwY;
		DWORD  dwXSize;
		DWORD  dwYSize;
		DWORD  dwXCountChars;
		DWORD  dwYCountChars;
		DWORD  dwFillAttribute;
		DWORD  dwFlags;
		WORD   wShowWindow;
		WORD   cbReserved2;
		LPBYTE lpReserved2;
		HANDLE hStdInput;
		HANDLE hStdOutput;
		HANDLE hStdError;
	}
	
	[CCode(cname = "LPSTARTUPINFO")]
	public struct LPSTARTUPINFO : STARTUPINFO {}
		
	[CCode(cname = "PROCESS_INFORMATION")]
	public struct PROCESS_INFORMATION {
		HANDLE hProcess;
		HANDLE hThread;
		DWORD  dwProcessId;
		DWORD  dwThreadId;
	}
	
	[CCode(cname = "LPPROCESS_INFORMATION")]
	public struct LPPROCESS_INFORMATION : PROCESS_INFORMATION {}
	
	/*** Functions ***/
	
	[CCode(cname = "GetSystemDirectory")]
	public uint GetSystemDirectory(string lpbuffer, uint uSize);
	
	[CCode(cname = "GetCurrentProcessId")]
	public DWORD GetCurrentProcessId();
	
	[CCode(cname = "DebugBreak")]
	public void DebugBreak();
	
	[CCode(cname = "ZeroMemory")]
	public void ZeroMemory(PVOID Destination, SIZE_T Length);
	
	[CCode(cname = "CreateProcess")]
	public BOOL CreateProcess(
		LPCTSTR?               lpApplicationName,
		string                lpCommandLine,
		LPSECURITY_ATTRIBUTES? lpProcessAttributes,
		LPSECURITY_ATTRIBUTES? lpThreadAttributes,
		BOOL                  bInheritHandles,
		DWORD                 dwCreationFlags,
		LPVOID?                lpEnvironment,
		LPCTSTR?               lpCurrentDirectory,
		STARTUPINFO*         lpStartupInfo,
		PROCESS_INFORMATION* lpProcessInformation
	);
	
	[CCode(cname = "CloseHandle")]
	public BOOL CloseHandle(HANDLE hObject);
	
	[CCode(cname = "IsDebuggerPresent")]
	public BOOL IsDebuggerPresent();
	
	[CCode(cname = "Sleep")]
	public VOID Sleep(DWORD dwMilliseconds);
}