import wollok.game.*

object jardinero {

	var property position = game.at(3, 3)
	var property direccion = right
	var property tieneObjeto = false

	method image() {
		return "jardinero-" + self.imagenSegunDireccion() + ".png"
	}

	method imagenSegunDireccion() {
		return direccion.image()
	}

	method cambiarDireccion(nuevoSentido) {
		direccion = nuevoSentido
	}

	method move(personaje) {
		position = direccion.move(self)
	}

	method obtenerObjetoDePosicion() {
		var objetoEncontrado = null
		const objetos = game.getObjectsIn(self.position())
		if (objetos.size() > 1) {
			objetoEncontrado = objetos.last()
		}
		return objetoEncontrado
	}

	method llevar(objeto) {
		if (self.validarSiPuedeLlevar(objeto)) {
			objeto.meEstaLlevando(self)
			tieneObjeto = true
		}
	}

	method validarSiPuedeLlevar(objeto) {
		return objeto != null && position == objeto.position() && not tieneObjeto
	}

	method dejar(objeto) {
		if (tieneObjeto) {
			objeto.esDejado()
			tieneObjeto = false
		}
	}
}

object right {

	method image() {
		return "right"
	}

	method move(personaje) {
		return personaje.position().right(1)
	}

}

object left {

	method image() {
		return "left"
	}

	method move(personaje) {
		return personaje.position().left(1)
	}

}

object up {

	method image() {
		return "right"
	}

	method move(personaje) {
		return personaje.position().up(1)
	}

}

object down {

	method image() {
		return "left"
	}

	method move(personaje) {
		return personaje.position().down(1)
	}

}

