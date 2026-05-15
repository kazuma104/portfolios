import os
import chardet

script_dir = os.path.dirname(os.path.abspath(__file__))
output_txt = os.path.join(script_dir, "encoding_results.txt")

results = []

for root, dirs, files in os.walk(script_dir):
    for file in files:
        file_path = os.path.join(root, file)
        try:
            with open(file_path, 'rb') as f:
                rawdata = f.read()
            result = chardet.detect(rawdata)
            results.append(f"ファイル: {file_path}\nエンコーディング: {result.get('encoding')} (確信度: {result.get('confidence')})\n")
        except Exception as e:
            results.append(f"ファイル: {file_path}\nエラー: {e}\n")
        results.append("-" * 40 + "\n")

with open(output_txt, "w", encoding="utf-8") as f:
    f.writelines(results)

print(f"TXT形式で出力しました: {output_txt}")