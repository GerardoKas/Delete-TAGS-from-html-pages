echo off 
cd %~dpn1
echo.
echo Se esperan archivos.htm.bak (con dos extensones).Se elimina la extension bak solamente
echo.
echo DIRECRORIO %cd%
echo.

for %%f in (*.bak) do (
	echo %%f
    ren "%%f" "%%~nf"
   if errorlevel 1 (
        echo ERROR "%%f"!
    ) else (
        echo OK "%%~nf"
    )
)

echo Finito..
pause