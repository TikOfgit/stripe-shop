# Définition des chemins
$projectRoot = $PSScriptRoot
$deployDir = Join-Path $projectRoot "deploy"
$publicHtmlDir = Join-Path $deployDir "public_html"
$apiDir = Join-Path $publicHtmlDir "api"

Write-Host "🚀 Préparation du déploiement..." -ForegroundColor Cyan

# Nettoyage des anciens fichiers de déploiement
if (Test-Path $deployDir) {
    Write-Host "🧹 Nettoyage des anciens fichiers..." -ForegroundColor Yellow
    Remove-Item -Path $deployDir -Recurse -Force
}

# Création des dossiers nécessaires
Write-Host "📁 Création des dossiers..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path $publicHtmlDir | Out-Null
New-Item -ItemType Directory -Force -Path $apiDir | Out-Null

# Construction du frontend
Write-Host "🏗️ Construction du frontend..." -ForegroundColor Green
npm run build

# Copie des fichiers du frontend
Write-Host "📋 Copie des fichiers frontend..." -ForegroundColor Green
Copy-Item -Path (Join-Path $projectRoot "dist\*") -Destination $publicHtmlDir -Recurse

# Copie des fichiers du backend
Write-Host "📋 Copie des fichiers backend..." -ForegroundColor Green
Copy-Item -Path (Join-Path $projectRoot "server\index.php") -Destination $apiDir
Copy-Item -Path (Join-Path $projectRoot "server\composer.json") -Destination $apiDir

# Création des fichiers .env
Write-Host "⚙️ Création des fichiers de configuration..." -ForegroundColor Green

$envContent = @"
STRIPE_SECRET_KEY=sk_test_51QOK0rCZ7sO3FQPpccPojrY53qCsGf869lsFMGyZp4Kcm2SLogUusaJsukOQwoMYMwygqHUJvbl60SFtg8iiCGM300bvSSQ5wd
FRONTEND_URL=https://votre-domaine.com
"@
$envContent | Out-File -FilePath (Join-Path $apiDir ".env") -Encoding UTF8

# Création de l'archive ZIP
Write-Host "📦 Création de l'archive ZIP..." -ForegroundColor Green
$zipPath = Join-Path $projectRoot "o2switch-deploy.zip"
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}
Compress-Archive -Path (Join-Path $deployDir "*") -DestinationPath $zipPath

Write-Host "`n✅ Déploiement préparé avec succès !" -ForegroundColor Cyan
Write-Host "📍 L'archive se trouve ici : $zipPath" -ForegroundColor Green
Write-Host "`n📝 Instructions de déploiement :" -ForegroundColor Yellow
Write-Host "1. Décompressez le contenu de l'archive sur votre ordinateur" -ForegroundColor White
Write-Host "2. Uploadez le contenu du dossier public_html vers le dossier public_html de votre hébergement O2switch" -ForegroundColor White
Write-Host "3. Dans le dossier api sur O2switch, exécutez 'composer install'" -ForegroundColor White
Write-Host "4. Modifiez le fichier .env dans le dossier api avec vos paramètres" -ForegroundColor White
Write-Host "`n⚠️ N'oubliez pas de :" -ForegroundColor Red
Write-Host "- Configurer votre domaine dans le fichier .env" -ForegroundColor White
Write-Host "- Vérifier les permissions des fichiers sur O2switch" -ForegroundColor White
