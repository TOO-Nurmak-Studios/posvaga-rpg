VAR test_dialog_visited = false

{ not test_dialog_visited:
    -> test_dialog
- else:
    -> test_dialog_alternative
}

=== test_dialog ===

~ test_dialog_visited = true

# sid: dean_neutral
# loc: left
Добрый день.

# sid: student_welcome
# loc: right
Здравствуйте.

# sid: dean_smiling
# loc: left
Доброго утра, славяне! Аааааабубэбубэбубээээээээ!.. эээээээ эъ ъъъъ ъъъъъ длиннннооооеее е ъ<br>И с переносом ещё по приколу

# sid: dean_neutral
# loc: left
Вы знаете, зачем мы здесь собрались?

* [Да]

    # sid: dean_neutral
    # loc: left
    Что ж, тогда не будем медлить. Вас отчислили.
    -> END

* [Нет]

    # sid: dean_neutral
    # loc: left
    Ваши успехи в учёбе оставляют желать лучшего. Нам нужно решить этот вопрос.

    # sid: student_neutral
    # loc: right
    ...

    # sid: dean_neutral
    # loc: left
    Что вы можете сказать в своё оправдание?

    ** [Не надо]

        # sid: dean_angry
        # loc: left
        <Взрыв>
        -> END

    ** [Щас тебя порешаю]

        # sid: dean_angry
        # loc: left
        Чё тявкнул, Бобик?
        -> END

=== test_dialog_alternative ===
# sid: dean_neutral
# loc: left
Нам больше не о чем говорить.
-> END