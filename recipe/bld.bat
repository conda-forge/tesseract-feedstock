cd tesseract
mkdir build
cd build

cmake -G "Ninja" ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -D CMAKE_INCLUDE_PATH=%LIBRARY_INC% ^
      -D CMAKE_LIBRARY_PATH=%LIBRARY_LIB% ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -D Leptonica_DIR=%LIBRARY_PREFIX% ^
      -D SW_BUILD=OFF ^
      -D BUILD_TRAINING_TOOLS=OFF ^
      -D BUILD_SHARED_LIBS=ON ^
      -D CMAKE_MODULE_LINKER_FLAGS=-whole-archive ^
      ..
if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

cmake --build . --config Release --target install 
if errorlevel 1 exit 1

:: Make copies of the .lib file without the embedded version number
copy %LIBRARY_LIB%\tesseract41.lib %LIBRARY_LIB%\tesseract.lib

:: Copy tessdata to shared directory
mkdir %PREFIX%\share\tessdata
copy ..\..\tessdata_fast\*.traineddata %PREFIX%\share\tessdata
move %LIBRARY_LIB%\share\tessdata\configs %PREFIX%\share\tessdata

:: Set TESSDATA_PREFIX via env_vars.d JSON (handled by conda at activation time).
if not exist %PREFIX%\etc\conda\env_vars.d mkdir %PREFIX%\etc\conda\env_vars.d
python -c "import json,os; p=os.environ['PREFIX']; print(json.dumps({'TESSDATA_PREFIX':p.replace(chr(92),'/')+'/share/tessdata/'}))" > %PREFIX%\etc\conda\env_vars.d\%PKG_NAME%.json
if errorlevel 1 exit 1
