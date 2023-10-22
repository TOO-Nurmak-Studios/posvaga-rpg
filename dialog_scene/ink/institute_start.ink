VAR found_command_book_for_sasha = false

-> start_cutscene 

=== start_cutscene ===

По заказу FITFIJA Entertainment<br>Nurmak Studios представляет...

Ноябрь, 19XX год. Город N. Институт прикладной геоинформатики.

# cts: s 1 fade off
# cts: s 2 wait 2
# sid: damir
Как же меня всё это достало!

# sid: vera_doubting
...

# sid: damir
Мы работали целый день, а толку никакого! Даже половину координат не загнали.

# sid: damir
И зачем я вообще пошёл в аспирантуру...

# sid: sasha
Сейчас только 8 вечера. Мы ещё успеваем. 

# sid: lida
Я-я не хочу оставаться тут на всю ночь...

# cts: s 1 wait 1
# sid: damir
Да что б его, опять всё зависло!

# sid: damir
Это же не у меня одного так? Или я схожу с ума?

# sid: lida
У меня тоже ничего не работает...

# sid: vera_neutral
Ха, вот вам и суперЭВМ.

# sid: sasha
Сейчас разберёмся. Кажется, опять институская сеть перегружена.

# sid: sasha
Так...

# cts: s 1 wait 1
# sid: sasha
Вера, можешь мне подать пособие с командами? Книга была где-то около твоего стола.

# sid: vera_angry
...

# sid: vera_doubting
...ладно, сейчас.

->END


=== talk_damir ===

# sid: damir
И зачем я вообще пошёл в аспирантуру...

# sid: vera_neutral
# loc: right
А в лабу зачем пошёл?

# sid: damir
Слишком много вопросов стоит перед советскими учеными!

->END


=== talk_lida ===

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
# sid: damir
Ну, чего там? Заработало?

# sid: sasha
Очень странно. Сеть действительно перегружена, но я не понимаю, что происходит. Кто-то отправляет команды управления на все ЭВМ в институте...

# sid: lida
! ! !

# sid: sasha
Больше похоже на какой-то сбой. Надо спросить у Владимира Николаевича.

# sid: damir
Только старого хрыча нам не хватало... 
-> zavlab_entrance


=== zavlab_entrance ===

# cts: s 1 walk zavlab down 5
# cts: s 2 walk zavlab right 1
# cts: s 3 turn sasha left
# cts: s 4 turn lida left
# cts: s 5 turn vera left
# cts: s 6 turn damir left
# sid: zavlab
Ну что, товарищи аспиранты? Как продвигается работа?

# sid: lida
В-Владимир Николаевич...

# sid: damir
Почти готово, ха-ха! Работаем в поте лица, даже перекурить некода, ха...

# sid: zavlab
Так я и думал.

# sid: zavlab
Напоминаю вам, что завтра очень важный день! Медлить нельзя, все геоданные должны быть внесены в систему.

# sid: zavlab
Думаю, не надо напоминать, что ваша работа в лаборатории прямо влияет на оценку за практику.

# sid: vera_neutral
(если не надо, то зачем напомнил?)

# sid: zavlab
Верочка, умница, у тебя ко мне какой-то вопрос?

# sid: vera_neutral
Э-э-э, нет, Владимир Николаевич, никаких вопросов...

# sid: lida
...

# sid: zavlab
Ну вот и славно! У матросов нет вопросов, да?

# sid: sasha
Владимир Николаевич, у нас тут...

# sid: zavlab
Всё, всё, мне надо бежать, завтра мне всё покажете. И чтобы ни строчки не пропустили, запомните!

# cts: s 1 walk zavlab left 1
# cts: s 2 walk zavlab up 8
# cts: s 3 turn sasha down
# cts: s 4 turn lida down
# cts: s 5 turn vera up
# cts: s 6 turn damir up
# cts: s 7 wait 1
# sid: damir
Ну что за фигняяяяя...

# sid: sasha
...

# sid: damir
Чёрт с ним, я покурить. Кто-нибудь со мной?

# cts: s 1 turn damir right
# cts: s 2 turn damir up
# cts: s 3 wait 1
# sid: damir
Чёрт с вами тоже, я пошёл.

# cts: s 1 walk damir left 4
# cts: s 2 walk damir up 12
# sid: sasha
Ладно, надо сфокусироваться. Что мы можем сделать в этой ситуации...

# sid: vera
(как же мне хочется спать...)

# sid: lida
Отключим удаленный доступ, и продолжим работу локально? Что-то ведь должно было сохраниться...

# sid: sasha
Да, но терминал ведёт себя очень странно в любом случае. Может...

# sid: vera
(......)

-> END
