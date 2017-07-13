[CCode (cprefix = "", lower_case_cprefix = "", cheader_filename = "FreeImage.h")]
namespace FreeImage {
	public const int FIF_LOAD_NOPIXELS;
	public const int BMP_DEFAULT;
	public const int BMP_SAVE_RLE;
	public const int CUT_DEFAULT;
	public const int DDS_DEFAULT;
	public const int EXR_DEFAULT;
	public const int EXR_FLOAT;
	public const int EXR_NONE;
	public const int EXR_ZIP;
	public const int EXR_PIZ;
	public const int EXR_PXR24;
	public const int EXR_B44;
	public const int EXR_LC;
	public const int FAXG3_DEFAULT;
	public const int GIF_DEFAULT;
	public const int GIF_LOAD256;
	public const int GIF_PLAYBACK;
	public const int HDR_DEFAULT;
	public const int ICO_DEFAULT;
	public const int ICO_MAKEALPHA;
	public const int IFF_DEFAULT;
	public const int J2K_DEFAULT;
	public const int JP2_DEFAULT;
	public const int JPEG_DEFAULT;
	public const int JPEG_FAST;
	public const int JPEG_ACCURATE;
	public const int JPEG_CMYK;
	public const int JPEG_EXIFROTATE;
	public const int JPEG_QUALITYSUPERB;
	public const int JPEG_QUALITYGOOD;
	public const int JPEG_QUALITYNORMAL;
	public const int JPEG_QUALITYAVERAGE;
	public const int JPEG_QUALITYBAD;
	public const int JPEG_PROGRESSIVE;
	public const int JPEG_SUBSAMPLING_411;
	public const int JPEG_SUBSAMPLING_420;
	public const int JPEG_SUBSAMPLING_422;
	public const int JPEG_SUBSAMPLING_444;
	public const int JPEG_OPTIMIZE;
	public const int JPEG_BASELINE;
	public const int KOALA_DEFAULT;
	public const int LBM_DEFAULT;
	public const int MNG_DEFAULT;
	public const int PCD_DEFAULT;
	public const int PCD_BASE;
	public const int PCD_BASEDIV4;
	public const int PCD_BASEDIV16;
	public const int PCX_DEFAULT;
	public const int PFM_DEFAULT;
	public const int PICT_DEFAULT;
	public const int PNG_DEFAULT;
	public const int PNG_IGNOREGAMMA;
	public const int PNG_Z_BEST_SPEED;
	public const int PNG_Z_DEFAULT_COMPRESSION;
	public const int PNG_Z_BEST_COMPRESSION;
	public const int PNG_Z_NO_COMPRESSION;
	public const int PNG_INTERLACED;
	public const int PNM_DEFAULT;
	public const int PNM_SAVE_RAW;
	public const int PNM_SAVE_ASCII;
	public const int PSD_DEFAULT;
	public const int PSD_CMYK;
	public const int PSD_LAB;
	public const int RAS_DEFAULT;
	public const int RAW_DEFAULT;
	public const int RAW_PREVIEW;
	public const int RAW_DISPLAY;
	public const int RAW_HALFSIZE;
	public const int SGI_DEFAULT;
	public const int TARGA_DEFAULT;
	public const int TARGA_LOAD_RGB888;
	public const int TARGA_SAVE_RLE;
	public const int TIFF_DEFAULT;
	public const int TIFF_CMYK;
	public const int TIFF_PACKBITS;
	public const int TIFF_DEFLATE;
	public const int TIFF_ADOBE_DEFLATE;
	public const int TIFF_NONE;
	public const int TIFF_CCITTFAX3;
	public const int TIFF_CCITTFAX4;
	public const int TIFF_LZW;
	public const int TIFF_JPEG;
	public const int TIFF_LOGLUV;
	public const int WBMP_DEFAULT;
	public const int XBM_DEFAULT;
	public const int XPM_DEFAULT;

    public const uint FI_RGBA_RED;
    public const uint FI_RGBA_GREEN;
    public const uint FI_RGBA_BLUE;
    public const uint FI_RGBA_ALPHA;
    public const uint FI_RGBA_RED_MASK;
    public const uint FI_RGBA_GREEN_MASK;
    public const uint FI_RGBA_BLUE_MASK;
    public const uint FI_RGBA_ALPHA_MASK;
    public const uint FI_RGBA_RED_SHIFT;
    public const uint FI_RGBA_GREEN_SHIFT;
    public const uint FI_RGBA_BLUE_SHIFT;
    public const uint FI_RGBA_ALPHA_SHIFT;


    [CCode (cprefix = "FIF_",cname="FREE_IMAGE_FORMAT",type_id="FREE_IMAGE_FORMAT")]
    public enum Format {
       UNKNOWN = -1,
	   BMP		= 0,
	   ICO		= 1,
	   JPEG	= 2,
	   JNG		= 3,
	   KOALA	= 4,
	   LBM		= 5,
	   IFF = LBM,
	   MNG		= 6,
	   PBM		= 7,
	   PBMRAW	= 8,
	   PCD		= 9,
	   PCX		= 10,
	   PGM		= 11,
	   PGMRAW	= 12,
	   PNG		= 13,
	   PPM		= 14,
	   PPMRAW	= 15,
	   RAS		= 16,
	   TARGA	= 17,
	   TIFF	= 18,
	   WBMP	= 19,
	   PSD		= 20,
	   CUT		= 21,
	   XBM		= 22,
	   XPM		= 23,
	   DDS		= 24,
	   GIF     = 25,
	   HDR		= 26,
	   FAXG3	= 27,
	   SGI		= 28,
	   EXR		= 29,
	   J2K		= 30,
	   JP2		= 31,
	   PFM		= 32,
	   PICT	= 33,
	    RAW		= 34;
	    
