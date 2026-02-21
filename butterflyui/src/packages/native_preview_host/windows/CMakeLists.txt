cmake_minimum_required(VERSION 3.14)
project(native_preview_host_plugin LANGUAGES CXX)

set(PLUGIN_NAME "native_preview_host_plugin")

add_library(${PLUGIN_NAME} SHARED
  "native_preview_host_plugin.cpp"
  "native_preview_host_plugin_c_api.cpp"
)

apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

set(native_preview_host_plugin_bundled_libraries
  ""
  PARENT_SCOPE
)
