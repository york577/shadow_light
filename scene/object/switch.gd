extends Interactable

#每个场景可能存在多个开关,对应多个灯。
#关卡初始化时绑定开关与物品的关系

var state=Enum.State.YIN

signal open(name)

func interact(_player: Node) -> void:
	open.emit(name)
