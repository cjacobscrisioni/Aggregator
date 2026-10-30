@echo off
setlocal

REM ---------------------------------------------------------------
REM Loop over the boundary sets we aggregate to, and run the
REM /store_files button in aggregator.dms for each of them.
REM
REM For every iteration two environment variables are set:
REM   boundary_set = full path of the boundary geopackage or shapefile
REM   boundary_code = name of the field that holds the zone codes
REM
REM Adjust the TODO items below before running.
REM ---------------------------------------------------------------

REM Setup Chris (TODO: check the config folder)
set config=D:\projdir\Aggregator_FRAs\cfg

set geodmsversion=GeoDMS20.3.0.c
set exe_dir=C:\Program Files\ObjectVision\%geodmsversion%
set ProgramPath=%exe_dir%\GeoDmsRun.exe

REM Folder that holds the boundary files
set bnd=D:\projdir\Aggregator_FRAs\data\boundaries

REM Boundary sets, written as "full path|zone field".
REM Remove or comment out (with rem) the sets that you do not need.
set sets=^
 "%bnd%\EUROSTAT_CITY-LAU-2021.gpkg|Code"^
 "%bnd%\country_x_EUROSTAT_degurba_2021.gpkg|Code"
 
REM "%bnd%\NUTS_RG_01M_2024_3035_LEVL_1.gpkg|nuts_id"^
REM "%bnd%\NUTS_RG_01M_2024_3035_LEVL_2.gpkg|nuts_id"^
REM "%bnd%\NUTS_RG_01M_2024_3035_LEVL_3.gpkg|nuts_id"^
REM "%bnd%\fraus__x8_pop_lau 2021_highdetail_3035.shp|fa_code"

echo Boundary sets to process:
for %%p in (%sets%) do echo   %%~p
echo.
pause

for %%p in (%sets%) do (
	for /f "tokens=1,2 delims=|" %%a in ("%%~p") do (

		set boundary_set=%%a
		set boundary_code=%%b

		echo ================================================
		echo Boundary file: %%a
		echo Zone field   : %%b
		echo ================================================

		if exist "%%a" (
			"%ProgramPath%" "%config%\aggregator.dms" /store_files || echo FAILED for %%a
		) else (
			echo WARNING: file not found, skipped: %%a
		)
	)
)

echo.
echo Done.
pause
endlocal