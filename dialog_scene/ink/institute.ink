VAR tried_stairs_doors = false
VAR called_for_friends = false
VAR had_first_cockroach_fight = false
VAR heard_voices = false
VAR hallway_blocked = false
VAR eavesdroped_conversation = false
VAR had_second_cockroach_fight = false
VAR had_optional_cockroach_fight = false
VAR should_start_optional_cockroach_fight = false
VAR lab_has_book = false

-> janitors_room_cockroach


=== looking_for_friends ===
~ called_for_friends = true

# sid: vera_sad
# loc: right
Эй, ребята! Вы тут?

# sid: vera_sad
# loc: right
...есть кто-нибудь?

# sid: vera_neutral
# loc: right
Может, они на первом этаже? Или решили выйти на улицу?..

-> END


=== room_201 ===

Кабинет 201. Личный кабинет Владимира Николаевича, заведующего лабораторией экспериментального геомоделирования.

Дверь закрыта.
-> END


=== room_202 ===

Кабинет 202. Лаборатория геофизического анализа. Кабинет закрыт.

# sid: vera_neutral
# loc: right
Они недолюбливают нас с тех пор, как Владимир Николаевич получил доступ к "Иртышу". Все их просьбы директор отклонил.

-> END


=== room_209 ===

Кабинет 209. Канцелярия.

Дверь закрыта.
-> END

=== room_109 ===

Кабинет 109. Архив.

Дверь закрыта.
-> END

=== room_108 ===

Кабинет 108. Библиотека института.

Дверь закрыта.
-> END

=== news ===
Стенгазета "ЗНАНИЕ - СИЛА! ИНСТИТУТСКИЕ ВЕСТИ."

"СУПЕРЭВМ НОВЕЙШЕЙ МОДЕЛИ ИРТЫШ-ОУ-2 УСТАНОВЛЕН В ИНСТИТУТЕ ГЕОИНФОРМАТИКИ"

# sid: vera_neutral
# loc: right
Эх, вот бы и у нас была возможность работать с ЭВМ напрямую... Пока всё самое интересное достается Владимиру Николаевичу.

"КОНКУРС НАРОДНОЙ ПЕСНИ В ДОМЕ УЧЁНЫХ, НЕ ПРОПУСТИТЕ!"

# sid: vera_neutral
# loc: right
А вот и более важные объявления...

-> END


=== portrait ===
Иосиф Юлианович Кузнецов. Профессор, академик, герой социалистического труда. Директор института прикладной геоинформатики.
-> END

=== toilet ===
# sid: vera_neutral
# loc: right
Туалет. Кажется, никого нет внутри.

# sid: vera_neutral
# loc: right
Продолжу поиски.
-> END

=== stairs_door ===
{ not tried_stairs_doors:
    -> stairs_door_first_interaction
- else:
    -> stairs_door_alternative
}

=== stairs_door_first_interaction ===
~ tried_stairs_doors = true

Двери закрыты на ключ.

# sid: vera_scared
# loc: right
Что за...

# sid: vera_questioning
# loc: right
Так, спокойно. Может, кто-то закрыл выход к лестнице на ночь... но зачем?

# sid: vera_neutral
# loc: right
Я знаю, что запасной ключ от этих дверей должен быть в подсобке. Стоит зайти туда.

-> END


=== stairs_door_alternative ===
Проход к лестинце закрыт. Нужен ключ.

# sid: vera_neutral
# loc: right
Стоит поискать ключ в подсобном помещении.
->END


=== other_floor_part_stop ===
# sid: vera_neutral
# loc: right
Я хочу спуститься к выходу. Может, ребята курят на улице.

# sid: vera_neutral
# loc: right
Нужно пройти по лестнице позади меня.

->END


=== janitors_room_stop ===
Подсобное помещение для обсуживающего персонала.

# sid: vera_questioning
# loc: right
Хм, дверь открыта, но внутри никого. Нужно идти дальше.

-> END

=== janitors_room_cockroach ===

~ had_first_cockroach_fight = true

# sid: vera_scared
# loc: right
Ну и мерзость. Даже не знала, что тараканы могут быть такими огромными.

# sid: vera_neutral
# loc: right
...

# sid: vera_angry
# loc: right
Может, всё-таки уйдешь с дороги, друг? Мне очень нужен этот шкафчик...

-> END


=== janitors_room_cockroach_after_battle ===

# sid: vera_neutral
# loc: right
Отлично, теперь в институте на двух тараканов меньше.

# sid: vera_neutral
# loc: right
А теперь, ключи...

# sid: vera_doubting
# loc: right
...

# sid: vera_angry
# loc: right
Пусто. Кажется, ключи кто-то уже забрал.

# sid: vera_sad
# loc: right
Нужно искать другой путь. Может, лестница в другом крыле не закрыта...