	    [CCode (cname="FreeImage_FIFSupportsReading")]
	    public bool supports_reading();
	    
//    bool FreeImage_FIFSupportsWriting(FREE_IMAGE_FORMAT fif);
//    bool FreeImage_FIFSupportsExportBPP(FREE_IMAGE_FORMAT fif, int bpp);
//    bool FreeImage_FIFSupportsExportType(FREE_IMAGE_FORMAT fif, Type type);
//    bool FreeImage_FIFSupportsICCProfiles(FREE_IMAGE_FORMAT fif);
//    bool FreeImage_FIFSupportsNoPixels(FREE_IMAGE_FORMAT fif);
    }
        
    [CCode (cprefix = "FIT_",cname="FREE_IMAGE_TYPE",type_id="FREE_IMAGE_TYPE")]
    public enum Type {
        UNKNOWN = 0,	// unknown type
	    BITMAP  = 1,	// standard image			: 1-, 4-, 8-, 16-, 24-, 32-bit
	    UINT16	= 2,	// array of unsigned short	: unsigned 16-bit
	    INT16	= 3,	// array of short			: signed 16-bit
	    UINT32	= 4,	// array of unsigned long	: unsigned 32-bit
	    INT32	= 5,	// array of long			: signed 32-bit
	    FLOAT	= 6,	// array of float			: 32-bit IEEE floating point
	    DOUBLE	= 7,	// array of double			: 64-bit IEEE floating point
	    COMPLEX	= 8,	// array of FICOMPLEX		: 2 x 64-bit IEEE floating point
	    RGB16	= 9,	// 48-bit RGB image			: 3 x 16-bit
	    RGBA16	= 10,	// 64-bit RGBA image		: 4 x 16-bit
	    RGBF	= 11,	// 96-bit RGB float image	: 3 x 32-bit IEEE floating point
	    RGBAF	= 12	// 128-bit RGBA float image	: 4 x 32-bit IEEE floating point
    }
    
    [CCode (cprefix = "FIC_",cname="FREE_IMAGE_COLOR_TYPE",type_id="FREE_IMAGE_COLOR_TYPE")]
    public enum ColorType {
	    MINISWHITE = 0,		// min value is white
        MINISBLACK = 1,		// min value is black
        RGB        = 2,		// RGB color model
        PALETTE    = 3,		// color map indexed
	    RGBALPHA   = 4,		// RGB color model with alpha channel
	    CMYK       = 5		// CMYK color model
    }

    /** Color quantization algorithms.
    Constants used in FreeImage_ColorQuantize.
    */
    [CCode (cprefix = "FIQ_",cname="FREE_IMAGE_QUANTIZE",type_id="FREE_IMAGE_QUANTIZE")]
    public enum Quantize {
        WUQUANT = 0,		// Xiaolin Wu color quantization algorithm
        NNQUANT = 1			// NeuQuant neural-net quantization algorithm by Anthony Dekker
    }

    /** Dithering algorithms.
    Constants used in FreeImage_Dither.
    */
    [CCode (cprefix = "FID_",cname="FREE_IMAGE_DITHER",type_id="FREE_IMAGE_DITHER")]
    public enum Dither {
        FS			= 0,	// Floyd & Steinberg error diffusion
	    BAYER4x4	= 1,	// Bayer ordered dispersed dot dithering (order 2 dithering matrix)
	    BAYER8x8	= 2,	// Bayer ordered dispersed dot dithering (order 3 dithering matrix)
	    CLUSTER6x6	= 3,	// Ordered clustered dot dithering (order 3 - 6x6 matrix)
	    CLUSTER8x8	= 4,	// Ordered clustered dot dithering (order 4 - 8x8 matrix)
	    CLUSTER16x16= 5,	// Ordered clustered dot dithering (order 8 - 16x16 matrix)
	    AYER16x16	= 6		// Bayer ordered dispersed dot dithering (order 4 dithering matrix)
    }
    
    /** Lossless JPEG transformations
    Constants used in FreeImage_JPEGTransform
    */
    [CCode (cprefix = "FIJPEG_OP_",cname="FREE_IMAGE_JPEG_OPERATION",type_id="FREE_IMAGE_JPEG_OPERATION")]
    public enum JpegOperation {
	    NONE			= 0,	// no transformation
	    FLIP_H		= 1,	// horizontal flip
	    FLIP_V		= 2,	// vertical flip
	    TRANSPOSE		= 3,	// transpose across UL-to-LR axis
	    TRANSVERSE	= 4,	// transpose across UR-to-LL axis
	    ROTATE_90		= 5,	// 90-degree clockwise rotation
	    ROTATE_180	= 6,	// 180-degree rotation
	    ROTATE_270	= 7		// 270-degree clockwise (or 90 ccw)
    }

