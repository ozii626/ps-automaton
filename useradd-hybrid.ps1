# Пароль пользователя по умолчанию
# (При первом входе будет пароль необходимо изменить)
$userpass = "Ss12345678"
# Домен пользователя
$domain = "kontoso.com"
# Почтовый ящик, на который будет отправлено уведомление о миграции
$notify = "best@kontoso.com"
# =====================================================
# ! Меняйте только переменные, которые находятся выше !
# =====================================================

# тут ввод кредов



$FirstName = Read-Host "Имя: "
$LastName = Read-Host "Фамилия: "
$MiddleName = Read-Host "Отчество: "
$Division = Read-Host "Отдел: "
$Manager = Read-Host "Руководитель: "
$Title = Read-Host "Должность: "
$OfficePhone = Read-Host "Внутренний номер: "
$mail = $FirstName.ToLower() + "." + $LastName.ToLower() + "@" + $domain.ToLower()



# тут генерация почты и отображаемого имени



# тут коннект на AD с уточнением инфы



# тут подключение к Exchange Online для миграции ящика


# ИИ-слоп, пока не разобрался
# Транслитерация
function Convert-Translit {
    param([string]$Text)

    # Таблица соответствия (ГОСТ / стандартный транслит)
    $translitMap = @{
        'а'='a'; 'б'='b'; 'в'='v'; 'г'='g'; 'д'='d'; 'е'='e'; 'ё'='yo'; 'ж'='zh';
        'з'='z'; 'и'='i'; 'й'='y'; 'к'='k'; 'л'='l'; 'м'='m'; 'н'='n'; 'о'='o';
        'п'='p'; 'р'='r'; 'с'='s'; 'т'='t'; 'у'='u'; 'ф'='f'; 'х'='h'; 'ц'='ts';
        'ч'='ch'; 'ш'='sh'; 'щ'='sch'; 'ъ'=''; 'ы'='y'; 'ь'=''; 'э'='e'; 'ю'='yu'; 'я'='ya';

        'А'='A'; 'Б'='B'; 'В'='V'; 'Г'='G'; 'Д'='D'; 'Е'='E'; 'Ё'='Yo'; 'Ж'='Zh';
        'З'='Z'; 'И'='I'; 'Й'='Y'; 'К'='K'; 'Л'='L'; 'М'='M'; 'Н'='N'; 'О'='O';
        'П'='P'; 'Р'='R'; 'С'='S'; 'Т'='T'; 'У'='U'; 'Ф'='F'; 'Х'='H'; 'Ц'='Ts';
        'Ч'='Ch'; 'Ш'='Sh'; 'Щ'='Sch'; 'Ъ'=''; 'Ы'='Y'; 'Ь'=''; 'Э'='E'; 'Ю'='Yu'; 'Я'='Ya'
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

# Пример использования:
# Convert-Translit -Text "Привет, Мир!"

