cmake_minimum_required(VERSION 3.29)
project(demo LANGUAGES Swift)

if(WORKS_FINE)
  add_library(Lib1 Lib1/Lib1.swift)
  add_library(Lib2 Lib2/Lib2.swift)
  target_link_libraries(Lib1 PUBLIC Lib2)
else()
  add_subdirectory(Lib1)
  add_subdirectory(Lib2)
endif()
