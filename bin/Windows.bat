@echo off
REM Build and run script for Qt application using CMake on Windows
REM This script should be run from the bin directory
REM Usage: 
REM   Windows.bat -b   "Builds the application and cleans old build"
REM   Windows.bat -r   "Runs the application"

setlocal enabledelayedexpansion

REM Function to find the project root directory
call :find_project_root
if errorlevel 1 (
    echo Error: Could not find CMakeLists.txt file in current directory tree
    echo Make sure you're running this script from within the project directory
    exit /b 1
)

set CMAKE_FILE=%PROJECT_DIR%\CMakeLists.txt
set BUILD_DIR=%PROJECT_DIR%\build

REM Parse command line arguments
if "%~1"=="" (
    echo Error: No arguments provided
    call :show_usage
    exit /b 1
)

if /i "%~1"=="-b" call :build_application Debug
if /i "%~1"=="-d" call :build_application Debug
if /i "%~1"=="-rel" call :build_application Release
if /i "%~1"=="-c" call :clean_build
if /i "%~1"=="-deps" call :check_dependencies
if /i "%~1"=="-h" call :show_usage
if /i "%~1"=="--help" call :show_usage
if /i "%~1"=="-r" call :run_application
if /i "%~1"=="-x" (
    call :build_application Debug
    if not errorlevel 1 call :run_application
)
if /i "%~1"=="-vs" call :open_visual_studio

if not defined COMMAND_FOUND (
    echo Error: Unknown option '%~1'
    call :show_usage
    exit /b 1
)

goto :eof

REM Function to find project root directory
:find_project_root
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%.."

REM Normalize the path
for %%i in ("%PROJECT_DIR%") do set "PROJECT_DIR=%%~fi"

REM Check if CMakeLists.txt exists in the parent directory
if exist "%PROJECT_DIR%\CMakeLists.txt" (
    echo Project directory: %PROJECT_DIR%
    exit /b 0
)

REM Search upward for CMakeLists.txt
set "SEARCH_DIR=%PROJECT_DIR%"
:search_loop
if exist "%SEARCH_DIR%\CMakeLists.txt" (
    set "PROJECT_DIR=%SEARCH_DIR%"
    echo Project directory: %PROJECT_DIR%
    exit /b 0
)

REM Go up one directory
for %%i in ("%SEARCH_DIR%\..") do set "SEARCH_DIR=%%~fi"

REM Check if we've reached the root
if "%SEARCH_DIR%"=="%SEARCH_DIR:~0,3%" exit /b 1

goto :search_loop

REM Function to display usage
:show_usage
echo Usage: %~nx0 [OPTION]
echo Options:
echo   -b      Build the application and clean old build
echo   -c      Clean build files only
echo   -h      Show this help message
echo   -r      Run the application
echo   -x      Build and run the application
echo   -d      Build in debug mode
echo   -rel    Build in release mode
echo   -deps   Check and install Qt dependencies
echo   -vs     Open project in Visual Studio (if solution exists)
set COMMAND_FOUND=1
exit /b 0

REM Function to check Qt dependencies
:check_dependencies
echo Checking Qt6 dependencies for Windows...

REM Check if cmake is installed
cmake --version >nul 2>&1
if errorlevel 1 (
    echo Error: cmake is not installed or not in PATH
    echo Download and install from: https://cmake.org/download/
    echo Make sure to add CMake to your system PATH
    exit /b 1
) else (
    echo CMake found!
)

REM Check for Visual Studio or Build Tools
where cl >nul 2>&1
if errorlevel 1 (
    echo Warning: Visual Studio C++ compiler not found in PATH
    echo You may need to run this from a Visual Studio Developer Command Prompt
    echo Or install Visual Studio 2019/2022 with C++ development tools
    echo.
    echo Alternatives:
    echo   - Visual Studio Community (free): https://visualstudio.microsoft.com/
    echo   - Visual Studio Build Tools: https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022
    echo.
    set /p continue="Continue anyway? (y/N): "
    if /i not "!continue!"=="y" exit /b 1
) else (
    echo Visual Studio C++ compiler found!
)

REM Check for Qt6
if defined Qt6_DIR (
    echo Qt6 found at: %Qt6_DIR%
) else (
    echo Warning: Qt6_DIR environment variable not set
    echo Please install Qt6 and set Qt6_DIR to the Qt installation path
    echo Example: set Qt6_DIR=C:\Qt\6.x.x\msvc2019_64\lib\cmake\Qt6
    echo.
    echo Download Qt from: https://www.qt.io/download-qt-installer
    echo.
)

