$Files = @(
#   library name	file name
	@("lib_StopWatch", "src\Utilities.pkg.vhdl"),
	@("lib_StopWatch", "src\Debouncer.vhdl"),
	@("lib_StopWatch", "src\Counter.vhdl"),
	@("lib_StopWatch", "src\StopWatch.pkg.vhdl"),
	@("lib_StopWatch", "src\seg7_Encoder.vhdl"),
	@("lib_StopWatch", "src\seg7_Display.vhdl"),
	@("lib_StopWatch", "src\StopWatch.vhdl"),
	@("lib_StopWatch", "src\toplevel.StopWatch.vhdl"),
	@("test",         "tb\toplevel.StopWatch.tb.vhdl")
)
$Testbench = "toplevel_tb"


if (-not ($env:Path -match "GHDL"))
{	Write-Host "Adding GHDL to PATH..."
	$env:Path = "C:\Tools\GHDL\0.36-dev-gnatgpl32-mcode\bin;" + $env:Path
}
if (-not ($env:Path -match "GTKWave"))
{	Write-Host "Adding GTKWave to PATH..."
	$env:Path = "C:\Tools\GTKWave\3.3.88\bin;" + $env:Path
}


foreach ($Entry in $Files)
{	$Lib = $Entry[0]
	$File = $Entry[1]
	Write-Host "Compiling $File ..." -foreground yellow
	ghdl.exe -a --std=08 --work=$Lib $File
	if($lastexitcode -ne 0)
	{	exit -1  }
}


Write-Host "Run test..." -foreground yellow
$testlibrary = $Files[-1][0]
Write-Host "  ghdl.exe -r --std=08 --work=$testlibrary $Testbench `"--wave=$Testbench.ghw`""
ghdl.exe -r --std=08 --work=$testlibrary $Testbench "--wave=$Testbench.ghw"
if($lastexitcode -ne 0)
{	exit -2	}


Write-Host "Show results..." -foreground yellow
$GTKWaveFile = "sim/$Testbench.gtkw"
if (Test-Path $GTKWaveFile)
{	gtkwave.exe -f ".\$Testbench.ghw" -a $GTKWaveFile    }
else
{	gtkwave.exe -f ".\$Testbench.ghw"                    }
