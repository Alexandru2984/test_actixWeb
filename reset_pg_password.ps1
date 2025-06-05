# Script pentru resetare parolă PostgreSQL pe Windows

$pgBin = "C:\Program Files\PostgreSQL\17\bin"
$pgData = "C:\Program Files\PostgreSQL\17\data"
$pgConf = "$pgData\pg_hba.conf"

# 1. Backup fișier original pg_hba.conf
Copy-Item -Path $pgConf -Destination "$pgConf.bak" -Force
Write-Host "`n✅ Backup creat: pg_hba.conf.bak"

# 2. Înlocuiește toate autentificările cu 'trust' local
(Get-Content $pgConf) -replace "scram-sha-256", "trust" | Set-Content $pgConf
Write-Host "🔓 Setat autentificare trust temporar..."

# 3. Repornește serverul PostgreSQL
Set-Location $pgBin
.\pg_ctl.exe -D $pgData restart
Write-Host "🔁 Server repornit cu autentificare trust."

Write-Host "`n➡️ Acum deschide:"
Write-Host "   .\psql.exe -U postgres -h localhost -p 8004"
Write-Host "și rulează:"
Write-Host "   ALTER USER postgres WITH PASSWORD 'noua_ta_parola';"
Write-Host "`n⚠️ Nu uita să revii apoi la 'scram-sha-256' în $pgConf și să repornești din nou serverul!"
