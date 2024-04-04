cmake_minimum_required(VERSION 3.29)
project(demo LANGUAGES Swift)

include(FetchContent)

set(patch_swift_numerics
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/GitPatch.cmake
  ${CMAKE_CURRENT_LIST_DIR}/swift-numerics.patch)

set(FETCHCONTENT_TRY_FIND_PACKAGE_MODE OPT_IN)
FetchContent_Declare(SwiftNumerics
  GIT_REPOSITORY https://github.com/apple/swift-numerics.git
  PATCH_COMMAND ${patch_swift_numerics}
  GIT_TAG        1.0.2 OVERRIDE_FIND_PACKAGE)

set(BUILD_EXAMPLES NO)
set(BUILD_TESTING NO)

FetchContent_MakeAvailable(SwiftNumerics)
add_library(Lib1 Lib1.swift)
target_link_libraries(Lib1 PRIVATE RealModule)
