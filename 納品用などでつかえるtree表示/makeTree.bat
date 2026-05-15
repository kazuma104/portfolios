@echo off
rem 納品作業に使うやつ
rem *zipファイルには対応していません！
rem zipを解凍してその中身このbatを入れて実行してください。

rem 置換後のツリーを入れる。存在すれば先に消しておく(上書きで書き込むため)
if exist makeTree.csv del makeTree.csv

rem このバッチファイルをtreeの対象から消す。
tree /a /f | find /V "makeTree.bat" > makeTree.txt 

rem 無くても良いがあった方が良い
setlocal enabledelayedexpansion

rem カレントディレクトリを取得して、一行目に入れる。
echo | cd >> makeTree.csv

rem for文で毎行取り出す。 skip=3で3行分飛ばしている。 delims=で区切りを無くしている。
for /f "skip=3 delims=" %%a in (makeTree.txt) do (
    rem lineに毎行ずつ入れる。
    set line=%%a

    rem csvで見えやすくする。
    
    set line2=!line:+---=├,!
    set line3=!line2:\---=└,!
    set line4=!line3:^|   =｜,!
    set line5=!line4:    =,!
    echo !line5:^|=^｜! >> makeTree.csv
)

rem 中間ファイルを消す。
rem del makeTree.txt

rem setlocalをendする。
endlocal