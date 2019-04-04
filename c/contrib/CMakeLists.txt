
file(GLOB opencv_contrib_SRC
    "*.h"
    "*.cpp"
)

set(CMAKE_EXE_LINKER_FLAGS " -lstdc++")

add_library( opencvcapi_contrib STATIC ${opencv_contrib_SRC})

target_link_libraries(opencvcapi_contrib ${OpenCV_LIBS} )

