# 指定したディレクトリ配下の全ファイルのエンコーディングを確認
$directoryPath = "C:\SVN\23_2024年度開発（岐阜）\server\oracle"  # 調査したいディレクトリに変更
$files = Get-ChildItem -Path $directoryPath -Recurse -File

# 結果を格納する配列
$results = @()

foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding Byte
        $encoding = $null

        # BOM (Byte Order Mark) に基づいてエンコーディングを判別
        if ($content.Length -ge 3 -and $content[0] -eq 0xEF -and $content[1] -eq 0xBB -and $content[2] -eq 0xBF) {
            $encoding = "UTF-8 (BOMあり)"
        }
        elseif ($content.Length -ge 2 -and $content[0] -eq 0xFF -and $content[1] -eq 0xFE) {
            $encoding = "UTF-16 LE"
        }
        elseif ($content.Length -ge 2 -and $content[0] -eq 0xFE -and $content[1] -eq 0xFF) {
            $encoding = "UTF-16 BE"
        }
        elseif ($content.Length -ge 4 -and $content[0] -eq 0x00 -and $content[1] -eq 0x00 -and $content[2] -eq 0xFE -and $content[3] -eq 0xFF) {
            $encoding = "UTF-32 BE"
        }
        elseif ($content.Length -ge 4 -and $content[0] -eq 0xFF -and $content[1] -eq 0xFE -and $content[2] -eq 0x00 -and $content[3] -eq 0x00) {
            $encoding = "UTF-32 LE"
        }
        else {
            # BOM がない場合、簡易的に UTF-8 / Shift_JIS / EUC-JP の可能性を判定
            $text = [System.Text.Encoding]::UTF8.GetString($content)
            if ($text -match "[^\x00-\x7F]") {
                $encoding = "UTF-8 (BOMなし) か 他のマルチバイト"
            }
            else {
                $encoding = "ASCII または Shift_JIS か EUC-JP の可能性"
            }
        }

        # 結果をリストに追加
        $results += [PSCustomObject]@{
            FilePath   = $file.FullName
            Encoding   = $encoding
        }
    }
    catch {
        Write-Warning "ファイル処理エラー: $($_.Exception.Message)"
    }
}

# 結果を表示
$results | Format-Table -AutoSize

# CSV に出力する場合
# $results | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation -Encoding UTF8