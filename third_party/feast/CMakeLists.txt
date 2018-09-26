cmake_minimum_required(VERSION 3.8)
project(FEAST VERSION 3.0 LANGUAGES C Fortran)

option(FEAST_BUILD_EXAMPLES "Set to ON to build FEAST's examples" OFF)


find_package(LAPACK REQUIRED)


# copy source to build directory and configure FEAST's build system
file(COPY ${PROJECT_SOURCE_DIR}/src DESTINATION ${PROJECT_BINARY_DIR})
string(TOUPPER "${CMAKE_BUILD_TYPE}" BUILD_TYPE_STRING)

set(COMPILER_FLAGS
    "${CMAKE_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_${BUILD_TYPE_STRING}}")
if (CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    set(EXTRA_FLAGS "-openmp -fpp")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    set(EXTRA_FLAGS 
        "-openmp -ffree-line-length-none -ffixed-line-length-none -cpp")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
    set(EXTRA_FLAGS "-mp -Mcpp")
endif()
file(WRITE ${PROJECT_BINARY_DIR}/src/make.inc
     "OPTION=1\n"
     "F90=${CMAKE_Fortran_COMPILER}\n"
     "F90FLAGS=${COMPILER_FLAGS} ${EXTRA_FLAGS}\n")

# add a target which builds FEAST
add_custom_target(build_feast
    COMMAND make "ARCH=" "LIB=feast" all
    WORKING_DIRECTORY "${PROJECT_BINARY_DIR}/src")

# expose built libraries as targets
add_library(feast STATIC IMPORTED GLOBAL)
add_dependencies(feast build_feast)
set_target_properties(feast PROPERTIES
    IMPORTED_LINK_INTERFACE_LANGUAGES Fortran
    IMPORTED_LOCATION ${PROJECT_BINARY_DIR}/lib/libfeast.a
    INTERFACE_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/include
    INTERFACE_LINK_LIBRARIES "${LAPACK_LIBRARIES}")

function(add_feast_library name)
    add_library(feast_${name} STATIC IMPORTED GLOBAL)
    add_dependencies(feast_${name} build_feast)
    set_target_properties(feast_${name} PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES Fortran
        IMPORTED_LOCATION ${PROJECT_BINARY_DIR}/lib/libfeast_${name}.a
        INTERFACE_INCLUDE_DIRECTORIES ${PROJECT_SOURCE_DIR}/include)
    target_link_libraries(feast_${name} INTERFACE feast)
endfunction()

add_feast_library(dense)
add_feast_library(sparse)
add_feast_library(banded)


# build examples
if(FEAST_BUILD_EXAMPLES)
    file(COPY ${PROJECT_SOURCE_DIR}/example/Hermitian/system1
         DESTINATION ${PROJECT_BINARY_DIR})
    file(COPY ${PROJECT_SOURCE_DIR}/example/Hermitian/system2
         DESTINATION ${PROJECT_BINARY_DIR})
    file(COPY ${PROJECT_SOURCE_DIR}/example/Non-Hermitian/system3
         DESTINATION ${PROJECT_BINARY_DIR})
    file(COPY ${PROJECT_SOURCE_DIR}/example/Non-Hermitian/system4
         DESTINATION ${PROJECT_BINARY_DIR})

    function(add_dense_example type name)
        add_executable(${name}
            example/${type}/C/1_dense/${name}.c)
        set_target_properties(${name} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY C/1_dense)
        add_dependencies(${name} build_feast)
        target_link_libraries(${name} PRIVATE feast_dense)
    endfunction()

    add_dense_example(Hermitian helloworld)
    add_dense_example(Hermitian driver_zfeast_heev)
    add_dense_example(Hermitian driver_cfeast_heev)
    add_dense_example(Hermitian driver_dfeast_sygv)
    add_dense_example(Hermitian driver_sfeast_sygv)

    add_dense_example(Non-Hermitian driver_dfeast_gegv)
    add_dense_example(Non-Hermitian driver_zfeast_syev)
    add_dense_example(Non-Hermitian driver_zfeast_syevx)
endif()
