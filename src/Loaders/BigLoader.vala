using Gee;
using MFile;
using Builtins;

using OpenSage;

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
			string magic = Utils.chars_to_string(data.magic);

			if(magic != BIG_MAGIC1 && magic != BIG_MAGIC2){
				stderr.printf("'%s' is not a valid BIG magic\n", magic);
				return null;
			}

			BigHeader hdr = BigHeader();
			hdr.magic_string = magic;
			hdr.size = data.size;
			hdr.n_files = bswap32(data.n_files);
			hdr.offset = bswap32(data.offset);
			return hdr;
		}
	}

	public class BigFile {
		private MFILE mf;

		private HashMap<string, BigEntry?> files = new HashMap<string, BigEntry?> ();
		
		public bool load(){		
			uint8* data = mf.data();
			if(data == null){
				stderr.printf("Failed to open BIG file '%s'\n", mf.path());
				return false;
			}
			
			BigHeader? hdr = BigHeader.import((BigHeader *)data);
			if(hdr == null){
				stdout.printf("'%s' is not a valid BIG file\n", mf.path());
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
				//stdout.printf("[%u] %s\n", i, entry.name);

				files.set(entry.name, entry);

				offset += BigEntry.HeaderSize + entry.name.length + 1;
			}

			stdout.flush();			
			
			return true;
		}

		public BigFile(string path){
			mf = MFILE.open(path, Posix.O_RDONLY);
		}
	
		/*
		 * Returns a R/O pointer to the specified file
		 */
		public unowned uint8[]? getFile(owned string name){
			name = name.down(); //perform case insensitive search

			if(!files.has_key(name))
				return null;

			BigEntry entry = files[name];
			
			uint8* data = mf.data();
			
			stdout.printf("Big: Reading %u bytes at @%x\n", entry.length, entry.offset);
			
			//unowned because we want a R/O pointer to it
			unowned uint8[] buf = (uint8[])(data + entry.offset);
			buf.length = (int)entry.length;
			return buf;
		}
	}
	
	public class BigLoader {
		private HashMap<string, BigFile?> bigHandles = new HashMap<string, BigFile?>();
	
		public BigLoader(){
		}
		
		~BigLoader(){
		}

		public unowned uint8[]? getFile(string path){
			foreach(BigFile b in bigHandles.values){
				unowned uint8[]? buf = b.getFile(path);
				if(buf != null)
					return buf;
			}
			return null;
		}

		public bool load(string path){
			if(bigHandles.has_key(path))
				return true;

			BigFile bigFile = new BigFile(path);
			if(!bigFile.load())
				return false;

			bigHandles.set(path, bigFile);
			return true;
		}
	}
}
