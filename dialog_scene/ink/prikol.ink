-> otch 

=== start_cutscene ===

# cts: wait
1

# spd: 12
По заказу FITFIJA Entertainment<br>Nurmak Studios представляет...

# cts: wait
1

# env: rain_interior.mp3 0 2 -15
# spd: 12
Сентябрь, 1996 год. Молчаливый курьер везёт груз в провинциальный городок.

# snd: car_arrives.wav 1
# cts: wait
6
# spd: 12
Его имя? Райан Гослинг.

# mus: Bram_Stoker's_Dracula_Unknown_Song_2.mp3
# cts: scen
Prikol_LihoDiner
# cts: fade
out 3
# cts: wait 
18

# spd: 1
# sid: ryan
...

# spd: 10
# sid: ryan
... <br>< Полночь. Старый. Клумба... >

# spd: 10
# sid: ryan
... <br>< Мне стоит расспросить кого-нибудь о городских "достопримечательностях" >

# cts: wait 
2

# cts: move
ryan up 22

# cts: wait
1

# snd: door_open.wav -3
# cts: fade
in 0.25

# cts: wait 
2

-> otch

=== otch ===

# env: .
# mus: .
# cts: scen
Prikol_Otchisleniye

# cts: fade
out 0.03

# cts: wait 
6

# mus: chrono_trigger.mp3
# sid: ryan
# loc: right
. . .

# sid: nikita
. . .

# sid: dasha
. . .

# sid: ya
. . .

# sid: nikita
Вы знаете, зачем мы здесь собрались?

* [Нет]
    # sid: ryan
    # loc: right
    Нет.
    -> otch1

* [...]
    # sid: ryan
    # loc: right
    . . .
    -> otch1

=== otch1 ===

# sid: ya
Ваши успехи в учёбе оставляют желать лучшего.<br>Нам нужно решить этот вопрос.

# sid: dasha
У вас пересдачи по всем предметам.<br>Что вы можете сказать в своё оправдание?

* [Меня подставили]
    # sid: ryan
    # loc: right
    Это случайность. Меня подставили.
    -> otch2

* [Ты обознался, дружок]
    # sid: ryan
    # loc: right
    Ты обознался, дружок.<br>< Курьер достаёт пистолет >
    
    # snd: madman_roar.wav
    # sid: ya
    ...грррРРР!<br><Безумец нападает, и курьер роняет пистолет><br><Предмет удалён: [Пистолет]>
    
    -> otch2

=== otch2 ===

# sid: dimas
. . . <br>< Хм, надо бы налить воды в чайник... >

# sid: nikita
Вы даже не знаете, что такое производная!

* [Знаю]
    # sid: ryan
    # loc: right
    Знаю.
    
    -> proizvodnaya

* [...]
    # sid: ryan
    # loc: right
    . . .
    
    # sid: nikita
    Дайте определение?
    
    # sid: ryan
    # loc: right
    Я не могу ответить на этот вопрос.
    
    # sid: nikita
    Это печально.
    
    -> otch3

=== proizvodnaya ===

# sid: nikita
Дайте определение.

* [<Звонок другу>]

    -> proizvodnaya3
    
* [<50/50>]

    < Курьер использует 50/50 >
    
    < Половина вариантов исчезает >
    
    -> proizvodnaya2
    
=== proizvodnaya2 ===

* [<Звонок другу>]

    -> proizvodnaya3
    
=== proizvodnaya3 ===

< Курьер использует звонок другу >
    
< ... >

# sid: natasha
Алло? 

# sid: natasha
Я знаю! Это предел отношения приращения функции к приращению переменной при стремлении к нулю (если предел существует)!

# sid: nikita
. . .

-> otch3

=== otch3 ===

# sid: dasha
Скажите, что такое граф?

* [Не скажу]
    < Курьер ничего не говорит >
    -> otch4

* [...]
    # sid: ryan
    # loc: right
    . . .
    -> otch4

=== otch4 ===

< По лбу Курьера течёт пот >

# sid: dimas
Опять эти лужи...

# sid: ya
...

# mus: suspense.mp3
# sid: ya
Нам надо посовещаться.

# cts: wait 
2

# sid: dasha
пшпшпшп...<br>< тихо говорит >

# sid: ya
пшпшпшпшпшп...

# sid: nikita
А?

# sid: dasha
пшпшпшп...

# sid: ya
пшпш...

* [Что там?]
    # sid: ryan
    # loc: right
    Что там?
    
    # sid: ya
    Я ещё ничего не сказал.
    -> otch5

* [...]
    # sid: ryan
    # loc: right
    . . .
    -> otch5

=== otch5 ===

# cts: wait 
3

# sid: ya
Мы приняли решение.

# cts: wait 
1

# sid: nikita1
Вас...

# mus: .
# snd: door_open.wav -3
# cts: anim
door open

# cts: wait
1

# cts: show
grisha

# cts: wait 
2

# sid: grisha
Добрый день. Можно войти?..

# sid: nikita
. . .

# sid: dasha
. . .

# sid: ya
. . .

# sid: ryan
. . .

# cts: wait 
2

# mus: barbie.mp3
# sid: grisha
С днём рождения!

# sid: nikita1
Даня, с днём рождения!

# sid: dasha1
Поздравляю!

# sid: ya1
Поздравляю, дед!

# sid: dimas
Поздравляю!

# cts: wait 
2

# sid: danya
Спасибо!

# sid: nikita1
Вам спасибо.

# cts: fade
in 0.25

# cts: wait 
2

# mus: .
# spd: 12
С ДНЁМ РОЖДЕНИЯ!<br>07.03.2024

# cts: exit
.

-> END