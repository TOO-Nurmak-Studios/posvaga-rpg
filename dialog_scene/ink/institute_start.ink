VAR found_command_book_for_sasha = false
VAR talked_to_lida = false
VAR talked_to_damir = false
VAR got_wrong_book_1 = false
VAR got_wrong_book_2 = false
VAR got_wrong_book_3 = false
VAR got_wrong_book_4 = false
VAR got_wrong_book_5 = false

-> start_cutscene 

=== start_cutscene ===

# cts: wait
1

# spd: 12
По заказу FITFIJA Entertainment<br>Nurmak Studios представляет...

# cts: wait
1

# spd: 12
Ноябрь, 19XX год. Город N.<br>Институт прикладной геоинформатики.

# cts: wait
1

# mus: a_star_called_sun.mp3
# cts: fade 
out 0.03
# cts: wait 
6

# sid: damir_bored
Как же меня всё это достало!

# sid: vera_doubting
# loc: right
...

# sid: damir_bored
Мы работали целый день, а толку никакого! Даже половину координат не загнали.

# sid: damir_relaxed
И зачем я вообще пошёл в аспирантуру...

# sid: sasha_neutral
Сейчас только 8 вечера. Мы ещё успеваем. 

# sid: lida_neutral
Я-я не хочу оставаться тут на всю ночь...

# cts: wait 
1.5
# sid: damir_angry
Да что б его, опять всё зависло!

# sid: damir_bored
Это же не у меня одного так? Или я уже с ума схожу?

# sid: lida_angry
У меня тоже ничего не работает...

# sid: vera_neutral
# loc: right
Ха, вот вам и суперЭВМ.

# sid: sasha_confused
Сейчас разберёмся. Кажется, опять институская сеть перегружена.

# snd: typing.wav -10
# sid: sasha_neutral
Так, как бы это проверить...

# cts: wait 
1
# sid: sasha_neutral
Вера, можешь мне подать пособие с командами? Книга была где-то около твоего стола.

# sid: vera_angry
# loc: right
...

# sid: vera_doubting
# loc: right
...ладно, сейчас.

->END


=== talk_damir ===
{
- not talked_to_damir:

    ~talked_to_damir = true
    
    # sid: damir_bored
    И зачем я вообще пошёл в аспирантуру...
    
    # sid: vera_doubting
    # loc: right
    А в лабу зачем пошёл?
    
    # sid: damir_relaxed
    Слишком много вопросов стоит перед советскими учеными!

- else:
    # sid: vera_neutral
    # loc: right
    Вот ещё вопрос: не знаешь, где лежит книга с командами? Саша спрашивает.
    
    # sid: damir_happy
    Ха-ха, да тут книги валяются по всему кабинету!
    
    # sid: damir_neutral
    Может, она в той куче в углу? Я всё туда складываю...
}

->END


=== talk_lida ===
{
- not talked_to_lida:
    ~ talked_to_lida = true
    # sid: lida_neutral
    Я вбила почти все координаты на сегодня, и-и тут терминал завис...
    
    # sid: lida_scared
    Владимир Николаевич меня убьёт!!.
    
    # sid: vera_neutral
    # loc: right
    Не бойся, мы с ним как-нибудь справимся.
    
    # sid: vera_neutral
    # loc: right
    Но сначала нужно всё починить...
    
- else:
    # sid: vera_doubting
    # loc: right
    Ты случайно не знаешь, где та книга, которую Саша просит найти?
    
    # sid: lida_neutral
    Не знаю... Может, стоит проверить книжные полки? 
}

->END


=== talk_sasha ===

{ 
- found_command_book_for_sasha:
    -> talk_sasha_got_book
- got_wrong_book_1 || got_wrong_book_2 || got_wrong_book_3 || got_wrong_book_4 || got_wrong_book_5:
    -> talk_sasha_wrong_book
- else:
    -> talk_sasha_book_not_found
}

=== talk_sasha_book_not_found ===
# sid: sasha_neutral
Я могу перейти в режим отладки, но мои дальнейшие попытки тщетны. 

