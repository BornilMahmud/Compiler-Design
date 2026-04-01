Write-Host "=== BNL Compiler Playground ==="
Write-Host "Step 1: Paste C code below."
Write-Host "Type END on a new line when done."
Write-Host ""

if (-not (Test-Path ".\\bnl_compiler.exe")) {
    Write-Host "Error: bnl_compiler.exe not found in current folder."
    Write-Host "Build first using: bison -d parser.y; flex lexer.l; gcc lex.yy.c parser.tab.c -o bnl_compiler.exe"
    exit 1
}

$gccCmd = Get-Command gcc -ErrorAction SilentlyContinue
if (-not $gccCmd) {
    Write-Host "Error: gcc not found in PATH."
    Write-Host "Install MinGW GCC or add it to PATH."
    exit 1
}

$lines = New-Object System.Collections.Generic.List[string]

if ([Console]::IsInputRedirected) {
    $rawInput = [Console]::In.ReadToEnd()
    if ($rawInput) {
        $splitLines = $rawInput -split "`r?`n"
        foreach ($line in $splitLines) {
            if ($line -eq "END") {
                break
            }
            if ($line -ne "") {
                $lines.Add($line)
            }
        }
    }
} else {
    while ($true) {
        $line = Read-Host
        if ($line -eq "END") {
            break
        }
        $lines.Add($line)
    }
}

$code = ($lines -join "`n") + "`n"

if ($lines.Count -eq 0) {
    Write-Host "No C code provided."
    exit 1
}

Write-Host ""
Write-Host "--- Syntax Detection ---"
$detectOutput = $code | .\\bnl_compiler.exe | Out-String
Write-Host $detectOutput

if ($detectOutput -notmatch "Valid C Program") {
    Write-Host "Code is not valid for this prototype. Stopping before execution."
    exit 1
}

$tempDir = Join-Path $env:TEMP "bnl_compiler"
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

$tempC = Join-Path $tempDir "program.c"
$tempExe = Join-Path $tempDir "program.exe"

Set-Content -Path $tempC -Value $code -Encoding Ascii

Write-Host "--- Compiling with GCC ---"
& gcc $tempC -o $tempExe
if ($LASTEXITCODE -ne 0) {
    Write-Host "Compilation failed."
    exit 1
}

Write-Host "Compilation successful."
Write-Host ""
Write-Host "--- Program Execution ---"
Write-Host "Now enter runtime input values for your C program:"
& $tempExe
