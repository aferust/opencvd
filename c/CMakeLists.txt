cmake_minimum_required(VERSION 2.8)
set (CMAKE_CXX_STANDARD 11)

find_package( OpenCV REQUIRED )

file(GLOB opencv_SRC
    "*.h"
    "*.cpp"
)

set(CMAKE_EXE_LINKER_FLAGS " -lstdc++")

add_subdirectory(contrib)

add_library( opencvcapi STATIC ${opencv_SRC})

target_link_libraries(opencvcapi opencvcapi_contrib ${OpenCV_LIBS} )