# sid: sasha_neutral
Ты не нашла пособие с командами?

# sid: vera_neutral
# loc: right
Продолжаю поиски.

# sid: sasha_smiling
Точно помню, что оставил его где-то у твоего стола. Уверенность абсолютная.

# sid: vera_doubting
# loc: right
Ха, а я бы не была так уверена.

->END


=== talk_sasha_wrong_book ===
# sid: vera_sad
# loc: right
Это не та книга?

# sid: sasha_angry
Нет, совсем не та. Мне нужно пособие со списком команд.

# sid: sasha_smiling
Точно помню, что оставил его где-то у твоего стола. Уверенность абсолютная.

# sid: vera_doubting
# loc: right
Ха, а я бы не была так уверена.

->END


=== wrong_book_1 ===

Новгородцев Ю.Е. Развитие архитектуры ЭВМ от БЭСМ-6 до суперкомпьютеров. / Институт системного анализа РАН. - 230 c.

Взять книгу?

* [Взять]
    
    ~ got_wrong_book_1 = true
    
    # sid: vera_neutral
    # loc: right
    Может, подойдет.
    ->END

* [Уйти]

    # sid: vera_neutral
    # loc: right
    Надо поискать ещё.

->END


=== wrong_book_2 ===

Мулко, К.Т. Информационная безопасность в контексте актуальных уязвимостей компьютерных систем / БГУИР, - 264 с. : ил.

Взять книгу?

* [Взять]
    
    ~ got_wrong_book_2 = true
    
    # sid: vera_neutral
    # loc: right
    Может, подойдет.
    ->END

* [Уйти]

    # sid: vera_neutral
    # loc: right
    Надо поискать ещё.

->END


=== wrong_book_3 ===

Грук С.И. Машина для интегрирования дифференциальных уравнений / Изд-во АН СССР, 1941, - 441 с.

Взять книгу?

* [Взять]
    
    ~ got_wrong_book_3 = true
    
    # sid: vera_neutral
    # loc: right
    Может, подойдет.
    ->END

* [Уйти]

    # sid: vera_neutral
    # loc: right
    Надо поискать ещё.
    
->END


=== wrong_book_4 ===

Нурмаков В.И., Старцева Г.А. Геоинформатика: учебное пособие / Изд-во АмГПГУ - 262 с.

Взять книгу?

* [Взять]
    
    ~ got_wrong_book_4 = true
    
    # sid: vera_neutral
    # loc: right
    Может, подойдет.
    ->END

* [Уйти]

    # sid: vera_neutral
    # loc: right
    Надо поискать ещё.
    
->END


=== wrong_book_5 ===

Демидович Б. П. Сборник задач и упражнений по математическому анализу: Учеб. пособие для вузов / 558, [2] с.: ил.

Взять книгу?

* [Взять]
    
    ~ got_wrong_book_5 = true
    
    # sid: vera_scared
    # loc: right
    Может, не надо...
    ->END

* [Уйти]

    # sid: vera_neutral
    # loc: right
    Надо поискать ещё.
    
->END


=== zavlab_book ===
# sid: vera_neutral
# loc: right
Это папка Владимира Николаевича с геоданными нашей области.

# sid: vera_sad
# loc: right
Всё это нам нужно вбить в систему до завтра...

# sid: vera_bored
# loc: right
Какая же это скучная работа...
->END


=== vera_notes ===
# sid: vera_neutral
# loc: right
Мои заметки, какие-то расчеты. Надо выбросить.
-> END


=== book_pile ===
{ 
- not got_wrong_book_5:

    Одна книга наверху стопки привлекает внимание своей потрёпанной обложкой.

    -> wrong_book_5
- else:
    -> book_pile_empty
}


=== book_pile_empty ===
Ни одна книга в этой куче не привлекает внимания.
-> END


=== book_shelf_1 ===
Ни одна книга на полке не привлекает внимания.
-> END


=== book_shelf_2 ===
{ 
- not found_command_book_for_sasha:
    -> correct_book
- else:
    -> book_shelf_2_empty
}

