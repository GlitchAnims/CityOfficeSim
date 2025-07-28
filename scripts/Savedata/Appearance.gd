class_name Appearance extends Resource

@export var haircolor: Color = Color.WHITE
@export var haircolor_2: Color = Color.WHITE
@export var gender: GENDER = GENDER.undef
@export var skintone: SKINTONE = SKINTONE.blank

@export var face: FACE = FACE.smooth
@export var preset_hair_front: StringName = &""
@export var preset_hair_back: StringName = &""
@export var preset_eyes: StringName = &""
@export var preset_mouth: StringName = &""
@export var preset_features_1: StringName = &""
@export var preset_features_2: StringName = &""

enum FACE{
	smooth, cute, square
}

enum GENDER{
	undef, m, f
}

enum SKINTONE{
	blank, tone_1, tone_2, tone_3, tone_4, tone_5,
}
