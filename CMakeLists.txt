cmake_minimum_required(VERSION 3.0)
list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake/vala
)

set(CMAKE_CXX_FLAGS_TEST "-Ofast")
set(CMAKE_C_FLAGS_TEST "-Ofast -funroll-loops -fprefetch-loop-arrays -march=native")

if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE "Debug")
endif(CMAKE_BUILD_TYPE STREQUAL "")

include(FindVala)
include(UseVala)

## Temporarly use in-tree build of vala
#set(VALA_EXECUTABLE ${CMAKE_SOURCE_DIR}/vala/build/compiler/valac${CMAKE_EXECUTABLE_SUFFIX})
#set(VALA_FLAGS
#    --vapidir ${CMAKE_SOURCE_DIR}/vala/vapi
#)

find_package(Vala REQUIRED)
find_package(OpenGL REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB2 REQUIRED glib-2.0>=2.38)
pkg_check_modules(GIO2 REQUIRED gio-2.0)
pkg_check_modules(GOBJECT2 REQUIRED gobject-2.0>=2.38)
pkg_check_modules(GEE REQUIRED gee-0.8)
pkg_check_modules(SDL2 REQUIRED sdl2)
pkg_check_modules(GLEW REQUIRED glew)
pkg_check_modules(AVCODEC REQUIRED libavcodec)
pkg_check_modules(AVFORMAT REQUIRED libavformat)
pkg_check_modules(AVUTIL REQUIRED libavutil)
pkg_check_modules(SWSCALE REQUIRED libswscale)
pkg_check_modules(SWRESAMPLE REQUIRED libswresample)

find_library(FREEIMAGE_LIBRARY freeimage)

if(CMAKE_COMPILER_IS_GNUCC)
	add_definitions(-Wno-discarded-qualifiers)
endif()

file(GLOB_RECURSE source_list RELATIVE "${CMAKE_SOURCE_DIR}" "src/*.vala")
file(GLOB_RECURSE VAPI_LIST "${CMAKE_SOURCE_DIR}" "vapi/*.vapi")

message(STATUS "Found Sources: ${source_list}")
message(STATUS "Found VAPIs: ${VAPI_LIST}")

set(valac_flags
	-D W3D_DEBUG
)

if(MINGW)
	list(APPEND valac_flags -D MINGW)
endif()

vala_precompile(VALA_C
	${source_list}
PACKAGES
    gio-2.0
    posix
    gee-0.8
OPTIONS
    --disable-warnings
    --thread
    #-g
    ${valac_flags}
    ${VALA_FLAGS}
CUSTOM_VAPIS
    ${VAPI_LIST}
GENERATE_VAPI
    openSage
GENERATE_HEADER
    openSage
)

include_directories(
    ${GLIB2_INCLUDE_DIRS}
    ${GIO2_INCLUDE_DIRS}
    ${GOBJECT2_INCLUDE_DIRS}
    ${GEE_INCLUDE_DIRS}
    ${GLEW_INCLUDE_DIRS}
    ${SDL2_INCLUDE_DIRS}
    ${OPENGL_INCLUDE_DIR}
    ${AVCODEC_INCLUDE_DIRS}
    ${AVFORMAT_INCLUDE_DIRS}
    ${AVUTIL_INCLUDE_DIRS}
    ${SWSCALE_INCLUDE_DIRS}
    ${SWRESAMPLE_INCLUDE_DIRS}
)

link_directories(
    ${GLIB2_LIBRARY_DIRS}
    ${GIO2_LIBRARY_DIRS}
    ${GOBJECT2_LIBRARY_DIRS}
    ${GEE_LIBRARY_DIRS}
    ${GLEW_LIBRARY_DIRS}
    ${SDL2_LIBRARY_DIRS}
    ${SWSCALE_LIBRARY_DIRS}
    ${SWRESAMPLE_LIBRARY_DIRS}
)

add_executable(openSage ${VALA_C})

add_subdirectory(native)
include_directories(native/headers)
include_directories(native/libmfile)

set(opensage_libs
    ${GLIB2_LIBRARIES}
    ${GIO2_LIBRARIES}
    ${GOBJECT2_LIBRARIES}
    ${GEE_LIBRARIES}
    ${GLEW_LIBRARIES}
    ${OPENGL_LIBRARIES}
    ${SDL2_LIBRARIES}
    ${FREEIMAGE_LIBRARY}
    ${AVCODEC_LIBRARIES}
    ${AVFORMAT_LIBRARIES}
    ${AVUTIL_LIBRARIES}
    ${SWSCALE_LIBRARIES}
    ${SWRESAMPLE_LIBRARIES}
    mfile
)

if(MINGW)
	find_library(ExcHndl exchndl)
	list(APPEND opensage_libs ${ExcHndl})
elseif(UNIX)
	find_library(liblm m)
	list(APPEND opensage_libs ${liblm})
endif()

target_link_libraries(openSage ${opensage_libs})

macro(build_cv2pdb)
	set(CV2PDB_DIR ${CMAKE_SOURCE_DIR}/cv2pdb)
	#set(CV2PDB_OUTDIR ${CV2PDB_DIR}/bin/${CMAKE_BUILD_TYPE})
	set(CV2PDB_OUTDIR ${CV2PDB_DIR}/bin)
	set(CV2PDB_EXE ${CV2PDB_OUTDIR}/cv2pdb${CMAKE_EXECUTABLE_SUFFIX})

	# Create a build directory for cv2pdb
	add_custom_target(cv2pdb-make-directory
		ALL
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CV2PDB_OUTDIR}
	)

	add_custom_command(
		DEPENDS cv2pdb-make-directory
		OUTPUT ${CV2PDB_EXE}
		COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ${CV2PDB_DIR}
		COMMAND ${CMAKE_COMMAND} --build .
		WORKING_DIRECTORY ${CV2PDB_OUTDIR}
		COMMENT "Building cv2pdb"
		VERBATIM
	)

	add_custom_target(cv2pdb ALL DEPENDS ${CV2PDB_EXE})
endmacro()

function(run_cv2pdb target exe)
	
	add_custom_command(
		#OUTPUT ${exe}
		TARGET ${target}
		POST_BUILD
		COMMAND cmd //C ${CMAKE_CURRENT_SOURCE_DIR}/cmake/RunAsDev.bat ${CV2PDB_EXE} -C ${exe} ${exe}
		COMMENT "Running cv2pdb for ${target}"
		VERBATIM
	)
	
	#add_custom_target(cv2pdb_${target} ALL DEPENDS ${exe})
	
endfunction()

if(MINGW AND PDB)
		build_cv2pdb()
		
		#get_target_property(openSageExe openSage RUNTIME_OUTPUT_DIRECTORY)
		#set(openSageExe "${openSageExe}/openSage${CMAKE_EXECUTABLE_SUFFIX}")
		run_cv2pdb(openSage $<TARGET_FILE:openSage>)
endif()

add_subdirectory(tools)