=== book_shelf_2_empty ===
Ни одна книга в этом шкафу не привлекает внимания.
-> END

=== correct_book ===

Неровно стоящая книга привлекает внимание. Кажется, её поставили на полку совсем недавно.

Иванопольский И.А., Швац Е.В., Архитектура и список машинных команд кластерных систем супер-ЭВМ серии "ИРТЫШ" / М.: Наука. - 352 c.

Взять книгу?

* [Взять]
    
    ~ found_command_book_for_sasha = true
    
    # sid: vera_neutral
    # loc: right
    То, что надо.
    ->END

* [Уйти]

    # sid: vera_neutral
    # loc: right
    Надо поискать ещё.
    
->END


=== talk_sasha_got_book ===

# sid: vera_neutral
# loc: right
Держи.

# sid: sasha_smiling
Это оно, спасибо. Так, мне нужна глава про отладку...

# snd: typing.wav -10
# sid: sasha_neutral
Ага, значит так, и вот так.....

# cts: s 1 wait 1
# sid: damir_neutral
Ну, чего там? Заработало?

# sid: sasha_surprised
Очень странно. Сеть действительно перегружена, но я не понимаю, что происходит.

# sid: sasha_surprised
Кто-то отправляет команды управления на все ЭВМ в институте...

# sid: lida_scared
!!!

# sid: sasha_neutral
Больше похоже на какой-то сбой. Надо спросить у Владимира Николаевича.

# sid: damir_neutral
Только старого хрыча нам не хватало... 
-> zavlab_entrance


=== zavlab_entrance ===

# cts: wait
1
# mus: .
# snd: door_open.wav
# cts: anim
door open
# cts: wait
1
# cts: turn 
sasha left
# cts: turn 
lida left
# cts: turn 
vera left
# cts: wait
1
# cts: turn 
damir left
# cts: wait
1
# mus: hey_now.mp3
# cts: move
zavlab down 6
# cts: turn 
zavlab right
#cts: wait
1.5

# sid: zavlab_neutral
Ну что, товарищи аспиранты? Как продвигается работа?

# sid: lida_scared
# loc: right
В-Владимир Николаевич...

# sid: damir_bored
# loc: right
Почти готово, ха-ха! Работаем в поте лица, даже перекурить некогда...

# sid: zavlab_little_smile
Так я и думал.

# sid: zavlab_shouting
Напоминаю вам, что завтра очень важный день! Медлить нельзя, все геоданные должны быть внесены в систему.

# sid: zavlab_angry
Думаю, не надо напоминать, что ваша работа в лаборатории прямо влияет на оценку за практику.

# sid: vera_bored
# loc: right
(если не надо, то зачем напомнил?)

# sid: zavlab_smiling
Верочка, умница, у тебя ко мне какой-то вопрос?

# sid: vera_scared
# loc: right
Э-э-э, нет, Владимир Николаевич, никаких вопросов...

# sid: lida_angry
# loc: right
...

# sid: zavlab_smiling
Ну вот и славно! У матросов нет вопросов, ха-ха?

# sid: sasha_surprised
# loc: right
Владимир Николаевич, у нас тут проблема...

# sid: zavlab_little_smile
Всё, всё, мне надо бежать, завтра мне всё покажете. И чтобы ни строчки не пропустили!


# cts: turn 
zavlab up
# cts: wait
0.5
# cts: move
zavlab up 12 sprint
# mus: .
# snd: door_close.mp3
# cts: anim
door close
# cts: wait
1
# cts: turn 
sasha down
# cts: turn 
lida down
# cts: turn 
vera down
# cts: turn 
damir up
#cts: wait
3

# mus: a_star_called_sun.mp3
# sid: damir_bored
Ну что за фигняяяяя...

# sid: sasha_scared
...

# sid: damir_relaxed
Чёрт с ним, я покурить. Кто-нибудь со мной?

# cts: wait 
0.5
# cts: turn 
damir right
# cts: wait 
1
# cts: turn 
damir up
# cts: wait 
1
# cts: turn 
damir down
# cts: wait 
1

