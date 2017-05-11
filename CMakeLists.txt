cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
set(SRC_DIR "./source")

include_directories( ${SRC_DIR} )

AUX_SOURCE_DIRECTORY(${SRC_DIR}/cwraper WRAPER_SRC)
AUX_SOURCE_DIRECTORY(${SRC_DIR}/imgui   IMGUI_SRC )

add_library(imgui STATIC
    ${WRAPER_SRC}
    ${IMGUI_SRC}
)
