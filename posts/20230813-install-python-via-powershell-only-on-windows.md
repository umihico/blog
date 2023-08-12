---
tags: "Windows,Python,PowerShell"
---

# WindowsのPowerShellだけを使って、Pythonをインストールするスニペット

引数/passiveにして、デフォで進める(?)ようにするのが肝でした。ドキュメント以外で使ってる人が見つからなかったので記事にしました。

## スニペットはこちら

Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.9.8/python-3.9.8-amd64.exe" -OutFile "python-3.9.8-amd64.exe"
Start-Process -FilePath "python-3.9.8-amd64.exe" -ArgumentList "/quiet /passive InstallAllUsers=0 InstallLauncherAllUsers=0 PrependPath=1 Include_test=0" -Wait
