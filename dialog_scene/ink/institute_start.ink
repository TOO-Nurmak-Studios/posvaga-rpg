VAR found_command_book_for_sasha = false

-> start_cutscene 

=== start_cutscene ===

По заказу FITFIJA Entertainment<br>Nurmak Studios представляет...

Ноябрь, 19XX год. Город N. Институт прикладной геоинформатики.

# cts: fade 
off
# cts: wait 
2

# sid: damir_neutral
Как же меня всё это достало!

# sid: vera_doubting
# loc: right
...

# sid: damir_neutral
Мы работали целый день, а толку никакого! Даже половину координат не загнали.

# sid: damir_neutral
И зачем я вообще пошёл в аспирантуру...

# sid: sasha
Сейчас только 8 вечера. Мы ещё успеваем. 

# sid: lida
Я-я не хочу оставаться тут на всю ночь...

# cts: wait 
1
# sid: damir_neutral
Да что б его, опять всё зависло!

# sid: damir_neutral
Это же не у меня одного так? Или я схожу с ума?

# sid: lida
У меня тоже ничего не работает...

# sid: vera_neutral
# loc: right
Ха, вот вам и суперЭВМ.

# sid: sasha
Сейчас разберёмся. Кажется, опять институская сеть перегружена.

# sid: sasha
Так...

# cts: wait 
1
# sid: sasha
Вера, можешь мне подать пособие с командами? Книга была где-то около твоего стола.

# sid: vera_angry
# loc: right
...

# sid: vera_doubting
# loc: right
...ладно, сейчас.

->END


=== talk_damir ===

# sid: damir_bored
И зачем я вообще пошёл в аспирантуру...

# sid: vera_neutral
# loc: right
А в лабу зачем пошёл?

# sid: damir_relaxed
Слишком много вопросов стоит перед советскими учеными!

# sid: damir_sad
Слишком много вопросов стоит перед советскими учеными!

# sid: damir_happy
Слишком много вопросов стоит перед советскими учеными!

# sid: damir_angry
Слишком много вопросов стоит перед советскими учеными!

# sid: damir_neutral
Слишком много вопросов стоит перед советскими учеными!

* [Да]

    # sid: damir_happy
    # loc: left
    Ага
    ->END

* [Нет]

    # sid: damir_angry
    # loc: left
    РРРРР я жолбарыс

->END


=== talk_lida ===

# cts: move
damir left 2
# cts: turn
damir up
# cts: wait
1
# cts: turn
damir down
# cts: wait
1
# cts: move
damir right 2
# cts: wait
1
# cts: fade
in
# cts: wait
1
# cts: fade
out
# cts: wait
1

# sid: lida
Я ввела координаты всех дорог у пруда, и-и тут терминал завис...

# sid: lida
Владимир Николаевич меня убьёт!!.

# sid: vera_neutral
# loc: right
Не бойся, мы с ним как-нибудь справимся.

# sid: vera_neutral
# loc: right
Но сначала нужно всё починить...

->END


=== talk_sasha ===

{ not found_command_book_for_sasha:
    -> talk_sasha_book_not_found
- else:
    -> talk_sasha_got_book
}

=== talk_sasha_book_not_found ===
# sid: sasha
Я могу перейти в режим отладки, но мои дальнейшие попытки тщетны. 

# sid: sasha
Ты не нашла книгу?

# sid: vera_neutral
# loc: right
Продолжаю поиски.

# sid: sasha
Точно помню, что оставил её на столе рядом с тобой. Уверенность абсолютная.

# sid: vera_doubting
# loc: right
Ха, а я бы не была так уверена.

->END


=== wrong_book_floor_1 ===
<придумать текст>
->END

=== wrong_book_floor_2 ===
<придумать текст>
->END

=== wrong_book_desk ===
<придумать текст>
->END

=== wrong_book_shelf_1 ===
<придумать текст>
->END

=== wrong_book_shelf_2 ===
<придумать текст>
->END

=== wrong_book_pile ===
<придумать текст>
->END

=== correct_book ===
~ found_command_book_for_sasha = true
Та самая книга!
->END


=== talk_sasha_got_book ===

# sid: vera_neutral
# loc: right
Держи.

# sid: sasha
То что надо, спасибо. Так, мне нужна глава про отладку...

# sid: sasha
Ага, значит так, и вот так.....

# cts: s 1 wait 1
# sid: damir_neutral
Ну, чего там? Заработало?

# sid: sasha
Очень странно. Сеть действительно перегружена, но я не понимаю, что происходит. Кто-то отправляет команды управления на все ЭВМ в институте...

# sid: lida
! ! !

# sid: sasha
Больше похоже на какой-то сбой. Надо спросить у Владимира Николаевича.

# sid: damir_neutral
Только старого хрыча нам не хватало... 
-> zavlab_entrance


=== zavlab_entrance ===

# cts: turn 
sasha left
# cts: turn 
lida left
# cts: turn 
vera left
# cts: turn 
damir left
#cts: wait
1

# sid: zavlab_neutral
Ну что, товарищи аспиранты? Как продвигается работа?

# sid: lida
В-Владимир Николаевич...

# sid: damir_bored
Почти готово, ха-ха! Работаем в поте лица, даже перекурить некода, ха...

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

# sid: lida
...

# sid: zavlab_smiling
Ну вот и славно! У матросов нет вопросов, да?

# sid: sasha
Владимир Николаевич, у нас тут...

# sid: zavlab_little_smile
Всё, всё, мне надо бежать, завтра мне всё покажете. И чтобы ни строчки не пропустили, запомните!

# cts: walk 
zavlab left 1
# cts: walk 
zavlab up 8
# cts: turn 
sasha down
# cts: turn 
lida down
# cts: turn 
vera up
# cts: turn 
damir up
# cts: wait 
1

# sid: damir_bored
Ну что за фигняяяяя...

# sid: sasha
...

# sid: damir_relaxed
Чёрт с ним, я покурить. Кто-нибудь со мной?

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

# sid: damir_neutral
Чёрт с вами тоже, я пошёл.

# cts: walk 
damir left 4
# cts: walk 
damir up 12

# sid: sasha
Ладно, надо сфокусироваться. Что мы можем сделать в этой ситуации...

# sid: vera_neutral
# loc: right
(как же мне хочется спать...)

# sid: lida
Отключим удаленный доступ, и продолжим работу локально? Что-то ведь должно было сохраниться...

# sid: sasha
Да, но терминал ведёт себя очень странно в любом случае. Может...

# sid: vera_neutral
# loc: right
(......)

-> END
