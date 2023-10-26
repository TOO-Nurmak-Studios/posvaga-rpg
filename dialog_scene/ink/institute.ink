VAR tried_stairs_doors = false
VAR called_for_friends = false
VAR had_first_cockroach_fight = false

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
# sid: vera_neutral
# loc: right
Кабинет 201, там часто работает Владимир Николаевич.

# sid: vera_neutral
# loc: right
Дверь закрыта.
-> END


=== room_202 ===
# sid: vera_neutral
# loc: right
Кабинет 202, лаборатория геофизического анализа.

# sid: vera_neutral
# loc: right
Они недолюбливают нас с тех пор, как Владимир Николаевич получил доступ к "Иртышу". Все их просьбы директор отклонил.

# sid: vera_neutral
# loc: right
Кабинет закрыт. Никого внутри.
-> END


=== news ===
Стенгазета "ЗНАНИЯ - ЭТО СИЛА! НАШ РОДНОЙ ИНСТИТУТ."

"СУПЕРЭВМ НОВЕЙШЕЙ МОДЕЛИ ИРТЫШ-ОУ-2 УСТАНОВЛЕН В ИНСТИТУТЕ ГЕОИНФОРМАТИКИ"

# sid: vera_neutral
# loc: right
Эх, вот бы и у нас была возможность работать с ЭВМ напрямую... Пока всё самое интересное достается Владимиру Николаевичу.

"КОНКУРС НАРОДНОЙ ПЕСНИ В ДОМЕ УЧЁНЫХ, НЕ ПРОПУСТИТЕ!"

# sid: vera_neutral
# loc: right
А вот и важные объявления...

-> END


=== portrait ===
Иосиф Юлианович, профессор, академик, герой социалистического труда. Директор института прикладной геоинформатики.
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
Я хочу спустится к выходу. Может, ребята курят на улице.

# sid: vera_neutral
# loc: right
Нужно спустится по лестнице позади меня.

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