    /** Tone mapping operators.
    Constants used in FreeImage_ToneMapping.
    */
    [CCode (cprefix = "FITMO_",cname="FREE_IMAGE_TMO",type_id="FREE_IMAGE_TMO")]
    public enum ToneMappingOp {
        DRAGO03	 = 0,	// Adaptive logarithmic mapping (F. Drago, 2003)
	    REINHARD05 = 1,	// Dynamic range reduction inspired by photoreceptor physiology (E. Reinhard, 2005)
	    FATTAL02	 = 2	// Gradient domain high dynamic range compression (R. Fattal, 2002)
    }

    /** Upsampling / downsampling filters. 
    Constants used in FreeImage_Rescale.
    */
    [CCode (cprefix = "FILTER_",cname="FREE_IMAGE_FILTER",type_id="FREE_IMAGE_FILTER")]
    public enum Filter {
	    BOX		  = 0,	// Box, pulse, Fourier window, 1st order (constant) b-spline
	    BICUBIC	  = 1,	// Mitchell & Netravali's two-param cubic filter
	    BILINEAR   = 2,	// Bilinear filter
	    BSPLINE	  = 3,	// 4th order (cubic) b-spline
	    CATMULLROM = 4,	// Catmull-Rom spline, Overhauser spline
	    LANCZOS3	  = 5	// Lanczos3 filter
    }

    /** Color channels.
    Constants used in color manipulation routines.
    */
    [CCode (cprefix = "FICC_",cname="FREE_IMAGE_COLOR_CHANNEL",type_id="FREE_IMAGE_COLOR_CHANNEL")]
    public enum ColorChannel {
	    RGB	= 0,	// Use red, green and blue channels
	    RED	= 1,	// Use red channel
	    GREEN	= 2,	// Use green channel
	    BLUE	= 3,	// Use blue channel
	    ALPHA	= 4,	// Use alpha channel
	    BLACK	= 5,	// Use black channel
	    REAL	= 6,	// Complex images: use real part
	    IMAG	= 7,	// Complex images: use imaginary part
	    MAG	= 8,	// Complex images: use magnitude
	    PHASE	= 9		// Complex images: use phase
    }

    // Metadata support ---------------------------------------------------------

    /**
      Tag data type information (based on TIFF specifications)

      Note: RATIONALs are the ratio of two 32-bit integer values.
    */
    [CCode (cprefix = "FIDT_",cname="FREE_IMAGE_MDTYPE",type_id="FREE_IMAGE_MDTYPE")]
    public enum MetadataType {
	    NOTYPE		= 0,	// placeholder 
	    BYTE		= 1,	// 8-bit unsigned integer 
	    ASCII		= 2,	// 8-bit bytes w/ last byte null 
	    SHORT		= 3,	// 16-bit unsigned integer 
	    LONG		= 4,	// 32-bit unsigned integer 
	    RATIONAL	= 5,	// 64-bit unsigned fraction 
	    SBYTE		= 6,	// 8-bit signed integer 
	    UNDEFINED	= 7,	// 8-bit untyped data 
	    SSHORT		= 8,	// 16-bit signed integer 
	    SLONG		= 9,	// 32-bit signed integer 
	    SRATIONAL	= 10,	// 64-bit signed fraction 
	    FLOAT		= 11,	// 32-bit IEEE floating point 
	    DOUBLE		= 12,	// 64-bit IEEE floating point 
	    IFD		= 13,	// 32-bit unsigned integer (offset) 
	    PALETTE	= 14	// 32-bit RGBQUAD 
    }

    /**
      Metadata models supported by FreeImage
    */
    [CCode (cprefix = "FIMD_",cname="FREE_IMAGE_MDMODEL",type_id="FREE_IMAGE_MDMODEL")]
    public enum MetadataModel {
	    NODATA			= -1,
	    COMMENTS		= 0,	// single comment or keywords
	    EXIF_MAIN		= 1,	// Exif-TIFF metadata
	    EXIF_EXIF		= 2,	// Exif-specific metadata
	    EXIF_GPS		= 3,	// Exif GPS metadata
	    EXIF_MAKERNOTE = 4,	// Exif maker note metadata
	    EXIF_INTEROP	= 5,	// Exif interoperability metadata
	    IPTC			= 6,	// IPTC/NAA metadata
	    XMP			= 7,	// Abobe XMP metadata
	    GEOTIFF		= 8,	// GeoTIFF metadata
	    ANIMATION		= 9,	// Animation metadata
	    CUSTOM			= 10,	// Used to attach other metadata types to a dib
	    EXIF_RAW		= 11	// Exif metadata as a raw buffer
    }

    // structs
    [CCode (cname="RGBQUAD")]
    public struct RgbQuad {
        #if FREEIMAGE_COLORORDER == FREEIMAGE_COLORORDER_BGR
          uint8 rgbBlue;
          uint8 rgbGreen;
          uint8 rgbRed;
        #else
          uint8 rgbRed;
          uint8 rgbGreen;
          uint8 rgbBlue;
        #endif
          uint8 rgbReserved;
    }
    
    [CCode (cname="BITMAPINFOHEADER")]
    public struct BitmapInfoHeader {
        uint32 biSize;
        int32  biWidth; 
        int32  biHeight; 
        uint16  biPlanes; 
        uint16  biBitCount;
        uint32 biCompression; 
        uint32 biSizeImage; 
        int32  biXPelsPerMeter; 
        int32  biYPelsPerMeter; 
        uint32 biClrUsed; 
        uint32 biClrImportant;
    }
    
    [CCode (cname="BITMAPINFO")]
    public struct BitmapInfo { 
        BitmapInfoHeader bmiHeader; 
        RgbQuad          bmiColors[1];
    }
    
