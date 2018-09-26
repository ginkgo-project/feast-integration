set(DEVEL_TOOLS OFF CACHE BOOL "" FORCE)
set(BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(BUILD_BENCHMARKS OFF CACHE BOOL "" FORCE)
set(BUILD_DOC OFF CACHE BOOL "" FORCE)
load_git_package(
    ginkgo
    "https://github.com/ginkgo-project/ginkgo.git"
    "953755b8b3b5418400c5ffd166c9ff0db8437c67")
target_include_directories(ginkgo INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/build/include>
    $<INSTALL_INTERFACE:include>)
