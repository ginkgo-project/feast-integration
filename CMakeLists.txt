cmake_minimum_required(VERSION 3.8)

project(GINKGO_FEAST_INTEGRATION VERSION 0.0.0 LANGUAGES C CXX Fortran)


option(SKIP_DEPENDENCY_UPDATE
       "If set, does not try to download new versions of dependencies"
       OFF)

add_subdirectory(third_party)

add_executable(feast_with_ginkgo_solver
    feast_with_ginkgo_solver.cpp)
add_dependencies(feast_with_ginkgo_solver build_feast)
target_link_libraries(feast_with_ginkgo_solver
    PRIVATE feast ginkgo gflags rapidjson)
