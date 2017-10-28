file(GLOB_RECURSE source_list RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "*.vala")

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
CUSTOM_VAPIS
    ${VAPI_LIST}
GENERATE_VAPI
    iniparser
GENERATE_HEADER
    iniparser
)

add_executable(iniparser ${VALA_C})
target_link_libraries(iniparser
	${GLIB2_LIBRARIES}
    ${GIO2_LIBRARIES}
    ${GOBJECT2_LIBRARIES}
    ${GEE_LIBRARIES}
	mfile
)
