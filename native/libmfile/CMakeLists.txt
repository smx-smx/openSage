set(sources mfile.c)
if (WIN32)
	list(APPEND sources win32/mman.c)
endif()

add_library(mfile ${sources})
