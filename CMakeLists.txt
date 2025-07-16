cmake_minimum_required(VERSION 3.16)

project(main VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required Qt components
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

# Automatically handle Qt's MOC, UIC, and RCC
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Define source files
set(SOURCES
    src/C/main.cpp
    src/C/AppSettings.cpp
    src/C/AppFiles.cpp
)

# Define header files
set(HEADERS
    src/C/AppSettings.h
    src/C/AppFiles.h
    src/C/SettingsKeys.h
)

# Define resource files
set(RESOURCES
    qml.qrc
)

# Create the executable
qt6_add_executable(main ${SOURCES} ${HEADERS} ${RESOURCES})

# Link additional Qt libraries that aren't automatically linked
target_link_libraries(main PRIVATE
    Qt6::QuickControls2
)

# Set target properties
set_target_properties(main PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

# Installation rules (optional)
install(TARGETS main
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Platform-specific configurations
if(WIN32)
    # Windows-specific settings
    set_target_properties(main PROPERTIES
        LINK_FLAGS "/SUBSYSTEM:WINDOWS"
    )
elseif(APPLE)
    # macOS-specific settings
    set_target_properties(main PROPERTIES
        MACOSX_BUNDLE_BUNDLE_NAME "BoilerPlateQt"
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION}
        MACOSX_BUNDLE_GUI_IDENTIFIER "com.quantumcompiler.boilerplateqt"
    )
endif()

# Debug/Release configurations
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(main PRIVATE QT_QML_DEBUG)
endif()

# Optional: Enable Qt Quick debugging in debug builds
target_compile_definitions(main PRIVATE
    $<$<CONFIG:Debug>:QT_QML_DEBUG>
)
