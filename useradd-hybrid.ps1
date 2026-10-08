
# Пароль пользователя по умолчанию
# (При первом входе будет пароль необходимо изменить)
$userpass = "Ss12345678" | ConvertTo-SecureString -AsPlainText -Force
# Домен пользователя
$domain = "kont.com"
# Почтовый ящик, на который будет отправлено уведомление о миграции
$notify = "best@kontoso.com"
# Доменные имена серверов DC и EXCH
$dcsrv = "kontdc01"
$exchsrv = "kontexch01"

# =====================================================
# ! Меняйте только переменные, которые находятся выше !
# =====================================================

echo "" > log

# ИИ-слоп, пока не разобрался
# Переводить строку из кириллицы в латиницу
# Пример использованияConvert-Translit -Text "Привет, Мир!"
function Convert-Translit {
    param([string]$Text)
    # Таблица соответствия (ГОСТ / стандартный транслит)
    $translitMap = @{
        "а"="a"; "б"="b"; "в"="v"; "г"="g"; "д"="d"; "е"="e"; "ё"="yo"; "ж"="zh";
        "з"="z"; "и"="i"; "й"="y"; "к"="k"; "л"="l"; "м"="m"; "н"="n"; "о"="o";
        "п"="p"; "р"="r"; "с"="s"; "т"="t"; "у"="u"; "ф"="f"; "х"="h"; "ц"="ts";
        "ч"="ch"; "ш"="sh"; "щ"="sch"; "ъ"=""; "ы"="y"; "ь"=""; "э"="e"; "ю"="yu"; "я"="ya"
    }
    $result = [System.Text.StringBuilder]::new()
    # Проходим по каждому символу строки
    foreach ($char in $Text.ToCharArray()) {
        $charStr = [string]$char
        if ($translitMap.ContainsKey($charStr)) {
            [void]$result.Append($translitMap[$charStr])
        } else {
            [void]$result.Append($char) # Латиницу, цифры и пробелы оставляем без изменений
        }
    }
    return $result.ToString()
}

$AdminCredential = Get-Credential

Write-Output "(WARNING) Проверьте, что пользователь новый"
Write-Output "(WARNING) Рекомендуется не вводить значения вручную"
Write-Output ""
$FirstName = Read-Host "Имя"
$LastName = Read-Host "Фамилия"
$Division = Read-Host "Отдел"
$Manager = Read-Host "Руководитель"
$Title = Read-Host "Должность"
$OfficePhone = Read-Host "Внутренний номер"

$fname = Convert-Translit -Text $FirstName
$lname = Convert-Translit -Text $LastName
$fnameup = $fname.Substring(0,1).ToUpper() + $fname.Substring(1)
$lnameup = $lname.Substring(0,1).ToUpper() + $lname.Substring(1)
$userlogin = $fnameup + "." + $lnameup
$displayname = $lnameup + " " + $fnameup
$usermail = $userlogin + "@" + $domain

Write-Output "Логин:            $userlogin"
Write-Output "Почта:            $usermail"
Write-Output "Отображаемое имя: $displayname"
Write-Output "Пароль:           $userpass"

$agree = Read-Host "Продолжить с этими данными? (Д/н)"
if ( $agree -eq "н") {
    Write-Output "(LOG) Работа прервана пользователем"
    exit
}

# тут генерация почты
Write-Output "(LOG) Подключени к серверу Exchange"
$Session = New-PSSession `
    -ConfigurationName Microsoft.Exchange `
    -ConnectionUri "http://$exchsrv/PowerShell/" `
    -Authentication Kerberos `
    -Credential $AdminCredential

Import-PSSession $Session -DisableNameChecking
Write-Output "(LOG) Создание почтового ящика"
New-Mailbox -Name $displayname `
    -FirstName $fnameup `
    -LastName $lnameup `
    -Password $userpass `
    -UserPrincipalName $usermail `
    -ResetPasswordOnNextLogon $true

Remove-PSSession $Session

# тут коннект на AD с уточнением инфы



# тут подключение к Exchange Online для миграции ящика


