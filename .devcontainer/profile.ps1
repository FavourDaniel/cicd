# Enable predictive intellisense: https://www.thomasmaurer.ch/2021/02/powershell-predictive-intellisense/

Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# OPTIONAL you can also enable ListView
Set-PSReadLineOption -PredictionViewStyle ListView

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# oh-my-posh theme

oh-my-posh init pwsh --config "$env:POSH_THEME" | Invoke-Expression

# kubectl completion

Import-Module PSKubectlCompletion

Register-KubectlCompletion