    [CCode (cname="FIICCPROFILE")]
    public struct ICCProfile { 
        uint16  flags;	// info flag
        uint32  size;	// profile's size measured in bytes
        void   *data;	// points to a block of contiguous memory containing the profile
    }
    
    [CCode (cname="FreeImage_Initialise")]
    public void initialise(bool load_local_plugins_only=false);
    
    [CCode (cname="FreeImage_DeInitialise")]
    public void de_initialise();
    
    /* */
    [CCode (cname="FreeImage_GetVersion")]
    public unowned string get_version();

    [CCode (cname="FreeImage_GetCopyrightMessage")]
    public unowned string get_copyright_message();
    
    [CCode (cname="FreeImage_FreeImageErrorHandler")]
    public delegate void FreeImageErrorHandler(Format fif, string message);
    
    [CCode (cname="FreeImage_SetOutputMessage")]
    public void set_output_message(FreeImageErrorHandler omf);
    
    // Load / Save routines
    [CCode (cname="FreeImage_Load")]
    public Bitmap load(Format fif, string filename, int flags=0);
    
    [CCode (cname="FreeImage_LoadU")]
    public Bitmap load_unicode(Format fif, string filename, int flags = 0);
    
//    [CCode (cname="FreeImage_LoadFromHandle")]
//    public Bitmap load.from_handle(Format fif, FreeImageIO io, fi_handle handle, int flags = 0);

    [CCode (cname="FreeImage_Save")]
    public bool save(Format fif, Bitmap dib, string filename, int flags = 0);

    [CCode (cname="FreeImage_SaveU")]
    public bool save_unicode(Format fif, Bitmap dib, string filename, int flags = 0);

//    [CCode (cname="FreeImage_SaveToHandle")]
//    public bool save.to_handle(Format fif, Bitmap dib, FreeImageIO io, fi_handle handle, int flags = 0);
    
    // Memory I/O stream routines TODO

//    FIMEMORY *FreeImage_OpenMemory(uint8 *data FI_DEFAULT(0), uint32 size_in_bytes FI_DEFAULT(0));
//    void FreeImage_CloseMemory(FIMEMORY *stream);
//    Bitmap FreeImage_LoadFromMemory(FREE_IMAGE_FORMAT fif, FIMEMORY *stream, int flags FI_DEFAULT(0));
//    bool FreeImage_SaveToMemory(FREE_IMAGE_FORMAT fif, Bitmap dib, FIMEMORY *stream, int flags FI_DEFAULT(0));
//    long FreeImage_TellMemory(FIMEMORY *stream);
//    bool FreeImage_SeekMemory(FIMEMORY *stream, long offset, int origin);
//    bool FreeImage_AcquireMemory(FIMEMORY *stream, uint8 **data, uint32 *size_in_bytes);
//    uint FreeImage_ReadMemory(void *buffer, uint size, uint count, FIMEMORY *stream);
//    uint FreeImage_WriteMemory(const void *buffer, uint size, uint count, FIMEMORY *stream);

//    FIMULTIBITMAP *FreeImage_LoadMultiBitmapFromMemory(FREE_IMAGE_FORMAT fif, FIMEMORY *stream, int flags FI_DEFAULT(0));
//    bool FreeImage_SaveMultiBitmapToMemory(FREE_IMAGE_FORMAT fif, FIMULTIBITMAP *bitmap, FIMEMORY *stream, int flags);

//    // Plugin Interface ---------------------------------------------------------

//    FREE_IMAGE_FORMAT FreeImage_RegisterLocalPlugin(FI_InitProc proc_address, const char *format FI_DEFAULT(0), const char *description FI_DEFAULT(0), const char *extension FI_DEFAULT(0), const char *regexpr FI_DEFAULT(0));
//    FREE_IMAGE_FORMAT FreeImage_RegisterExternalPlugin(const char *path, const char *format FI_DEFAULT(0), const char *description FI_DEFAULT(0), const char *extension FI_DEFAULT(0), const char *regexpr FI_DEFAULT(0));
//    int FreeImage_GetFIFCount(void);
//    int FreeImage_SetPluginEnabled(FREE_IMAGE_FORMAT fif, bool enable);
//    int FreeImage_IsPluginEnabled(FREE_IMAGE_FORMAT fif);
//    FREE_IMAGE_FORMAT FreeImage_GetFIFFromFormat(const char *format);
//    FREE_IMAGE_FORMAT FreeImage_GetFIFFromMime(const char *mime);
//    const char *FreeImage_GetFormatFromFIF(FREE_IMAGE_FORMAT fif);
//    const char *FreeImage_GetFIFExtensionList(FREE_IMAGE_FORMAT fif);
//    const char *FreeImage_GetFIFDescription(FREE_IMAGE_FORMAT fif);
//    const char *FreeImage_GetFIFRegExpr(FREE_IMAGE_FORMAT fif);
//    const char *FreeImage_GetFIFMimeType(FREE_IMAGE_FORMAT fif);
    [CCode (cname="FreeImage_GetFIFFromFilename")]
    public Format get_format_from_filename(string filename);
    
