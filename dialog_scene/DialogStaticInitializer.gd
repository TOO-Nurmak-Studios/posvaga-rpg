extends Node

# костыль, нужно будет поменять. когда добавим смену персонажа
var main_speaker_id = "vera_neutral"

var speakers_data = {
		"dean_angry"       : SpeakerData.new("dean_angry", "Декан"),
		"dean_neutral"     : SpeakerData.new("dean_neutral", "Декан"),
		"dean_smiling"     : SpeakerData.new("dean_smiling", "Декан"),

		"student_neutral"  : SpeakerData.new("student_neutral", "Студент"),
		"student_welcome"  : SpeakerData.new("student_welcome", "Студент"),
		
		"vera_neutral"     : SpeakerData.new("vera_neutral", "Вера"),
		"vera_angry"       : SpeakerData.new("vera_angry", "Вера"),
		"vera_doubting"    : SpeakerData.new("vera_doubting", "Вера"),
		"vera_bored"       : SpeakerData.new("vera_bored", "Вера"),
		"vera_questioning" : SpeakerData.new("vera_questioning", "Вера"),
		"vera_sad"         : SpeakerData.new("vera_sad", "Вера"),
		"vera_scared"      : SpeakerData.new("vera_scared", "Вера"),
		
		"damir_neutral"    : SpeakerData.new("damir_neutral", "Дамир", true),
		"damir_angry"      : SpeakerData.new("damir_angry", "Дамир", true),
		"damir_bored"      : SpeakerData.new("damir_bored", "Дамир", true),
		"damir_happy"      : SpeakerData.new("damir_happy", "Дамир", true),
		"damir_relaxed"    : SpeakerData.new("damir_relaxed", "Дамир", true),
		"damir_sad"        : SpeakerData.new("damir_sad", "Дамир", true),
		
		"sasha_neutral"    : SpeakerData.new("sasha_neutral", "Саша"),
		"sasha_angry"      : SpeakerData.new("sasha_angry", "Саша"),
		"sasha_scared"     : SpeakerData.new("sasha_scared", "Саша"),
		"sasha_smiling"    : SpeakerData.new("sasha_smiling", "Саша"),
		"sasha_surprised"  : SpeakerData.new("sasha_surprised", "Саша"),
		
		"lida"             : SpeakerData.new("lida", "Лида"),
		
		"zavlab_neutral"   : SpeakerData.new("zavlab_neutral", "Владимир Николаевич"),
		"zavlab_angry"     : SpeakerData.new("zavlab_angry", "Владимир Николаевич"),
		"zavlab_smiling"   : SpeakerData.new("zavlab_smiling", "Владимир Николаевич"),
		"zavlab_little_smile" : SpeakerData.new("zavlab_little_smile", "Владимир Николаевич"),
		"zavlab_scared"    : SpeakerData.new("zavlab_scared", "Владимир Николаевич"),
		"zavlab_shouting"  : SpeakerData.new("zavlab_shouting", "Владимир Николаевич"),
	}
