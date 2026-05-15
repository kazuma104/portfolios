# ユーザー入力を促し、Enterキーでデフォルト値を適用
function Get-InputOrDefault {
    param (
        [string]$prompt,
        [string]$defaultValue
    )
    $inputValue = Read-Host "$prompt [初期値：$defaultValue]"
    if ($inputValue -eq "") {
        return $defaultValue
    }
    return $inputValue
}

function Get-IntInputOrDefault {
    param (
        [string]$prompt,
        [int]$defaultValue
    )
    $inputValue = Read-Host "$prompt [初期値：$defaultValue]"
    if ($inputValue -match "^\d+$") {
        return [int]$inputValue
    }
    return $defaultValue
}

# ユーザー入力の受付
$prefix = Get-InputOrDefault -prompt "フォルダの接頭辞" -defaultValue "XX"
$startNum = Get-IntInputOrDefault -prompt "連番の開始値" -defaultValue 1
$endNum = Get-IntInputOrDefault -prompt "連番の終了値" -defaultValue 10
$numDigits = Get-IntInputOrDefault -prompt "連番の桁数" -defaultValue 4
$path = Get-InputOrDefault -prompt "フォルダを作成する親ディレクトリ" -defaultValue ".\お試し用フォルダ"

# フォルダ作成処理
for ($i = $startNum; $i -le $endNum; $i++) {
    $folderName = "{0}_{1:D$numDigits}" -f $prefix, $i
    $folderPath = Join-Path -Path $path -ChildPath $folderName

    if (-not (Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        Write-Host "作成: $folderPath"
    } else {
        Write-Host "スキップ: $folderPath (既に存在)"
    }
}

# 終了待機
Write-Host "`n処理が完了しました。Enterキーを押して終了してください..."
Read-Host