    [CCode (cname="FreeImage_GetFIFFromFilenameU")]
    public Format get_format_from_filename_unicode(string filename);

//    // Multipaging interface ----------------------------------------------------

//    FIMULTIBITMAP * FreeImage_OpenMultiBitmap(FREE_IMAGE_FORMAT fif, const char *filename, bool create_new, bool read_only, bool keep_cache_in_memory FI_DEFAULT(FALSE), int flags FI_DEFAULT(0));
//    FIMULTIBITMAP * FreeImage_OpenMultiBitmapFromHandle(FREE_IMAGE_FORMAT fif, FreeImageIO *io, fi_handle handle, int flags FI_DEFAULT(0));
//    bool FreeImage_SaveMultiBitmapToHandle(FREE_IMAGE_FORMAT fif, FIMULTIBITMAP *bitmap, FreeImageIO *io, fi_handle handle, int flags FI_DEFAULT(0));
//    bool FreeImage_CloseMultiBitmap(FIMULTIBITMAP *bitmap, int flags FI_DEFAULT(0));
//    int FreeImage_GetPageCount(FIMULTIBITMAP *bitmap);
//    void FreeImage_AppendPage(FIMULTIBITMAP *bitmap, Bitmap data);
//    void FreeImage_InsertPage(FIMULTIBITMAP *bitmap, int page, Bitmap data);
//    void FreeImage_DeletePage(FIMULTIBITMAP *bitmap, int page);
//    Bitmap  FreeImage_LockPage(FIMULTIBITMAP *bitmap, int page);
//    void FreeImage_UnlockPage(FIMULTIBITMAP *bitmap, Bitmap data, bool changed);
//    bool FreeImage_MovePage(FIMULTIBITMAP *bitmap, int target, int source);
//    bool FreeImage_GetLockedPageNumbers(FIMULTIBITMAP *bitmap, int *pages, int *count);

//    // Filetype request routines ------------------------------------------------
    [CCode (cname="FreeImage_GetFileType")]
    public Format get_file_type (string filename, int size = 0);
    
    [CCode (cname="FreeImage_GetFileTypeU")]
    public Format get_file_type_unicode (string filename, int size = 0);

//    FREE_IMAGE_FORMAT FreeImage_GetFileTypeFromHandle(FreeImageIO *io, fi_handle handle, int size FI_DEFAULT(0));
//    FREE_IMAGE_FORMAT FreeImage_GetFileTypeFromMemory(FIMEMORY *stream, int size FI_DEFAULT(0));

//    // FreeImage helper routines ------------------------------------------------

//    bool FreeImage_IsLittleEndian(void);
//    bool FreeImage_LookupX11Color(const char *szColor, uint8 *nRed, uint8 *nGreen, uint8 *nBlue);
//    bool FreeImage_LookupSVGColor(const char *szColor, uint8 *nRed, uint8 *nGreen, uint8 *nBlue);
    [CCode (cname="FreeImage_ConvertFromRawBits")]
    public Bitmap convert_from_raw_bits(uint8 *bits, int width, int height, int pitch, uint bpp, uint red_mask, uint green_mask, uint blue_mask, bool topdown = false);

//    // Line conversion routines -------------------------------------------------

//    void FreeImage_ConvertLine1To4(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine8To4(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine16To4_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine16To4_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine24To4(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine32To4(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine1To8(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine4To8(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine16To8_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine16To8_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine24To8(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine32To8(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine1To16_555(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine4To16_555(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine8To16_555(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine16_565_To16_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine24To16_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine32To16_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine1To16_565(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine4To16_565(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine8To16_565(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine16_555_To16_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine24To16_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine32To16_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine1To24(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine4To24(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine8To24(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine16To24_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine16To24_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine32To24(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine1To32(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine4To32(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine8To32(uint8 *target, uint8 *source, int width_in_pixels, RGBQUAD *palette);
//    void FreeImage_ConvertLine16To32_555(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine16To32_565(uint8 *target, uint8 *source, int width_in_pixels);
//    void FreeImage_ConvertLine24To32(uint8 *target, uint8 *source, int width_in_pixels);

//    // ZLib interface -----------------------------------------------------------

//    uint32 FreeImage_ZLibCompress(uint8 *target, uint32 target_size, uint8 *source, uint32 source_size);
//    uint32 FreeImage_ZLibUncompress(uint8 *target, uint32 target_size, uint8 *source, uint32 source_size);
//    uint32 FreeImage_ZLibGZip(uint8 *target, uint32 target_size, uint8 *source, uint32 source_size);
//    uint32 FreeImage_ZLibGUnzip(uint8 *target, uint32 target_size, uint8 *source, uint32 source_size);
//    uint32 FreeImage_ZLibCRC32(uint32 crc, uint8 *source, uint32 source_size);

//    // --------------------------------------------------------------------------
//    // Metadata routines --------------------------------------------------------
//    // --------------------------------------------------------------------------

//    // tag creation / destruction
//    FITAG *FreeImage_CreateTag(void);
//    void FreeImage_DeleteTag(FITAG *tag);
//    FITAG *FreeImage_CloneTag(FITAG *tag);

//    // tag getters and setters
//    const char *FreeImage_GetTagKey(FITAG *tag);
//    const char *FreeImage_GetTagDescription(FITAG *tag);
//    uint16 FreeImage_GetTagID(FITAG *tag);
//    FREE_IMAGE_MDTYPE FreeImage_GetTagType(FITAG *tag);
//    uint32 FreeImage_GetTagCount(FITAG *tag);
//    uint32 FreeImage_GetTagLength(FITAG *tag);
//    const void *FreeImage_GetTagValue(FITAG *tag);

//    bool FreeImage_SetTagKey(FITAG *tag, const char *key);
//    bool FreeImage_SetTagDescription(FITAG *tag, const char *description);
//    bool FreeImage_SetTagID(FITAG *tag, uint16 id);
//    bool FreeImage_SetTagType(FITAG *tag, FREE_IMAGE_MDTYPE type);
//    bool FreeImage_SetTagCount(FITAG *tag, uint32 count);
//    bool FreeImage_SetTagLength(FITAG *tag, uint32 length);
//    bool FreeImage_SetTagValue(FITAG *tag, const void *value);

//    // iterator
//    FIMETADATA *FreeImage_FindFirstMetadata(FREE_IMAGE_MDMODEL model, Bitmap dib, FITAG **tag);
//    bool FreeImage_FindNextMetadata(FIMETADATA *mdhandle, FITAG **tag);
//    void FreeImage_FindCloseMetadata(FIMETADATA *mdhandle);

//    // metadata setter and getter
//    bool FreeImage_SetMetadata(FREE_IMAGE_MDMODEL model, Bitmap dib, const char *key, FITAG *tag);
//    bool FreeImage_GetMetadata(FREE_IMAGE_MDMODEL model, Bitmap dib, const char *key, FITAG **tag);

//    // helpers
//    uint FreeImage_GetMetadataCount(FREE_IMAGE_MDMODEL model, Bitmap dib);
//    bool FreeImage_CloneMetadata(FIBITMAP *dst, FIBITMAP *src);

//    // tag to C string conversion
//    const char* FreeImage_TagToString(FREE_IMAGE_MDMODEL model, FITAG *tag, char *Make FI_DEFAULT(NULL));

//    bool FreeImage_JPEGTransform(const char *src_file, const char *dst_file, FREE_IMAGE_JPEG_OPERATION operation, bool perfect FI_DEFAULT(FALSE));
//    bool FreeImage_JPEGTransformU(const wchar_t *src_file, const wchar_t *dst_file, FREE_IMAGE_JPEG_OPERATION operation, bool perfect FI_DEFAULT(FALSE));

//    bool FreeImage_JPEGCrop(const char *src_file, const char *dst_file, int left, int top, int right, int bottom);
//    bool FreeImage_JPEGCropU(const wchar_t *src_file, const wchar_t *dst_file, int left, int top, int right, int bottom);
    