REM Check for Ninja (optional but faster)
ninja --version >nul 2>&1
if not errorlevel 1 (
    echo Ninja build system detected - will use for faster builds
    set CMAKE_GENERATOR=Ninja
) else (
    echo Using default Visual Studio generator
)

echo Dependency check completed.
set COMMAND_FOUND=1
exit /b 0

REM Function to build the application
:build_application
set BUILD_TYPE=%~1
if "%BUILD_TYPE%"=="" set BUILD_TYPE=Debug

echo Building Qt application with CMake...
echo Project directory: %PROJECT_DIR%
echo CMakeLists.txt location: %CMAKE_FILE%
echo Build type: %BUILD_TYPE%

REM Check if CMakeLists.txt exists
if not exist "%CMAKE_FILE%" (
    echo Error: CMakeLists.txt not found at %CMAKE_FILE%
    exit /b 1
)

REM Create build directory if it doesn't exist
if not exist "%BUILD_DIR%" (
    echo Creating build directory...
    mkdir "%BUILD_DIR%"
)

REM Change to build directory
cd /d "%BUILD_DIR%"

REM Configure with CMake
echo Running cmake configure...
if defined CMAKE_GENERATOR (
    cmake -G "%CMAKE_GENERATOR%" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
) else (
    cmake -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ..
)

if errorlevel 1 (
    echo Error: cmake configure failed
    echo Try running: %~nx0 -deps to check dependencies
    exit /b 1
)

REM Build the application
echo Building application...
cmake --build . --config %BUILD_TYPE% --parallel

if errorlevel 1 (
    echo Error: cmake build failed
    exit /b 1
)

echo Build completed successfully!
if "%BUILD_TYPE%"=="Debug" (
    echo Executable location: %BUILD_DIR%\Debug\main.exe
) else (
    echo Executable location: %BUILD_DIR%\Release\main.exe
)

set COMMAND_FOUND=1
exit /b 0

REM Function to clean the build files
:clean_build
echo Cleaning build files in: %BUILD_DIR%

if exist "%BUILD_DIR%" (
    cd /d "%BUILD_DIR%"
    
    REM Try to clean using cmake
    if exist "CMakeCache.txt" (
        cmake --build . --target clean >nul 2>&1
    )
    
    REM Remove the entire build directory for a complete clean
    cd /d "%PROJECT_DIR%"
    rmdir /s /q "%BUILD_DIR%" >nul 2>&1
    if exist "%BUILD_DIR%" (
        echo Warning: Could not remove all build files
    ) else (
        echo Build directory removed successfully!
    )
) else (
    echo Build directory does not exist, nothing to clean.
)

set COMMAND_FOUND=1
exit /b 0

REM Function to run the application
:run_application
echo Running Qt application...

REM Look for the executable in both Debug and Release folders
set EXECUTABLE_DEBUG=%BUILD_DIR%\Debug\main.exe
set EXECUTABLE_RELEASE=%BUILD_DIR%\Release\main.exe
set EXECUTABLE_ROOT=%BUILD_DIR%\main.exe

if exist "%EXECUTABLE_DEBUG%" (
    set EXECUTABLE=%EXECUTABLE_DEBUG%
    set CONFIG=Debug
) else if exist "%EXECUTABLE_RELEASE%" (
    set EXECUTABLE=%EXECUTABLE_RELEASE%
    set CONFIG=Release
) else if exist "%EXECUTABLE_ROOT%" (
    set EXECUTABLE=%EXECUTABLE_ROOT%
    set CONFIG=Default
) else (
    echo Error: Executable not found at any of these locations:
    echo   %EXECUTABLE_DEBUG%
    echo   %EXECUTABLE_RELEASE%
    echo   %EXECUTABLE_ROOT%
    echo Make sure you have built the application first using: %~nx0 -b
    exit /b 1
)

echo Starting application (%CONFIG%): %EXECUTABLE%

REM Change to build directory and run
cd /d "%BUILD_DIR%"

REM Check if Qt DLLs are in PATH (for deployment)
if not defined Qt6_DIR (
    echo Warning: Qt6_DIR not set. If the application fails to start,
    echo you may need to add Qt bin directory to PATH or copy Qt DLLs
)

REM Run the executable
start "" "%EXECUTABLE%"

set COMMAND_FOUND=1
exit /b 0

REM Function to open Visual Studio (if available)
:open_visual_studio
if exist "%BUILD_DIR%\main.sln" (
    echo Opening project in Visual Studio...
    start "" "%BUILD_DIR%\main.sln"
) else (
    echo Visual Studio solution not found.
    echo Build the project first with: %~nx0 -b
    echo Then run cmake configure with Visual Studio generator
)

set COMMAND_FOUND=1
exit /b 0
