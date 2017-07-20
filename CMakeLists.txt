cmake_minimum_required(VERSION 3.0)
list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake/vala
)

if(CMAKE_BUILD_TYPE STREQUAL "")
	set(CMAKE_BUILD_TYPE "Debug")
endif(CMAKE_BUILD_TYPE STREQUAL "")

include(FindVala)
include(UseVala)

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

add_definitions(-Wno-discarded-qualifiers)

file(GLOB_RECURSE source_list RELATIVE "${CMAKE_SOURCE_DIR}" "src/*.vala")
file(GLOB_RECURSE vapi_list RELATIVE "${CMAKE_SOURCE_DIR}" "vapi/*.vapi")

message(STATUS "Found Sources: ${source_list}")
message(STATUS "Found VAPIs: ${vapi_list}")

vala_precompile(VALA_C
	${source_list}
PACKAGES
    gio-2.0
    posix
    gee-0.8
OPTIONS
    --thread
CUSTOM_VAPIS
    ${vapi_list}
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

target_link_libraries(openSage
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