    [Compact]
    [CCode (cname="FIBITMAP", free_function="FreeImage_Unload")]
    public class Bitmap {
        // Allocate / Clone / Unload routines
        
        [CCode (cname="FreeImage_Allocate")]
        public Bitmap(int width, int height, int bpp, 
                        uint red_mask = 0, uint green_mask = 0, uint blue_mask = 0);
        
        [CCode (cname="FreeImage_AllocateT")]
        public Bitmap.with_type(Type type, int width, int height, int bpp=8,
                        uint red_mask = 0, uint green_mask = 0, uint blue_mask = 0);
                        
        [CCode (cname="FreeImage_AllocateEx")]
        public Bitmap.ex (int width, int height, int bpp, RgbQuad *color, int options = 0, RgbQuad *palette = null, uint red_mask = 0, uint green_mask = 0, uint blue_mask = 0);
        
        [CCode (cname="FreeImage_AllocateExT")]
        public Bitmap.ex_with_type (Type type, int width, int height, int bpp, void *color, int options = 0, RgbQuad *palette = null, uint red_mask = 0, uint green_mask = 0, uint blue_mask = 0);

        [CCode (cname="FreeImage_Clone")]
        public Bitmap clone();
        
        // Header loading routines
        [CCode (cname="FreeImage_HasPixels")]
        public bool has_pixels();
        
        // Pixel access routines ----------------------------------------------------
        [CCode (cname="FreeImage_GetBits")]
        public uint8* get_bits();
        
        [CCode (cname="FreeImage_GetScanLine")]
        public uint8* get_scan_line(int scanline);
        
        [CCode (cname="FreeImage_GetPixelIndex")]
        public bool get_pixel_index(uint x, uint y, ref uint8 val);

        [CCode (cname="FreeImage_GetPixelColor")]
        public bool get_pixel_color(uint x, uint y, ref RgbQuad val);
        
        [CCode (cname="FreeImage_SetPixelIndex")]
        public bool set_pixel_index(uint x, uint y, ref uint8 val);

        [CCode (cname="FreeImage_SetPixelColor")]
        public bool set_pixel_color(uint x, uint y, ref RgbQuad val);

        // DIB info routines --------------------------------------------------------
        [CCode (cname="FreeImage_GetImageType")]
        public Type get_image_type();

        [CCode (cname="FreeImage_GetColorsUsed")]
        public uint get_colors_used();
        
        [CCode (cname="FreeImage_GetBPP")]
        public uint get_bpp();
        
        [CCode (cname="FreeImage_GetWidth")]
        public uint get_width();
        
        [CCode (cname="FreeImage_GetHeight")]
        public uint get_height();
        
        [CCode (cname="FreeImage_GetLine")]
        public uint get_line();
        
        [CCode (cname="FreeImage_GetPitch")]
        public uint get_pitch();
        
        [CCode (cname="FreeImage_GetDIBSize")]
        public uint get_dib_size();

        [CCode (cname="FreeImage_GetPalette")]
        public RgbQuad* get_palette ();