-> END


=== janitors_room_box ===
Шкафчик пуст.
-> END


=== hallway_cabinet_document ===
ИНСТИТУТ ПРИКЛАДНОЙ ГЕОИНФОРМАТИКИ ПРИГЛАШАЕТ ДОБРОВОЛЬЦЕВ ДЛЯ УЧАСТИЯ В НАУЧНЫХ ЭКСПЕРИМЕНТАХ

Любой может приложить руку к науке! Страна зовёт!
-> END


=== voices ===
~ heard_voices = true
~ hallway_blocked = true

# sid: vera_doubting
# loc: right
Кажется, я что-то слышу... Голоса!

# mus: horror_mystery.ogg
# sid: vera_scared
# loc: right
Рядом точно кто-то есть. Но на ребят не похоже...

-> END


=== hallway_stop ===
-> downstairs_stop


=== downstairs_stop ===
# sid: vera_questioning
# loc: right
Я всё ещё слышу чей-то разговор дальше по коридору. Нужно проверить.
-> END


=== director_office ===
{ not eavesdroped_conversation:
    -> director_zavlab_conversation
- else:
    -> director_office_alternative
}

=== director_office_alternative ===
# sid: vera_scared
# loc: right
Кабинет директора института. Я бы держалась отсюда подальше...
-> END

=== director_zavlab_conversation ===
~ eavesdroped_conversation = true
~ hallway_blocked = false

...вынужден повторить: это черезвычайное происшествие, медлить нельзя...

# sid: vera_doubting
# loc: right
(Владимир Николаевич? Я думала, он давно ушёл домой...)

# mus: accumulator_alt.mp3
# sid: zavlab_shouting
Иосиф Юлианыч, послушайте. На кону нечто большее, чем успех проекта...

# spd: 15
# sid: director_neutral
Я всё понимаю. Но стоит избегать поспешных решений.

# sid: vera_scared
# loc: right
(Это же директор нашего института!)

# sid: vera_scared
# loc: right
(Должно быть, произошло что-то серьезное...)

# sid: zavlab_scared
Он захватил нашу сеть. Теперь в этом здании он может контролировать всё!

# sid: zavlab_scared
И он может попытаться подключить кого-то, что ещё хуже...

# spd: 15
# sid: director_concerned
Но ведь вы приняли сдерживающие меры первого уровня?

# sid: zavlab_scared
Да, но я мог недооценить, на что способна обученная на таких данных модель.

# sid: zavlab_scared
Сейчас я предлагаю немедленное уничтожение...

# spd: 16
# sid: director_concerned
Исключено. Мы не можем себе этого позволить - особенно за день до встречи с партийным руководством.

# sid: zavlab_scared
Но...

# sid: director_determined
Никаких но! Нужно найти другой выход.

# sid: director_concerned
Изолируйте программу, не допустив потери данных и оборудования. Обученную модель нужно сохранить для прототипа.

# spd: 14
# sid: director_angry
И... о произошедшем не должен знать никто.

# sid: director_angry
Есть ли в здании кто-нибудь, кроме нас?

# sid: vera_scared
# loc: right
!!!

# sid: zavlab_scared
Э... нет, никого не должно быть. И-и выходы были заблокированы в рамках мер первого уровня.

# sid: director_concerned
Отлично. Значит, обойдется без жертв.

# sid: director_concerned
Тогда немедленно отправляйтесь в вычислительный отсек. Я присоединюсь к вам позже.

# sid: vera_scared
# loc: right
!!!!!!

# cts: turn
vera left
# cts: wait
0.4
# cts: turn
vera right
# cts: wait
0.4
# cts: turn
vera left
# cts: wait
0.4
# cts: turn
vera right
# cts: wait
0.5
# cts: move
vera left 4 sprint
# cts: turn
vera down
# cts: wait
1
# snd: door_open.wav
# cts: anim
door open
# cts: move
zavlab down 7 sprint
# snd: door_close.mp3
# cts: anim
door close
# cts: move
zavlab right 16 sprint
# cts: remv
zavlab
# mus: . 2
# cts: wait
2


# sid: vera_scared
# loc: right
...
# sid: vera_scared
# loc: right
Фууух...

# cts: wait
1
# cts: turn
vera right
# cts: wait
1

# sid: vera_scared
# loc: right
Что-то не так. Надеюсь, с ребятами всё хорошо...

-> END


=== optional_cockroach_fight ===

# sid: vera_neutral
# loc: right
Опять тараканы... Похоже, они выползают, когда в коридорах выключают свет.

# sid: vera_questioning
# loc: right
Может, стоит просто пройти мимо? Дезинсекция института не входит в мои обязанности.

Этот таракан не чувствует страха. Он готов идти до конца.

Как с ним поступить?

