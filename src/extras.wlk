import wollok.game.*
import plantas.*
import configuraciones.*
import randomizer.*

class Objeto {
	var property pantallaActual = pantallaPrincipal

	method esNecesidad() {
		return false
	}

	method esPlanta() {
		return false
	}
	
	method iniciar(pantalla) {
		if (pantalla == pantallaActual) game.addVisual(self)
	}

	method image()

	method position()
	
	method quitarSiExiste(objeto) {
		if (game.hasVisual(objeto)) {
			game.removeVisual(objeto)
		}
	}

	method agregarSiNoExiste(objeto) {
		if (not game.hasVisual(objeto)) {
			game.addVisual(objeto)
		}
	}

}

class Transportable inherits Objeto {
	var property position
	var property meEstaLlevando = null
	
	override method position() {
		return if (meEstaLlevando != null) meEstaLlevando.position() else position
	}
	
	method esDejado(ambiente) {
		position = meEstaLlevando.position()
		pantallaActual.quitarElemento(self)
		ambiente.agregarElemento(self)
		pantallaActual = ambiente
		meEstaLlevando = null
	}

	method aumentarTierra(cantidad) {}

	method aumentarAgua(cantidad) {}
}

class Elemento inherits Transportable {

	override method iniciar(pantalla) {
		self.agregarSiNoExiste(self)
	}

	method aplicarEfecto(planta)

}

class MonticuloTierra inherits Elemento {

	override method image() {
		return "tierra.png"
	}

	override method aplicarEfecto(planta) {
		planta.aumentarTierra(10)
		game.removeVisual(self)
	}

}

class BaldeAgua inherits Elemento {

	override method image() {
		return "balde-agua.png"
	}

	override method aplicarEfecto(planta) {
		planta.aumentarAgua(10)
		game.removeVisual(self)
	}

}

class Necesidad inherits Objeto {

	const property planta
	
	method condicion()
	
	method tipoIndicador()
	
	override method position() {
		return planta.position()
	}
	
	override method iniciar(pantalla)
	{
		if (self.condicion())
		{
			self.agregarSiNoExiste(self.tipoIndicador())
		} 
		else
		{
			self.quitarSiExiste(self.tipoIndicador())
		}
	}

	override method esNecesidad() {
		return true
	}

}

class IndicadorExcesoAgua inherits Necesidad {

	override method image() {
		return "excesoAgua.png"
	}
	
	override method tipoIndicador() {
		return planta.indicadorExcesoAgua()
	}
	
	override method condicion() {
		return planta.nivelAgua() > planta.etapa().maximoAgua()
	}

}

class IndicadorDeficitAgua inherits Necesidad {

	override method image() {
		return "deficitAgua.png"
	}
	
	override method tipoIndicador() {
		return planta.indicadorDeficitAgua()
	}
	
	override method condicion() {
		return planta.nivelAgua() < planta.etapa().minimoAgua()
	}

}

class IndicadorExcesoSol inherits Necesidad {

	override method image() {
		return "excesoSol.png"
	}

	override method tipoIndicador() {
		return planta.indicadorExcesoSol()
	}
	
	override method condicion() {
		return planta.nivelSol() > planta.etapa().maximoSol()
	}

}

class IndicadorDeficitSol inherits Necesidad {

	override method image() {
		return "deficitSol.png"
	}

	override method tipoIndicador() {
		return planta.indicadorDeficitSol()
	}
	
	override method condicion() {
		return planta.nivelSol() < planta.etapa().minimoSol()
	}

}

class IndicadorExcesoTierra inherits Necesidad {

	override method image() {
		return "excesoTierra.png"
	}

	override method tipoIndicador() {
		return planta.indicadorExcesoTierra()
	}
	
	override method condicion() {
		return planta.nivelTierra() > planta.etapa().maximoTierra()
	}

}

class IndicadorDeficitTierra inherits Necesidad {

	override method image() {
		return "deficitTierra.png"
	}

	override method tipoIndicador() {
		return planta.indicadorDeficitTierra()
	}
	
	override method condicion() {
		return planta.nivelTierra() < planta.etapa().minimoTierra()
	}

}

object paleta {

	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property blanco = "FFFFFFFF"
	const property azul = "032EFFF7"

}

const tierra = new MonticuloTierra(position = game.at(6,0))
const agua = new BaldeAgua(position = game.at(7,0))