# sid: damir_neutral
Да и чёрт с вами, я пошёл.

# cts: move 
damir left 4.6
# cts: turn 
vera left
# cts: move 
damir up 12
# snd: door_open.wav
# cts: anim
door open
# cts: move 
damir up 7
# snd: door_close.mp3
# cts: anim
door close
# cts: wait 
1
# cts: move 
vera down 3.5
# cts: turn 
sasha up
# cts: turn 
lida up
# cts: move 
vera right 4
# cts: turn 
vera down
# cts: wait 
1

-> sleep


=== sleep ===

# sid: sasha_angry
Ладно, надо сфокусироваться. Что мы можем сделать в этой ситуации...

# sid: vera_sad
# loc: right
(как же мне хочется спать...)

# sid: lida_neutral
Отключим удаленный доступ, и продолжим работу? Что-то ведь должно было сохраниться...

# sid: sasha_neutral
Да, но терминал ведёт себя очень странно в любом случае. Может...

# sid: vera_sad
# loc: right
(......)

-> damir_going_for_a_smoke


=== damir_going_for_a_smoke ===

# cts: fade
in 0.25
# mus: . 2
# cts: wait
3

# env: rain_interior.mp3 0 0 -15
# cts: scen
Institute_Floor1_Part1_Damir

# cts: wait
2
# cts: fade
out 0.1
# cts: move 
damir left 24
# cts: move 
damir up 1
# cts: wait
2

# sid: damir_sad
# loc: right
М-да, и куда я пойду в такой дождь...

# cts: wait
2

# spd: 10
# snd: glitch.ogg
\\\\оЖиДаеТСя ПоДКЛюЧеНие...
# spd: 10
# snd: glitch.ogg
\\\\0x42 0xA5 0xBC

# cts: wait
1
# cts: turn 
damir left
# cts: wait
1

# mus: onboard.mp3 0 0 -8
# spd: 10
# snd: glitch.ogg
\\\\оБуЧеНие ЗаВеРШеНо. ЗаПуСТиТЬ СиСТеМу?
# spd: 10
# snd: glitch.ogg
\\\\0x11 0x9C 0xA6
# spd: 10
# snd: glitch.ogg
\\\\ТРеБуеТСя ВВоД.

# cts: wait
1

# sid: damir_bored
# loc: right
Это ещё что?..

# cts: move 
damir down 1
# cts: move 
damir left 19
# cts: turn 
damir up
# cts: wait
1

# spd: 10
# snd: glitch.ogg
\\\\ТРеБуеТСя ВВоД.

# spd: 10
# snd: glitch.ogg
\\\\ТРеБуеТСя ВВоД.

# spd: 10
# snd: glitch.ogg
\\\\ПоДКЛюЧиТСя К ТРеНиРоВоЧНоЙ СиСТеМе? 0x55

# sid: damir_bored
# loc: right
Ну...

# sid: damir_happy
# loc: right
А почему бы и нет?

# cts: move 
damir up 1
# snd: door_open.wav
# cts: fade
in 0.25
# mus: . 6 
# cts: wait
1
# snd: horror_stinger_drum.ogg -10
# cts: wait
5

-> wake_up


=== wake_up ===

# env: horror_ambience.ogg 1 6 -10
# cts: scen
Institute_LabRoom_Night

# cts: fade
out 0.1
# cts: wait
3

# sid: vera_neutral
# loc: right
.........

# sid: vera_doubting
# loc: right
Так, хватит спать. Соберись.

# sid: vera_questioning
# loc: right
Сколько же часов я спала?..

# sid: vera_neutral
# loc: right
Саша? Лида? Дамир?..

# cts: turn 
vera left
# cts: wait 
1
# cts: turn 
vera right
# cts: wait 
1
# cts: turn 
vera up
# cts: wait 
1
# cts: turn 
vera down
# cts: wait 
1

# sid: vera_questioning
# loc: right
Странно, все куда-то ушли. Не могли же они разойтись по домам и не разбудить меня?

# sid: vera_neutral
# loc: right
Надо их разыскать.

-> END
