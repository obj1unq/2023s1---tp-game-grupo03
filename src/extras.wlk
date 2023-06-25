import wollok.game.*
import plantas.*
import configuraciones.*
import randomizer.*

class Objeto{
	var property position
	var property meEstaLlevando = null
	var property pantallaActual = pantallaPrincipal
	
	method iniciar(pantalla) {
		if (pantalla == pantallaActual) game.addVisual(self)
	}
	
	method image()
	
	method position(){
		return if( meEstaLlevando != null ) meEstaLlevando.position() else position
	}
	
	method esDejado(ambiente) {
		position = meEstaLlevando.position()
		pantallaActual = ambiente
		meEstaLlevando = null
	}
	
}

class Elemento inherits Objeto{	
	override method iniciar(pantalla) {
		self.position(randomizer.emptyPosition())
		game.addVisual(self)
	}
	
	method aplicarEfecto(planta)
}

class MonticuloTierra inherits Elemento{
	override method image(){
		return "tierra.png"
	}
	
	override method aplicarEfecto(planta){
		planta.aumentoTierra(10)
		game.removeVisual(self)
	}
}

class BaldeAgua inherits Elemento{
	override method image(){
		return "balde-agua.png"
	}
	
	override method aplicarEfecto(planta){
		planta.aumentoAgua(10)
		game.removeVisual(self)
	}
}

// Esta clase es para agregar un segundo texto a las plantas que podría indicar alguna necesidad a cubrir.
class TextoAtributo
{
	const planta 
	
	method text() = "Necesidad: " + planta.necesidad()
	
	method position() = game.at(self.x(), self.y())
	
	method x()
	{
		return planta.position().x()
	}
	
	method y()
	{
		return planta.position().y() + 1
	}
	
	method textColor() = paleta.verde()
}

object paleta
{
	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property blanco = "FFFFFFFF"
	const property azul = "032EFFF7"
}

const tierra = new MonticuloTierra(position = game.at(6,0))
const agua = new BaldeAgua(position = game.at(7,0))

//Esto estaba comentado en la clase Planta. No lo borro todavia
/*
	 - Si la planta tiene una necesidad, 
	 1° game.removeVisual(self)
	 2° game.addVisual(necesidad, (iconoAgua, iconoTierra, etc) )
	 3° game.addVisual(self)
*/
	// Hay que arreglar el tema de que el personaje quiere agarrar el objeto indicador y no la planta. Debería ignorar el objeto indicador.
//	const property iconoAgua = new IndicadorAgua( planta = self )
//	const property iconoTierra = new IndicadorAgua( planta = self )
//	const property iconoSol = new IndicadorAgua( planta = self )
// method text() = "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
	
	// method textColor() = paleta.verde()
	
	
/*
	method generarBrote()
	{
		const
	}
*/

/*	
	method buscarPosicionLibre()
	{
		return #{game.getObjectsIn( self.position().x() - 1 ), game.getObjectsIn( self.position().x() + 1 ), game.getObjectsIn( self.position().y() - 1 ), game.getObjectsIn( self.position().x() + 1 )}.find({posicion => })
	}
*/

