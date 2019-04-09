
file(GLOB opencvd_contrib_SRC
    "*.h"
    "*.cpp"
)

if (MSVC)
    include_directories( ${OpenCV_INCLUDE_DIRS} )
    add_library( opencvcapi_contrib STATIC ${opencvd_contrib_SRC})
    target_link_libraries(opencvcapi_contrib ${OpenCV_LIBS})
endif (MSVC)

if (UNIX)
    set(CMAKE_EXE_LINKER_FLAGS " -lstdc++")
    add_library( opencvcapi_contrib STATIC ${opencvd_contrib_SRC})
    target_link_libraries(opencvcapi_contrib ${OpenCV_LIBS})
endif (UNIX)