        [CCode (cname="FreeImage_GetDotsPerMeterX")]
        public uint get_dots_per_meter_x ();
        
        [CCode (cname="FreeImage_GetDotsPerMeterY")]
        public uint get_dots_per_meter_y ();
        
        [CCode (cname="FreeImage_SetDotsPerMeterX")]
        public void set_dots_per_meter_x (uint res);
        
        [CCode (cname="FreeImage_SetDotsPerMeterY")]
        public void set_dots_per_meter_y (uint res);

        [CCode (cname="FreeImage_GetInfoHeader")]
        public BitmapInfoHeader get_info_header();
        
        [CCode (cname="FreeImage_GetInfo")]
        public BitmapInfo get_info();
        
        [CCode (cname="FreeImage_GetColorType")]
        public ColorType get_color_type();
        
        [CCode (cname="FreeImage_GetRedMask")]
        public uint get_red_mask();
        
        [CCode (cname="FreeImage_GetGreenMask")]
        public uint get_green_mask();
        
        [CCode (cname="FreeImage_GetBlueMask")]
        public uint get_blue_mask();
        
        [CCode (cname="FreeImage_GetTransparencyCount")]
        public uint get_transparency_count();
        
        [CCode (cname="FreeImage_GetTransparencyTable")]
        public uint8* get_transparency_table();
        
        [CCode (cname="FreeImage_SetTransparent")]
        public void set_transparent(bool enabled);

        [CCode (cname="FreeImage_SetTransparencyTable")]
        public void set_transparency_table(uint8* table, int count);
        
        [CCode (cname="FreeImage_IsTransparent")]
        public bool is_transparent();
        
        [CCode (cname="FreeImage_SetTransparentIndex")]
        public void set_transparent_index(int index);

        [CCode (cname="FreeImage_GetTransparentIndex")]
        public int get_transparent_index();
        
        [CCode (cname="FreeImage_HasBackgroundColor")]
        public bool has_background_color();
        
        [CCode (cname="FreeImage_GetBackgroundColor")]
        public bool get_background_color(RgbQuad* bkcolor);
//    bool FreeImage_GetBackgroundColor(RGBQUAD *bkcolor);

        [CCode (cname="FreeImage_SetBackgroundColor")]
        public bool set_background_color(RgbQuad* bkcolor);
        
        [CCode (cname="FreeImage_GetThumbnail")]
        public Bitmap get_thumbnail();
        
        [CCode (cname="FreeImage_SetThumbnail")]
        public bool set_thumbnail(Bitmap thumbnail);
        
        // ICC profile routines -----------------------------------------------------
        [CCode (cname="FreeImage_GetICCProfile")]
        public ICCProfile get_icc_profile();
        
        [CCode (cname="FreeImage_CreateICCProfile")]
        public ICCProfile create_icc_profile(void *data, long size);
        
        [CCode (cname="FreeImage_DestroyICCProfile")]
        public void destroy_icc_profile();
        
        // Smart conversion routines ------------------------------------------------
        [CCode (cname="FreeImage_ConvertTo4Bits")]
        public Bitmap convert_to_4_bits();
        
        [CCode (cname="FreeImage_ConvertTo8Bits")]
        public Bitmap convert_to_8_bits();
        
        [CCode (cname="FreeImage_ConvertToGreyscale")]
        public Bitmap convert_to_greyscale();
        
        [CCode (cname="FreeImage_ConvertTo16Bits555()")]
        public Bitmap convert_to_16_bits_555();
        
        [CCode (cname="FreeImage_ConvertTo16Bits565")]
        public Bitmap convert_to_16_bits_565();
        
        [CCode (cname="FreeImage_ConvertTo24Bits")]
        public Bitmap convert_to_24_bits();
        
        [CCode (cname="FreeImage_ConvertTo32Bits")]
        public Bitmap convert_to_32_bits();
        
        [CCode (cname="FreeImage_ColorQuantize")]
        public Bitmap color_quantize(Quantize quantize);
        
        [CCode (cname="FreeImage_ColorQuantizeEx")]
        public Bitmap color_quantize_ex(Quantize quantize = Quantize.WUQUANT, int palettesize = 256, int reservesize = 0, RgbQuad *reservepalette = null);
        
        [CCode (cname="FreeImage_Threshold")]
        public Bitmap threshold(uint8 t);
        
        [CCode (cname="FreeImage_Dither")]
        public Bitmap dither(Dither algorithm);

        [CCode (cname="FreeImage_ConvertToRawBits", instance_pos=1.9)]
        public void convert_to_raw_bits(uint8 *bits, int pitch, uint bpp, uint red_mask, uint green_mask, uint blue_mask, bool topdown = false);
        
        [CCode (cname="FreeImage_ConvertToFloat")]
        public Bitmap convert_to_float();
        
        [CCode (cname="FreeImage_ConvertToRGBF")]
        public Bitmap convert_to_rgbf();
        
        [CCode (cname="FreeImage_ConvertToUINT16")]
        public Bitmap convert_to_uint16();
        
        [CCode (cname="FreeImage_ConvertToRGB16")]
        public Bitmap convert_to_rgb16();
        
        [CCode (cname="FreeImage_ConvertToStandardType")]
        public Bitmap convert_to_standard_type(bool scale_linear= true);
        
        [CCode (cname="FreeImage_ConvertToType")]
        public Bitmap convert_to_type(Type dst_type, bool scale_linear = true);

