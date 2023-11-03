VAR tried_stairs_doors = false
VAR called_for_friends = false
VAR had_first_cockroach_fight = false
VAR heard_voices = false
VAR eavesdroped_conversation = false
VAR had_second_cockroach_fight = false

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
Может, они на первом этаже? Или решили выйти на улицу, несмотря на дождь?..

-> END


=== room_201 ===

Кабинет 201. Личный кабинет Владимира Николаевича.

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
Отлично, теперь в институте на одного таракана меньше.

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

# sid: vera_doubting
# loc: right
Кажется, я что-то слышу... Голоса!

# mus: horror_mystery.ogg
# sid: vera_scared
# loc: right
Рядом точно кто-то есть. Но на ребят не похоже...

-> END


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

...вынужден повторить: это черезвычайное происшествие, медлить нельзя...

# sid: vera_doubting
# loc: right
(Владимир Николаевич? Я думала, он давно ушёл домой...)

# mus: accumulator.mp3
# sid: zavlab_shouting
Иосиф Юлианыч, послушайте. На кону нечто большее, чем успех проекта...

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

# sid: director_concerned
Но ведь вы приняли сдерживающие меры первого уровня?

# sid: zavlab_scared
Да, но я мог недооценить, на что способна обученная на таких данных модель.

# sid: zavlab_scared
Сейчас я предлагаю немедленное уничтожение...

# sid: director_concerned
Исключено. Мы не можем себе этого позволить - особенно за день до встречи с партийным руководством.

# sid: zavlab_scared
Но...

# sid: director_determined
Никаких но! Нужно найти другой выход.

# sid: director_concerned
Изолируйте программу, не допустив потери данных и оборудования. Обученную модель нужно сохранить для прототипа.

# sid: director_angry
И... о произошедшем не должен знать никто.

# sid: director_angry
Есть ли кто-то в здании кто-то кроме нас?

# sid: vera_scared
# loc: right
!!!

# sid: zavlab_scared
Э... нет, никого не должно быть. И-и выходы все заблокированы в рамках мер первого уровня.

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
# cts: wait
2

# sid: vera_scared
# loc: right
...
# mus: .
# sid: vera_scared
# loc: right
Фууух...

# sid: vera_scared
# loc: right
Что-то не так. Надеюсь, с ребятами всё хорошо...

-> END


=== hallway_cockroaches ===

~ had_second_cockroach_fight = true

# sid: vera_neutral
# loc: right
ДРАКА С ТАРАКАНАМИ! ДААААА

-> END


=== hallway_cockroaches_after_battle ===

# sid: vera_neutral
# loc: right
Отлично, теперь в институте на одного таракана меньше.

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

# spd: 10
п-помогиитее.......

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

-> END