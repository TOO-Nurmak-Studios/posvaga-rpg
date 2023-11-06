extends Node

# костыль, нужно будет поменять. когда добавим смену персонажа
# влияет на портрет, отображамый при выборах в диалоге
var main_speaker_id = "vera_neutral"

var speakers_data = {
	
		"vera_neutral"        : SpeakerData.new("vera_neutral", "Вера", true, 0.05),
		"vera_angry"          : SpeakerData.new("vera_angry", "Вера", true, 0.05),
		"vera_doubting"       : SpeakerData.new("vera_doubting", "Вера", true, 0.05),
		"vera_bored"          : SpeakerData.new("vera_bored", "Вера", true, 0.05),
		"vera_questioning"    : SpeakerData.new("vera_questioning", "Вера", true, 0.05),
		"vera_sad"            : SpeakerData.new("vera_sad", "Вера", true, 0.05),
		"vera_scared"         : SpeakerData.new("vera_scared", "Вера", true, 0.05),
		
		"damir_neutral"       : SpeakerData.new("damir_neutral", "Дамир", true, -0.05),
		"damir_angry"         : SpeakerData.new("damir_angry", "Дамир", true, -0.05),
		"damir_bored"         : SpeakerData.new("damir_bored", "Дамир", true, -0.05),
		"damir_happy"         : SpeakerData.new("damir_happy", "Дамир", true, -0.05),
		"damir_relaxed"       : SpeakerData.new("damir_relaxed", "Дамир", true, -0.05),
		"damir_sad"           : SpeakerData.new("damir_sad", "Дамир", true, -0.05),
		
		"sasha_neutral"       : SpeakerData.new("sasha_neutral", "Саша", false, 0.0),
		"sasha_angry"         : SpeakerData.new("sasha_angry", "Саша", false, 0.0),
		"sasha_confused"      : SpeakerData.new("sasha_confused", "Саша", false, 0.0),
		"sasha_scared"        : SpeakerData.new("sasha_scared", "Саша", false, 0.0),
		"sasha_smiling"       : SpeakerData.new("sasha_smiling", "Саша", false, 0.0),
		"sasha_surprised"     : SpeakerData.new("sasha_surprised", "Саша", false, 0.0),
		
		"lida_neutral"        : SpeakerData.new("lida_neutral", "Лида", true, 0.1),
		"lida_angry"          : SpeakerData.new("lida_angry", "Лида", true, 0.1),
		"lida_scared"         : SpeakerData.new("lida_scared", "Лида", true, 0.1),
		"lida_smiling"        : SpeakerData.new("lida_smiling", "Лида", true, 0.1),
		
		"zavlab_neutral"      : SpeakerData.new("zavlab_neutral", "Владимир Николаевич", false, -0.1),
		"zavlab_angry"        : SpeakerData.new("zavlab_angry", "Владимир Николаевич", false, -0.1),
		"zavlab_smiling"      : SpeakerData.new("zavlab_smiling", "Владимир Николаевич", false, -0.1),
		"zavlab_little_smile" : SpeakerData.new("zavlab_little_smile", "Владимир Николаевич", false, -0.1),
		"zavlab_scared"       : SpeakerData.new("zavlab_scared", "Владимир Николаевич", false, -0.1),
		"zavlab_shouting"     : SpeakerData.new("zavlab_shouting", "Владимир Николаевич", false, -0.1),
		
		"director_neutral"    : SpeakerData.new("director_neutral", "Иосиф Юлианович", true, -0.2),
		"director_angry"      : SpeakerData.new("director_angry", "Иосиф Юлианович", true, -0.2),
		"director_concerned"  : SpeakerData.new("director_concerned", "Иосиф Юлианович", true, -0.2),
		"director_determined" : SpeakerData.new("director_determined", "Иосиф Юлианович", true, -0.2),
		"director_scared"     : SpeakerData.new("director_scared", "Иосиф Юлианович", true, -0.2),
	}
