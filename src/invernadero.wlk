import wollok.game.*

class Invernadero {
	var property tipo
	var property position
	
	method image() {
		return "invernadero-" + tipo.image() + ".png"
	}
}

object nocturno {
	method image() {
		return "nocturno"
	}
}

object diurno {
	method image() {
		return "dia"
	}
}

const invernaderoDia = new Invernadero(tipo = diurno, position = game.at(9,4))
const invernaderoNoche = new Invernadero(tipo = nocturno, position = game.at(14,4))