* [Напасть]

    ~ had_optional_cockroach_fight = true
    ~ should_start_optional_cockroach_fight = true

    # sid: vera_bored
    # loc: right
    В бой!
    ->END

* [Уйти]

    ~ should_start_optional_cockroach_fight = false

    # sid: vera_neutral
    # loc: right
    Живи... пока.

-> END


=== optional_cockroach_fight_start ===

# sid: vera_scared
# loc: right
Чёрт... Почему их тут так много?
-> END


=== optional_cockroach_fight_finish ===

# sid: vera_bored
# loc: right
Чёртово гнездо... 

# sid: vera_neutral
# loc: right
Надеюсь, после этого они начнут меня бояться.
-> END


=== hallway_cockroaches ===

~ had_second_cockroach_fight = true

# sid: vera_doubting
# loc: right
Кхм... Так...

# sid: vera_angry
# loc: right
Ночью тараканы становятся настолько наглыми, что даже не убегают от меня!

# sid: vera_angry
# loc: right
Придётся прорываться с боем.

-> END


=== hallway_cockroaches_start_battle ===

# sid: vera_scared
# loc: right
Это ещё кто?

# sid: vera_scared
# loc: right
Кажется, другие тараканы его слушаются...

-> END


=== hallway_cockroaches_second_player_attack ===

~ lab_has_book = true

# sid: vera_doubting
# loc: right
Их не так-то просто раздавить. Нужно попробовать что-то ещё.

# sid: vera_questioning
# loc: right
Хм. Нет ли у меня с собой чего-нибудь тяжёлого...

-> END


=== hallway_cockroaches_fifth_cockroach_attack ===

# sid: vera_scared
# loc: right
Если вовремя не уничтожить мелких тараканов, их может стать слишком много...

-> END


=== hallway_cockroaches_after_battle ===

# sid: vera_doubting
# loc: right
Это... Было... Непросто.

# sid: vera_bored
# loc: right
Выход уже совсем рядом. Надо поскорее выбраться отсюда.

-> END


=== first_floor_stairs_door ===
Закрыто.
-> END


=== first_floor_main_exit ===

# sid: vera_doubting
# loc: right
Главный вход... тоже закрыт?

# sid: vera_scared
# loc: right
Чёрт-чёрт-чёрт. Чтоб тебя...

# sid: vera_scared
# loc: right
Ребята, где же вы...

-> END


=== first_floor_secret_door ===

# spd: 10
п-п...

# spd: 10
по...

# snd: horror_stinger_impact.ogg -10
# spd: 10
п-помогиитее...............

# sid: vera_doubting
# loc: right
Что за?

# spd: 5
# sid: vera_doubting
# loc: right
.....

# snd: door_open.wav
# cts: fade
in 0.25

# cts: wait
1

# spd: 5
# sid: vera_doubting
# loc: right
.....

# mus: .
# snd: scream.wav
# sid: vera_scared
# loc: right
!!!!!!!!

# env: . 5
# cts: wait
8

# cts: scen
Fantasy_Start

# mus: feel_like_home.mp3 0 6
# cts: fade
out 0.02


# cts: wait
6
# cts: move
ded down 15
# cts: wait
4

# sid: ded_smiling
# spd: 12
Добро пожаловать в наши земли, герой!

# sid: ded_smiling
# spd: 12
. . . . .

# sid: ded_neutral
# spd: 12
Ах, если бы ты только знал, как долго мы ждали тебя...


# cts: wait
1

# cts: fade
in 0.02

# env: . 10
# mus: . 10
# cts: wait
6

Продолжение следует...

<здесь будет ответ на задание квеста>

# cts: exit
.

-> END


=== battle_failed ===
~ lab_has_book = false
На этот раз тараканы победили...<br>Нужно попробовать ещё раз!
-> END

=== first_cockroach_on_start ===

# sid: vera_bored
# loc: right
Ага, он ещё и не один... Пора их раздавить.

В сражении вы и ваши противники действуете по очереди.

Для перехода в меню способностей нажмите стрелку "вправо".

Способности можно выбирать с помощью стрелок "вниз" и "вверх".

Попробуйте атаковать врага, выбрав способность "Пинок". 
-> END

=== first_cockroach_on_first_attack ===

Таймер над врагом показывает количество ходов до его следующего действия.

Для защиты от вражеских атак можно использовать способность "Защита". 

Эта способность наполовину снизит урон от следующей атаки по вашему персонажу.
-> END

=== first_cockroach_on_second_attack ===

Некоторым способностям требуется время на восстановление - используйте их с умом.

На этом обучение завершено. Следите за вражескими атаками и правильно комбинируйте свои, чтобы достичь победы в дальнейших битвах!

-> END

=== first_cockroach_on_first_enemy_attack ===

# sid: vera_scared
# loc: right
Ай! Больно...
-> END