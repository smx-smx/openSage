namespace OpenSage.Loaders.Big {
	[CCode(cheader_filename = "bigFile.h", cname = "BIG_MAGIC1")]
	public const string BIG_MAGIC1;

	[CCode(cheader_filename = "bigFile.h", cname = "BIG_MAGIC2")]
	public const string BIG_MAGIC2;

	[CCode(cheader_filename = "bigFile.h", cname = "BigEntry")]
	private struct BigEntry {
		uint32 offset;
		uint32 length;
		[CCode(array_null_terminated = true, array_length = false)]
		unowned char[] name;
	}

	[CCode(cheader_filename = "bigFile.h", cname = "BigHeader")]
	private struct BigHeader {
		char magic[4];
		uint32 size;
		uint32 n_files;
		uint32 offset;
		BigEntry[] entries;
	}
}