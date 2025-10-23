# ============================================
# 🚀 BTUT Auto Runner v3.0 (Final)
# Author: Diren Kumaratilleke
# ============================================

Write-Host "🚀 Initializing BTUT Demo Environment..." -ForegroundColor Cyan

# Create and activate virtual environment
if (-Not (Test-Path "venv")) {
    py -m venv venv
}
.\venv\Scripts\Activate.ps1

# Install dependencies
Write-Host "📦 Installing requirements..." -ForegroundColor Yellow
pip install --upgrade pip
pip install -r requirements.txt

# Run all core BTUT demos
Write-Host "▶️ Running BTUT Demos..." -ForegroundColor Cyan
py btut_grok_test.py --demo all

# Run diagnostics and scaling
Write-Host "🧠 Running Diagnostics and Scaling Tests..." -ForegroundColor Cyan
py btut_diagnostics.py --gamma 1.45 --cA_SH 0.40 --alpha 0.60 --tau 0.30 --N 300000 --iters 20 --reps 5
py btut_scaling_test.py

# Generate GIF animations
Write-Host "🎞 Generating Animations..." -ForegroundColor Cyan
py btut_animate.py --mode converge
py btut_animate.py --mode phase

# ✅ Create results folder before zipping
Write-Host "🗂 Creating results folder..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFolder = "results_zip"
if (-Not (Test-Path $zipFolder)) {
    New-Item -ItemType Directory -Path $zipFolder | Out-Null
}

# ✅ Zip all plots safely
$zipFile = "$zipFolder\BTUT_results_$timestamp.zip"
if (Test-Path "plots") {
    Compress-Archive -Path "plots\*" -DestinationPath $zipFile -Force
    Write-Host "`n✅ All tasks complete. Results stored at: $zipFile`n" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Warning: No 'plots' folder found to zip.`n" -ForegroundColor Red
}
