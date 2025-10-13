# Flutter Setup Script for Windows
# Run this script as Administrator

Write-Host "Setting up Flutter for Dental EMR project..." -ForegroundColor Green

# Check if Flutter is already installed
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "Flutter is already installed!" -ForegroundColor Yellow
    flutter --version
} else {
    Write-Host "Flutter not found. Please install Flutter manually:" -ForegroundColor Red
    Write-Host "1. Download from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
    Write-Host "2. Extract to C:\flutter" -ForegroundColor Cyan
    Write-Host "3. Add C:\flutter\bin to your PATH" -ForegroundColor Cyan
    Write-Host "4. Restart PowerShell and run this script again" -ForegroundColor Cyan
    exit 1
}

# Run Flutter Doctor
Write-Host "Running Flutter Doctor..." -ForegroundColor Blue
flutter doctor

# Install project dependencies
Write-Host "Installing project dependencies..." -ForegroundColor Blue
flutter pub get

# Check for connected devices
Write-Host "Checking for available devices..." -ForegroundColor Blue
flutter devices

Write-Host "Setup complete! You can now run: flutter run" -ForegroundColor Green
