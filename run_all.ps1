# BTUT Auto Runner
Write-Host "Initializing BTUT Demo Environment..." -ForegroundColor Cyan

# Create venv if not exists
if (-Not (Test-Path "venv")) {
    py -m venv venv
}

# Activate
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt

# Run all demos
Write-Host "`n[RUN] Core Demos`n"
py btut_grok_test.py --demo all

# Run diagnostics and scaling
Write-Host "`n[RUN] Diagnostics + Scaling`n"
py btut_diagnostics.py --gamma 1.45 --cA_SH 0.40 --alpha 0.60 --tau 0.30 --N 300000 --iters 20 --reps 5
py btut_scaling_test.py

# Generate GIFs
Write-Host "`n[RUN] Generating animations`n"
py btut_animate.py --mode converge
py btut_animate.py --mode phase

# Create zip folder if missing
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFolder = "results_zip"
if (-Not (Test-Path $zipFolder)) {
    New-Item -ItemType Directory -Path $zipFolder | Out-Null
}

# Zip all results
$zipFile = "$zipFolder\BTUT_results_$timestamp.zip"
if (Test-Path "plots") {
    Compress-Archive -Path "plots\*" -DestinationPath $zipFile -Force
    Write-Host "`n[✓] All results zipped to $zipFile`n" -ForegroundColor Green
} else {
    Write-Host "`n[!] Warning: No 'plots' folder found to zip.`n" -ForegroundColor Yellow
}

Write-Host "✅ All tasks complete." -ForegroundColor Green

