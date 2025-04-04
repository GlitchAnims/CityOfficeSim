class_name BufScript extends Resource


func WhenInit(buf: Buf) -> void: pass
func HalfSecondTick(buf: Buf) -> void: pass
func FullSecondTick(buf: Buf) -> void: pass
func StackUpdate(buf: Buf, pot_old: int, count_old: int) -> void: pass


func OnHit_Before(buf: Buf, target: Unit, dmg_info: DmgInfo) -> void: pass
func OnHit_After(buf: Buf, target: Unit, dmg_info: DmgInfo, dmg_final: int) -> void: pass

func WhenHit_Before(buf: Buf, from: Unit, dmg_info: DmgInfo) -> void: pass
func WhenHit_After(buf: Buf, from: Unit, dmg_info: DmgInfo, dmg_final: int) -> void: pass

func ReceiveDamage_Before(buf: Buf, dmg_info: DmgInfo) -> void: pass
func ReceiveDamage_After(buf: Buf, dmg_info: DmgInfo, dmg_final: int) -> void: pass
