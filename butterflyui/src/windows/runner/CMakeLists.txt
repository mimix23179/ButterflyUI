cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Attempt to convert a project `icon.png` to `resources/app_icon.ico`
# if the source PNG is present in the runner folder or project root. This
# is optional and non-fatal; the conversion helper quietly no-ops if
# Pillow is not available.
set(RUNNER_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(LOCAL_PNG "${RUNNER_DIR}/resources/icon.png")
set(PROJECT_PNG "${CMAKE_SOURCE_DIR}/../../icon.png")
set(OUT_ICO "${RUNNER_DIR}/resources/app_icon.ico")
if(EXISTS ${LOCAL_PNG})
  add_custom_command(
    OUTPUT ${OUT_ICO}
    COMMAND ${Python3_EXECUTABLE} ${RUNNER_DIR}/convert_icon.py ${LOCAL_PNG} ${OUT_ICO}
    DEPENDS ${LOCAL_PNG}
    VERBATIM
  )
elseif(EXISTS ${PROJECT_PNG})
  add_custom_command(
    OUTPUT ${OUT_ICO}
    COMMAND ${Python3_EXECUTABLE} ${RUNNER_DIR}/convert_icon.py ${PROJECT_PNG} ${OUT_ICO}
    DEPENDS ${PROJECT_PNG}
    VERBATIM
  )
endif()

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Ensure the generated ICO is considered when building the target.
if(TARGET ${BINARY_NAME} AND EXISTS ${OUT_ICO})
  add_custom_target(icon_gen ALL DEPENDS ${OUT_ICO})
  add_dependencies(${BINARY_NAME} icon_gen)
endif()

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)
