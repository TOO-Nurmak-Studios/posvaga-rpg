extends Node

# костыль, нужно будет поменять. когда добавим смену персонажа
var main_speaker_id = "vera_neutral"

var speakers_data = {
	
		"vera_neutral"        : SpeakerData.new("vera_neutral", "Вера"),
		"vera_angry"          : SpeakerData.new("vera_angry", "Вера"),
		"vera_doubting"       : SpeakerData.new("vera_doubting", "Вера"),
		"vera_bored"          : SpeakerData.new("vera_bored", "Вера"),
		"vera_questioning"    : SpeakerData.new("vera_questioning", "Вера"),
		"vera_sad"            : SpeakerData.new("vera_sad", "Вера"),
		"vera_scared"         : SpeakerData.new("vera_scared", "Вера"),
		
		"damir_neutral"       : SpeakerData.new("damir_neutral", "Дамир", true),
		"damir_angry"         : SpeakerData.new("damir_angry", "Дамир", true),
		"damir_bored"         : SpeakerData.new("damir_bored", "Дамир", true),
		"damir_happy"         : SpeakerData.new("damir_happy", "Дамир", true),
		"damir_relaxed"       : SpeakerData.new("damir_relaxed", "Дамир", true),
		"damir_sad"           : SpeakerData.new("damir_sad", "Дамир", true),
		
		"sasha_neutral"       : SpeakerData.new("sasha_neutral", "Саша"),
		"sasha_angry"         : SpeakerData.new("sasha_angry", "Саша"),
		"sasha_confused"      : SpeakerData.new("sasha_confused", "Саша"),
		"sasha_scared"        : SpeakerData.new("sasha_scared", "Саша"),
		"sasha_smiling"       : SpeakerData.new("sasha_smiling", "Саша"),
		"sasha_surprised"     : SpeakerData.new("sasha_surprised", "Саша"),
		
		"lida_neutral"        : SpeakerData.new("lida_neutral", "Лида", true),
		"lida_angry"          : SpeakerData.new("lida_angry", "Лида", true),
		"lida_scared"         : SpeakerData.new("lida_scared", "Лида", true),
		"lida_smiling"        : SpeakerData.new("lida_smiling", "Лида", true),
		
		"zavlab_neutral"      : SpeakerData.new("zavlab_neutral", "Владимир Николаевич"),
		"zavlab_angry"        : SpeakerData.new("zavlab_angry", "Владимир Николаевич"),
		"zavlab_smiling"      : SpeakerData.new("zavlab_smiling", "Владимир Николаевич"),
		"zavlab_little_smile" : SpeakerData.new("zavlab_little_smile", "Владимир Николаевич"),
		"zavlab_scared"       : SpeakerData.new("zavlab_scared", "Владимир Николаевич"),
		"zavlab_shouting"     : SpeakerData.new("zavlab_shouting", "Владимир Николаевич"),
		
		"director_neutral"    : SpeakerData.new("director_neutral", "Иосиф Юлианович", true),
		"director_angry"      : SpeakerData.new("director_angry", "Иосиф Юлианович", true),
		"director_concerned"  : SpeakerData.new("director_concerned", "Иосиф Юлианович", true),
		"director_determined" : SpeakerData.new("director_determined", "Иосиф Юлианович", true),
		"director_scared"     : SpeakerData.new("director_scared", "Иосиф Юлианович", true),
	}
