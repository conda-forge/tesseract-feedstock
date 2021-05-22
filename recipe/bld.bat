cd tesseract
mkdir build
cd build

curl -fsSOL https://software-network.org/client/sw-master-windows-client.zip
if errorlevel 1 exit 1

unzip sw-master-windows-client.zip -d .
if errorlevel 1 exit 1

sw setup
if errorlevel 1 exit 1

:: Remove -GL from CXXFLAGS as this causes a fatal error
set "CXXFLAGS= -MD"

cmake -G "NMake Makefiles" ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -D CMAKE_INCLUDE_PATH=%LIBRARY_INC% ^
      -D CMAKE_LIBRARY_PATH=%LIBRARY_LIB% ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      ..
if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

cmake --build . --config Release --target install 
if errorlevel 1 exit 1

:: Make copies of the .lib file without the embedded version number
copy %LIBRARY_LIB%\tesseract41.lib %LIBRARY_LIB%\tesseract.lib

:: Copy tessdata to bin directory so tesseract executable works
mkdir %LIBRARY_BIN%\tessdata
copy ..\..\tessdata_fast\eng.traineddata %LIBRARY_BIN%\tessdata\
copy ..\..\tessdata_fast\osd.traineddata %LIBRARY_BIN%\tessdata\

:: Copy tessdata to build prefix so tesseract API works
mkdir %PREFIX%\tessdata
copy %LIBRARY_BIN%\tessdata\*.traineddata %PREFIX%\tessdata\
