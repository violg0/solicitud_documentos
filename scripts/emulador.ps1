# Abre el emulador Pixel_10 con DNS de Google.
# Sin esto el emulador usa el DNS del proveedor, que a veces falla y la app
# no puede resolver mockapi.io ni firestore.googleapis.com.
$emulator = Join-Path $env:LOCALAPPDATA 'Android\Sdk\emulator\emulator.exe'
& $emulator -avd Pixel_10 -dns-server 8.8.8.8,1.1.1.1
