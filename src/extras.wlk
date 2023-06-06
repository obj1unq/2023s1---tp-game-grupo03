import wollok.game.*

class Objeto {
	var property position
	var property meEstaLlevando = null
	
	method image()
	
	method position() {
		return if (meEstaLlevando != null) meEstaLlevando.position() else position
	}
	
	method esDejado() {
		position = meEstaLlevando.position()
		meEstaLlevando = null
	}
	
}

class Agua inherits Objeto {

	override method image() {
		return "balde-agua.png"
	}
	
}

class Tierra inherits Objeto {

	override method image() {
		return "tierra.png"
	}
	
}

class Planta inherits Objeto {
	// var property entorno -> dia o noche , con onTick le manda mensaje que corresponda para cada efecto (jardinero podria ser otro entorno)
	
	var property tipo = null
	var property estado = sana
//	var property nivelCrecimiento = brote
	var property crecimiento = [brote,intermedio,florecida]
	const property necesidad = new Necesidad()
	
	override method image() {
		return tipo.toString()+ "-" + self.nivelCrecimiento().toString() + "-" + estado.toString() + ".png"
	}
	
	method recibirEfecto(objeto){
		necesidad.cambiarNecesidad(objeto.efecto())
	}
	
	method crecer(){
		crecimiento = crecimiento.drop(1)
		
	}
	method nivelCrecimiento(){
		return crecimiento.first()
	}
	
}

class Necesidad {
	// Propiedades o atributos de planta - Esta clase no va
	var property agua = 0
	var property sol = 0
	var property tierraAbonada = 0 
	
	method cambiarNecesidad(necesidad){
		agua += necesidad.agua()
		sol += necesidad.sol()
		tierraAbonada += necesidad.tierraAbonada()
	}
}


class NivelCrecimiento {
	// Lista de necesidades va aca y se hace u all para chequear que se cumplan todas para crecer
	var property nivelAguaCorrecto = 0
	var property nivelSolCorrecto = 0 
	var property nivelTierraCorrecto =0 
	var property diferenciaAceptada =0
	
	
	method tieneAguaSuficiente(planta){
		return planta.necesidad().agua().between(nivelAguaCorrecto - diferenciaAceptada, nivelAguaCorrecto + diferenciaAceptada)
	}
	
	method tieneSolSuficiente(planta){
		return planta.necesidad().sol().between(nivelSolCorrecto - diferenciaAceptada, nivelSolCorrecto + diferenciaAceptada)
	}
	
	method tieneTierraSuficiente(planta){
		return planta.necesidad().tierraAbonada().between(nivelTierraCorrecto - diferenciaAceptada, nivelTierraCorrecto + diferenciaAceptada)
	}
	
	method puedeCrecer(planta){
		return self.cantidadNecesidadesSatisfechas(planta) == 3
	}
	
	method puedeMarchitarse(planta){
		return self.cantidadNecesidadesSatisfechas(planta) <= 1
	}
	
	method cantidadNecesidadesSatisfechas(planta){
		return [self.tieneAguaSuficiente(planta), self.tieneSolSuficiente(planta), self.tieneTierraSuficiente(planta)].occurrencesOf(true)
	}
	
	
}

object brote inherits NivelCrecimiento {
	
}

object intermedio inherits NivelCrecimiento{
	
}

object florecida inherits NivelCrecimiento{
	
}

object sana {
	
}

object marchita {
	
}

const necesidadPlanta1 = new Necesidad(agua=3, sol=3, tierraAbonada=1)
const planta1 = new Planta(tipo = "planta1", estado = sana, necesidad = necesidadPlanta1, position = game.at(7,3))
const planta2 = new Planta(tipo = "planta1", estado = sana, necesidad = necesidadPlanta1, position = game.at(5,4))
const agua = new Agua(position = game.at(10,8))
const tierra = new Tierra(position = game.at(12,4))