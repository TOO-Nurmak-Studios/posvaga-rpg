VAR test_dialog_visited = false

{ not test_dialog_visited:
    -> test_dialog
- else:
    -> test_dialog_alternative
}

=== test_dialog ===

~ test_dialog_visited = true

# sid: zavlab_neutral
# loc: left
Добрый день.

# sid: vera_neutral
# loc: right
Здравствуйте.

# sid: director_determined
# loc: left
Доброго утра, славяне! Ааабубэбубэбубээээээээ!.. эъ длиннннооооеее е ъ<br>И с переносом ещё по приколу

# sid: director_angry
# loc: left
Вы знаете, зачем мы здесь собрались?

* [Да]

    # sid: director_neutral
    # loc: left
    Что ж, тогда не будем медлить. Вас отчислили.
    -> END

* [Нет]

    # sid: director_concerned
    # loc: left
    Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос.

    # sid: vera_questioning
    # loc: right
    ...

    # sid: zavlab_shouting
    # loc: left
    Что вы можете сказать в своё оправдание?

    ** [Не надо]

        # sid: zavlab_angry
        # loc: left
        <Взрыв>
        -> END

    ** [Щас тебя порешаю]

        # sid: zavlab_angry
        # loc: left
        Чё тявкнул, Бобик?
        -> END

=== test_dialog_alternative ===
# sid: zavlab_neutral
# loc: left
Нам больше не о чем говорить.
-> END