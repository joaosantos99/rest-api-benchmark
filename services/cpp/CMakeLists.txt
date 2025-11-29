cmake_minimum_required(VERSION 3.10)
project(cpp_benchmark)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Crow and OpenSSL
find_package(Crow REQUIRED)
find_package(OpenSSL REQUIRED)

# Include directories
include_directories(src)

# Source files
set(SOURCES
    src/main.cpp
    src/tests/hello_world.cpp
    src/tests/n_body.cpp
    src/tests/json_serde.cpp
    src/tests/regex_redux.cpp
)

# Create executable
add_executable(server ${SOURCES})

# Link libraries
target_link_libraries(server Crow::Crow OpenSSL::SSL OpenSSL::Crypto)

# Compiler flags
target_compile_options(server PRIVATE -O3 -DNDEBUG)
