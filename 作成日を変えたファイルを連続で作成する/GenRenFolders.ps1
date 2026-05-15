$baseDirectory = "C:\Work\神_自作便利ツール\作成日を変えたファイルを連続で作成する\お試し用フォルダ"

# ファイルを30日分生成
for ($i = 0; $i -lt 30; $i++) {
    $currentDate = (Get-Date).AddDays(-$i)
    $filePath = Join-Path -Path $baseDirectory -ChildPath "File$i.log"

    # 空のファイルを作成
    New-Item -ItemType File -Path $filePath -Force

    # ファイルの更新日時を設定
    (Get-Item $filePath).LastWriteTime = $currentDate

    Write-Host "ファイルを生成しました。ファイルパス: $filePath, 更新日時: $((Get-Item $filePath).LastWriteTime)"
}