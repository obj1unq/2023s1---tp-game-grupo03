import wollok.game.*
import plantas.*
import configuraciones.*
import randomizer.*

class Objeto
{
	var property position
	var property meEstaLlevando = null
	var property pantallaActual = pantallaPrincipal
	
	method esPlanta()
	{
		return false
	}
	
	method esNecesidad()
	{
		return false
	}
	
	method iniciar(pantalla)
	{
		if (pantalla == pantallaActual) game.addVisual(self)
	}
	
	method image()
	
	method position(){
		return if( meEstaLlevando != null ) meEstaLlevando.position() else position
	}
	
	method quitarSiExiste(objeto)
	{
		if( game.hasVisual(objeto) )
		{
			game.removeVisual(objeto)
		}
	}
	
	method agregarSiNoExiste(objeto)
	{
		if( not game.hasVisual(objeto) )
		{
			game.addVisual(objeto)
		}
	}

	method esDejado(ambiente) {
		position = meEstaLlevando.position()
		pantallaActual.quitarElemento(self)
		ambiente.agregarElemento(self)
		pantallaActual = ambiente
		meEstaLlevando = null
	}
	
	method aumentoTierra(cantidad) {}
	method aumentoAgua(cantidad) {}
}

class Elemento inherits Objeto{	
	override method iniciar(pantalla) {
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


// Indicadores de necesidad, (cada indicador es un objeto que se genera dentro de la clase Planta).
class Necesidad inherits Objeto
{
	const planta
	method iniciar()
	
	override method esPlanta()
	{
		return false
	}
	
	override method esNecesidad()
	{
		return true
	}
}


class IndicadorExcesoAgua inherits Necesidad
{
	override method image()
	{
		return "excesoAgua.png"
	}
	
	override method iniciar()
	{
		if( planta.nivelAgua() > planta.etapa().maximoAgua() )
		{
			self.agregarSiNoExiste( planta.indicadorExcesoAgua() )		
		}
		else
		{
			self.quitarSiExiste(planta.indicadorExcesoAgua())
		}
	}
}



class IndicadorDeficitAgua inherits Necesidad
{
	override method image()
	{
		return "deficitAgua.png"
	}
	
	override method iniciar()
	{
		if( planta.nivelAgua() < planta.etapa().minimoAgua() )
		{
			self.agregarSiNoExiste( planta.indicadorDeficitAgua() )
		}
		else
		{
			self.quitarSiExiste(planta.indicadorDeficitAgua())
		}
	}
}


class IndicadorExcesoSol inherits Necesidad
{
	override method image()
	{
		return "excesoSol.png"
	}
	
	override method iniciar()
	{
		if( planta.nivelSol() > planta.etapa().maximoSol() )
		{
			self.agregarSiNoExiste( planta.indicadorExcesoSol() )
		}
		else
		{
			self.quitarSiExiste(planta.indicadorExcesoSol())
		}
	}
}


class IndicadorDeficitSol inherits Necesidad
{
	override method image()
	{
		return "deficitSol.png"
	}
	
	override method iniciar()
	{
		if( planta.nivelSol() < planta.etapa().minimoSol() )
		{
			self.agregarSiNoExiste( planta.indicadorDeficitSol() )
		}
		else
		{
			self.quitarSiExiste(planta.indicadorDeficitSol())
		}
	}
}


class IndicadorExcesoTierra inherits Necesidad
{
	override method image()
	{
		return "excesoTierra.png"
	}
	
	override method iniciar()
	{
		if( planta.nivelTierra() > planta.etapa().maximoTierra() )
		{
			self.agregarSiNoExiste( planta.indicadorExcesoTierra() )
		}
		else
		{
			self.quitarSiExiste(planta.indicadorExcesoTierra())
		}
	}
}


class IndicadorDeficitTierra inherits Necesidad
{
	override method image()
	{
		return "deficitTierra.png"
	}
	
	override method iniciar()
	{
		if( planta.nivelTierra() < planta.etapa().minimoTierra() )
		{
			self.agregarSiNoExiste( planta.indicadorDeficitTierra() )
		}
		else
		{
			self.quitarSiExiste(planta.indicadorDeficitTierra())
		}
	}
}