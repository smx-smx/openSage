using Gee;
using MFile;
using Builtins;

namespace OpenSage.Loaders {
	private struct BigEntry {
		uint32 offset;
		uint32 length;
		string name;

		public const int HeaderSize = 8;

		public static BigEntry import(OpenSage.Loaders.Big.BigEntry *data){		
			BigEntry entry = BigEntry();
			entry.offset = bswap32(data.offset);
			entry.length = bswap32(data.length);
			entry.name = (string)data.name;
			entry.name = entry.name.replace("\\", "/").down();
			return entry;
		}
	}

	private struct BigHeader {
		char magic[4];
		uint32 size;
		uint32 n_files;
		uint32 offset;	//start of data
		// end of struct

		string magic_string;

		public const int HeaderSize = 16;
		const string BIG_MAGIC1 = "BIGF";
		const string BIG_MAGIC2 = "BIG4";

		public static BigHeader? import(BigHeader *data){
			char[] _magic = data.magic;
			string magic = (string)_magic;
			if(magic != BIG_MAGIC1 && magic != BIG_MAGIC2)
				return null;

			BigHeader hdr = BigHeader();
			hdr.magic_string = magic;
			hdr.size = data.size;
			hdr.n_files = bswap32(data.n_files);
			hdr.offset = bswap32(data.offset);
			return hdr;
		}
	}
	
	public class BigLoader {
		private HashMap<string, BigEntry?> bigFiles = new HashMap<string, BigEntry?> ();

		private MFILE bigFile;
		
		public BigLoader(){
		}
		
		~BigLoader(){
		}
		
		public unowned uint8[]? getFile(string name){
			if(!bigFiles.has_key(name))
				return null;

			BigEntry entry = bigFiles[name];
			
			uint8* data = bigFile.data();
			
			stdout.printf("Big: Reading %u bytes at @%x\n", entry.length, entry.offset);
			stdout.flush();
			
			unowned uint8[] buf = (uint8[])(data + entry.offset);
			buf.length = (int)entry.length;
			return buf;
		}

		public bool load(string path){
			bigFile = MFILE.open(path, Posix.O_RDONLY);
			uint8* data = bigFile.data();
			
			BigHeader? hdr = BigHeader.import((BigHeader *)data);
			if(hdr == null){
				stdout.printf("'%s' is not a valid BIG file\n", path);
				return false;
			}
							
			stdout.printf("BIG Magic: %s\n", hdr.magic_string);
			stdout.printf("     Size: %u\n", hdr.size);
			stdout.printf("   nFiles: %u\n", hdr.n_files);
			stdout.printf("   offset: %u\n", hdr.offset);
			
			uint offset = BigHeader.HeaderSize;
			for(uint i=0; i<hdr.n_files; i++){
				// Cast to VAPI type required to handle the R/O string properly
				OpenSage.Loaders.Big.BigEntry *pEntry = (OpenSage.Loaders.Big.BigEntry *)(data + offset);
				BigEntry entry = BigEntry.import(pEntry);
				stdout.printf("[%u] %s\n", i, entry.name);

				bigFiles.set(entry.name, entry);

				offset += BigEntry.HeaderSize + entry.name.length + 1;
			}

			stdout.flush();			
			
			return true;
		}
	}
}
