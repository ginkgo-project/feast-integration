set(RAPIDJSON_BUILD_DOC OFF CACHE BOOL "" FORCE)
set(RAPIDJSON_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(RAPIDJSON_BUILD_TESTS OFF CACHE BOOL "" FORCE)
load_git_package(rapidjson
    "https://github.com/Tencent/rapidjson.git"
    "73063f5002612c6bf64fe24f851cd5cc0d83eef9")
# Remove directory with questionable licensing
file(REMOVE_RECURSE ${CMAKE_CURRENT_BINARY_DIR}/src/bin/jsonchecker)
add_library(rapidjson INTERFACE IMPORTED GLOBAL)
set_target_properties(rapidjson PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR}/src/include)
