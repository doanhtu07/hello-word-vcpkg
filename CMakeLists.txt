cmake_minimum_required(VERSION 3.30)

# Change this to ON/OFF to enable/disable production build
option(PRODUCTION_BUILD "Make this a production build" ON)

set(CMAKE_CXX_STANDARD 17)

project(HelloWorld)

# === Handle source files ===

message(STATUS "Handle source files")

# Define MY_SOURCES to be a list of all the source files for my game
file(GLOB_RECURSE MY_SOURCES CONFIGURE_DEPENDS
     "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
     "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h")

add_executable(${CMAKE_PROJECT_NAME})
target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${MY_SOURCES})

# === Handle packages ===

message(STATUS "Handle packages")

find_package(fmt CONFIG REQUIRED)
target_link_libraries(HelloWorld PRIVATE fmt::fmt)

# === Handle resources folder ===

message(STATUS "Handle resources folder")

if(PRODUCTION_BUILD)
  # setup the ASSETS_PATH macro to be in the root folder of your exe
  target_compile_definitions("${CMAKE_PROJECT_NAME}"
                             PUBLIC RESOURCES_PATH="./resources/")

  # remove the option to debug asserts.
  target_compile_definitions("${CMAKE_PROJECT_NAME}" PUBLIC PRODUCTION_BUILD=1)

  # https://thomas.trocha.com/blog/cmake--copy-files-after-build/
  # https://stackoverflow.com/questions/13429656/how-to-copy-contents-of-a-directory-into-build-directory-after-make-with-cmake
  # https://stackoverflow.com/questions/13429656/how-to-copy-contents-of-a-directory-into-build-directory-after-make-with-cmake#:~:text=To%20copy%20the%20directory%20itself%20instead%20of%20the,%24%7BPROJECT_NAME%7D%20POST_BUILD%20COMMAND%20%24%7BCMAKE_COMMAND%7D%20-E%20copy_directory%20%24%7BCMAKE_SOURCE_DIR%7D%2Fconfig%20%24%3CTARGET_FILE_DIR%3A%24%7BPROJECT_NAME%7D%3E%2Fconfig%29
  add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/resources
            $<TARGET_FILE_DIR:${PROJECT_NAME}>/resources)
else()
  # This is useful to get an ASSETS_PATH in your IDE during development
  target_compile_definitions(
    "${CMAKE_PROJECT_NAME}"
    PUBLIC RESOURCES_PATH="${CMAKE_CURRENT_SOURCE_DIR}/resources/")

  target_compile_definitions("${CMAKE_PROJECT_NAME}" PUBLIC PRODUCTION_BUILD=0)
endif()

# === Handle compile_commands.json for editor to lint ===

message(STATUS "Handle compile_commands.json for editor to lint")

# https://stackoverflow.com/questions/59263015/cmake-how-to-change-compile-commands-json-output-location
if(PROJECT_IS_TOP_LEVEL AND UNIX)
  # Create symlink to compile_commands.json for IDE to pick it up
  execute_process(
    COMMAND
      ${CMAKE_COMMAND} -E create_symlink
      ${CMAKE_BINARY_DIR}/compile_commands.json
      ${CMAKE_CURRENT_SOURCE_DIR}/compile_commands.json)
endif()
