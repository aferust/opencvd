cmake_minimum_required(VERSION 2.8)
set (CMAKE_CXX_STANDARD 11)

file(GLOB opencvd_SRC
    "*.h"
    "*.cpp"
)

if (MSVC)
    include( $ENV{OpenCV_DIR}/OpenCVConfig.cmake )
    message( STATUS "OpenCV library status:" )
    message( STATUS "    version: ${OpenCV_VERSION}" )
    message( STATUS "    libraries: ${OpenCV_LIBS}" )
    message( STATUS "    include path: ${OpenCV_INCLUDE_DIRS}" )
    include_directories( ${OpenCV_INCLUDE_DIRS} )
    add_subdirectory(contrib)
    add_library( opencvcapi STATIC ${opencvd_SRC})
    target_link_libraries(opencvcapi opencvcapi_contrib ${OpenCV_LIBS})
endif (MSVC)

if (UNIX)
    find_package( OpenCV REQUIRED )
    set(CMAKE_EXE_LINKER_FLAGS " -lstdc++")
    add_subdirectory(contrib)
    add_library( opencvcapi STATIC ${opencvd_SRC})
    target_link_libraries(opencvcapi opencvcapi_contrib ${OpenCV_LIBS})
endif (UNIX)