        // tone mapping operators
        [CCode (cname="FreeImage_ToneMapping")]
        public Bitmap tone_mapping(ToneMappingOp tmo, double first_param = 0, double second_param = 0);
        
        [CCode (cname="FreeImage_TmoDrago03")]
        public Bitmap tmo_drago03(double gamma = 2.2, double exposure = 0);
        
        [CCode (cname="FreeImage_TmoReinhard05")]
        public Bitmap tmo_reinhard05(double intensity = 0, double contrast = 0);
        
        [CCode (cname="FreeImage_TmoReinhard05Ex")]
        public Bitmap tmo_reinhard05_ex(double intensity = 0, double contrast = 0, double adaptation = 1 , double color_correction = 0);

        [CCode (cname="FreeImage_TmoFattal02")]
        public Bitmap tmo_fattal02(double color_saturation = 0.5, double attenuation = 0.85);
        
        // --------------------------------------------------------------------------
        // Image manipulation toolkit -----------------------------------------------
        // --------------------------------------------------------------------------

        // rotation and flipping
        /// @deprecated see Rotate
//        Bitmap RotateClassic(double angle);
        [CCode (cname="FreeImage_Rotate")]
        public Bitmap rotate(double angle, void *bkcolor = null);
        
        [CCode (cname="FreeImage_RotateEx")]
        public Bitmap rotate_ex(double angle, double x_shift, double y_shift, double x_origin, double y_origin, bool use_mask);
        
        [CCode (cname="FreeImage_FlipHorizontal")]
        public bool flip_horizontal();
        
        [CCode (cname="FreeImage_FlipVertical")]
        public bool flip_vertical();
        
        // upsampling / downsampling
        [CCode (cname="FreeImage_Rescale")]
        public Bitmap rescale(int dst_width, int dst_height, Filter filter);
        
        [CCode (cname="FreeImage_MakeThumbnail")]
        public Bitmap make_thumbnail(int max_pixel_size, bool convert = true);

        // color manipulation routines (point operations)
        [CCode (cname="FreeImage_AdjustCurve")]
        public bool adjust_curve(uint8 *lut, ColorChannel channel);
        
        [CCode (cname="FreeImage_AdjustGamma")]
        public bool adjust_gamma(double gamma);
        
        [CCode (cname="FreeImage_AdjustBrightness")]
        public bool adjust_brightness(double percentage);
        
        [CCode (cname="FreeImage_AdjustContrast")]
        public bool adjust_contrast(double percentage);
        
        [CCode (cname="FreeImage_Invert")]
        public bool invert();
        
        [CCode (cname="FreeImage_GetHistogram")]
        public bool get_histogram(uint32 *histo, ColorChannel channel = ColorChannel.BLACK);
        
        [CCode (cname="FreeImage_GetAdjustColorsLookupTable")]
        public int get_adjust_colors_lookup_table(uint8 *lut, double brightness, double contrast, double gamma, bool invert);
        
        [CCode (cname="FreeImage_AdjustColors")]
        public bool adjust_colors(double brightness, double contrast, double gamma, bool invert = false);
        
        [CCode (cname="FreeImage_ApplyColorMapping")]
        public uint apply_color_mapping(RgbQuad *srccolors, RgbQuad *dstcolors, uint count, bool ignore_alpha, bool swap);
        
        [CCode (cname="FreeImage_SwapColors")]
        public uint swap_colors(RgbQuad *color_a, RgbQuad *color_b, bool ignore_alpha);
        
        [CCode (cname="FreeImage_ApplyPaletteIndexMapping")]
        public uint apply_palette_index_mapping(uint8 *srcindices, uint8 *dstindices, uint count, bool swap);
        
        [CCode (cname="FreeImage_SwapPaletteIndices")]
        public uint swap_palette_indices(uint8 *index_a, uint8 *index_b);

        // channel processing routines
        [CCode (cname="FreeImage_GetChannel")]
        public Bitmap get_channel(ColorChannel channel);
        
        [CCode (cname="FreeImage_SetChannel")]
        public bool set_channel(Bitmap src, ColorChannel channel);
        
        [CCode (cname="FreeImage_GetComplexChannel")]
        public Bitmap get_complex_channel(ColorChannel channel);
        
        [CCode (cname="FreeImage_SetComplexChannel")]
        public bool set_complex_channel(Bitmap src, ColorChannel channel);

        // copy / paste / composite routines
        [CCode (cname="FreeImage_Copy")]
        public Bitmap copy(int left, int top, int right, int bottom);
        
        [CCode (cname="FreeImage_Paste")]
        public bool paste(Bitmap src, int left, int top, int alpha);
        
        [CCode (cname="FreeImage_Composite")]
        public Bitmap composite(bool useFileBkg = false, RgbQuad *appBkColor = null, Bitmap? bg = null);
        
        [CCode (cname="FreeImage_PreMultiplyWithAlpha")]
        public bool pre_multiply_with_alpha();

        // background filling routines
        [CCode (cname="FreeImage_FillBackground")]
        public bool fill_background(void *color, int options = 0);
        
        [CCode (cname="FreeImage_EnlargeCanvas")]
        public Bitmap enlarge_canvas(int left, int top, int right, int bottom, void *color, int options = 0);

        // miscellaneous algorithms
        [CCode (cname="FreeImage_MultigridPoissonSolver")]
        public Bitmap multigrid_poisson_solver(int ncycle = 3);
    }
}
