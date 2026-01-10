class_name PATH

enum KEY{

	ESC,
	SETTING,
	SPECIAL_EFFECTS,
	SOUNDS_BGM
}

@warning_ignore("unused_private_class_variable")
static var _node_path={
	KEY.ESC: NodePath(^"Gui/EscMenu"),
	KEY.SETTING: NodePath(^"Gui/Settings Menu"),
	KEY.SPECIAL_EFFECTS: NodePath(^"Board/SpecialEffects"),
	KEY.SOUNDS_BGM: NodePath(^"Board/SpecialEffects"),
}
