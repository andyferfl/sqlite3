cmake_minimum_required(VERSION 3.17)
project(Sqlite3 C)

add_library(sqlite3lib SHARED sqlite3.c sqlite3.h sqlite3ext.h)
target_link_libraries(sqlite3lib PRIVATE ${CMAKE_DL_LIBS} m)

target_compile_definitions(sqlite3lib PRIVATE
  -DSQLITE_ENABLE_FTS4
  -DSQLITE_ENABLE_FTS5
  -DSQLITE_ENABLE_JSON1
  -DSQLITE_ENABLE_RTREE
  -DSQLITE_ENABLE_EXPLAIN_COMMENTS
  -DSQLITE_OMIT_DEPRECATED
)

if (NOT WIN32)
  target_compile_definitions(sqlite3lib PRIVATE -DHAVE_USLEEP)
endif()

if (CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
  target_compile_definitions(sqlite3lib PRIVATE -DSQLITE_OS_WINRT=1)
endif()

target_compile_options(sqlite3lib PRIVATE -Wno-return-local-addr -Wno-stringop-overflow)

add_executable(sqlite3 shell.c)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

target_include_directories(sqlite3 PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)
target_link_libraries(sqlite3 PUBLIC ${CMAKE_THREAD_LIBS_INIT} sqlite3lib)


install(TARGETS sqlite3lib sqlite3
  LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
  ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
)
