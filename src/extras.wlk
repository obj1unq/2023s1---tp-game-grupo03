import wollok.game.*

class Objeto
{
	var property position
	var property meEstaLlevando = null
	
	method image()
	
	method position()
	{
		return if( meEstaLlevando != null ) meEstaLlevando.position() else position
	}
	
	method esDejado()
	{
		position = meEstaLlevando.position()
		meEstaLlevando = null
	}
}

class Elemento inherits Objeto
{	
	method aplicarEfecto(planta)
}


class Tierra inherits Elemento
{
	override method image()
	{
		return "tierra.png"
	}
	
	override 	method aplicarEfecto(planta)
	{
		planta.aumentoAgua(10)
	}
}

class Agua inherits Elemento
{
	override method image()
	{
		return "balde-agua.png"
	}
	
	override 	method aplicarEfecto(planta)
	{
		planta.aumentoTierra(10)
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

const indicadorPino = new TextoAtributo( planta = pino )



object paleta
{
	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property blanco = "FFFFFFFF"
	const property azul = "032EFFF7"
}



class Planta inherits Objeto
{
	var property estado = sana
	var etapa = [brote, intermedio, florecida]
	var nivelAgua
	var nivelTierra
	var nivelSol
	const property tipo // tropical, patagonica ó humeda
	var desarrollo = 0
	var deterioro = 0

	method text() = "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
	
	method textColor() = paleta.verde()
	
	method nivelAgua()
	{
		return nivelAgua
	}
	
	method nivelTierra()
	{
		return nivelTierra
	}
	
	method nivelSol()
	{
		return nivelSol
	}
	
	method desarrollo()
	{
		return desarrollo
	}
	
	method deterioro()
	{
		return deterioro
	}
	
	method aplicarDesarrollo(cantidad)
	{
		desarrollo += cantidad
	}
	
	method aplicarDeterioro(cantidad)
	{
		deterioro += cantidad
	}
	
	override method image()

	{
		return tipo.toString() + "-" + self.etapa().toString() + "-" + estado.toString() + ".png"
	}
	
	method etapa()
	{
		return etapa.first()
	}
	
	method crecer()
	{
		etapa = etapa.drop(1)	
	}
	
	method aplicarEfecto(elemento)
	{
		elemento.aplicarEfecto(self)
	}
	
	method aumentoAgua(cantidad)
	{
		nivelAgua += cantidad
	}
	
	method aumentoTierra(cantidad)
	{
		nivelTierra += cantidad
	}
	
	method puedeCrecer()
	{
		return tipo.necesidadesSatisfechas(self) == 3
	}
	
	method puedeMarchitarse()
	{
		return tipo.necesidadesSatisfechas(self) < 2
	}
	
	
}


class TipoDePlanta
{	
	const property listaDeNecesidades = #{ self.tieneAguaSuficiente(planta), self.tieneAguaSuficiente(planta), self.tieneAguaSuficiente(planta) }
	
	method tieneAguaSuficiente(planta)
	
	method tieneSolSuficiente(planta)

	method tieneTierraSuficiente(planta)	
	
	method necesidadesSatisfechas(planta)
	{
		return [self.tieneAguaSuficiente(planta), self.tieneSolSuficiente(planta), self.tieneTierraSuficiente(planta)].occurrencesOf(true)
	}
	
/*
	method necesidadInsatisfecha(planta)
	{
		return [self.tieneAguaSuficiente(planta), self.tieneSolSuficiente(planta), self.tieneTierraSuficiente(planta)].findOrDefault( {necesidad => necesidad})
	}
		La idea sería colocar otro texto encima de las plantas que indique alguna necesidad insatisfecha.
*/

}

object tropical inherits TipoDePlanta
{
	override	method tieneAguaSuficiente(planta)
	{
		return planta.nivelAgua().between(30, 60)
	}
	
	override	method tieneSolSuficiente(planta)
	{
		return planta.nivelSol().between(70, 100)
	}
	
	override	method tieneTierraSuficiente(planta)
	{
		return planta.nivelTierra().between(40, 70)
	}
}

object patagonica inherits TipoDePlanta
{
	override	method tieneAguaSuficiente(planta)
	{
		return planta.nivelAgua().between(40, 70)
	}
	
	override	method tieneSolSuficiente(planta)
	{
		return planta.nivelSol().between(30, 60)
	}
	
	override	method tieneTierraSuficiente(planta)
	{
		return planta.nivelTierra().between(60, 90)
	}
}

object humeda inherits TipoDePlanta
{
	override	method tieneAguaSuficiente(planta)
	{
		return planta.nivelAgua().between(70, 100)
	}
	
	override	method tieneSolSuficiente(planta)
	{
		return planta.nivelSol().between(50, 80)
	}
	
	override	method tieneTierraSuficiente(planta)
	{
		return planta.nivelTierra().between(40, 70)
	}
}


class NivelDeCrecimiento
{
	method aplicarDeterioro(planta)
	
	method aplicarDesarrollo(planta)
}

object brote inherits NivelDeCrecimiento
{
	override method aplicarDeterioro(planta)
	{
		planta.aplicarDeterioro(33)
	}
	
	override method aplicarDesarrollo(planta)
	{
		planta.aplicarDesarrollo(50)
	}
}

object intermedio inherits NivelDeCrecimiento
{
	override method aplicarDeterioro(planta)
	{
		planta.aplicarDeterioro(50)
	}
	
	override method aplicarDesarrollo(planta)
	{
		planta.aplicarDesarrollo(33)
	}
}

object florecida inherits NivelDeCrecimiento
{
	override method aplicarDeterioro(planta)
	{
		planta.aplicarDeterioro(33)
	}
	
	override method aplicarDesarrollo(planta)
	{
		planta.aplicarDesarrollo(25)
	}
}

object sana{}
object marchita{}


const palmera = new Planta(tipo = "tropical", estado = sana, position = game.at(7,3), nivelAgua = 45, nivelSol = 85, nivelTierra = 55)
const pino = new Planta(tipo = "patagonica", estado = sana, position = game.at(5,0), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)
const orquidea = new Planta(tipo = "humeda", estado = sana, position = game.at(7,5), nivelAgua = 85, nivelSol = 60, nivelTierra = 55)
const agua = new Agua(position = game.at(10,8))
const tierra = new Tierra(position = game.at(12,4))

