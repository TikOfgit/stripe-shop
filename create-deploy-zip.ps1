# Créer le dossier temporaire pour la structure O2switch
$tempDir = ".\o2switch-deploy"
$publicHtmlDir = "$tempDir\public_html"
$apiDir = "$publicHtmlDir\api"

# Créer les dossiers nécessaires
New-Item -ItemType Directory -Force -Path $publicHtmlDir
New-Item -ItemType Directory -Force -Path $apiDir

# Copier les fichiers du frontend (dossier dist)
Copy-Item ".\dist\*" -Destination $publicHtmlDir -Recurse

# Copier les fichiers du backend
Copy-Item ".\server\index.php" -Destination $apiDir
Copy-Item ".\server\composer.json" -Destination $apiDir
Copy-Item ".\server\.env" -Destination $apiDir

# Créer le fichier ZIP
Compress-Archive -Path "$tempDir\*" -DestinationPath ".\o2switch-deploy.zip" -Force

# Nettoyer le dossier temporaire
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "Archive o2switch-deploy.zip créée avec succès !"
