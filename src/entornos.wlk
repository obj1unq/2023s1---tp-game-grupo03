import wollok.game.*


class Intemperie {
	var property soleado = true  // Bool
	var property calor = 0 // Int
	const humedad  = 0// Int
	
	
	method modificarSol() {
		if (soleado) {
			return calor
		}
		else {
			return -1 * (humedad / 2)
		}
	}
	
	method aguaDeHumedad() {
		return 10
	}
	
	method modificarAgua() {
		if (soleado) {
			return -5
		}
		else {
			return self.aguaDeHumedad()
		}
	}
	
	method modificarTierra() {
		if (soleado) {
			return (calor / 2).min(10)
		}
		else {
			return 5 + (humedad - calor)
		}
	}
}

class InvernaderoDiurno inherits Intemperie {
	var property position 
	var property tipo 
	var property rociador
	
	method image() {
		return "invernadero-" + tipo.toString() + ".png"
	}
	
	method iniciar() {
		game.addVisual("invernadero-interior-" + tipo + ".png")
	}	
	
	override method calor() {
		return exterior.calor()
	}
	
	method diaCaluroso() {
		return self.calor() > humedad
	}
	
	override method modificarSol() {
		if (soleado) {
			return super() / 2
		}
		else {
			return super() + (humedad / 3)
		}
	}
	
	
	override method modificarAgua() {
		if (soleado) {
			return (super() - rociador).max(5)
		}
		else {
			return super() + 5
		}
	}
	
	override method modificarTierra() {
		if ( not (self.diaCaluroso())) {
			return 10
		}
		else {
			return -6
		}
	}		
}
	

class InvernaderoNocturno inherits InvernaderoDiurno {
	
	override method soleado() {
		soleado = false
	}
		
	override method modificarSol() {
		return rociador - calor
	}
	
	override method modificarAgua() {
		return super() + self.aguaDeHumedad() + 5
	}
	
	override method modificarTierra() {
		if ( not (self.diaCaluroso())) {
			return super() * 2
		}
		else {
			return super() / 2
		}
	}	
}



const exterior = new Intemperie (calor = 30, soleado = true, humedad = 40)
const invernaderoDia = new InvernaderoDiurno(humedad = 20,calor = exterior.calor(), soleado = true, rociador = 5, tipo = "dia", position = game.at(7,3))
const invernaderoNoche = new InvernaderoNocturno(humedad = 20, rociador = 10, calor = 30, tipo = "nocturno", position = game.at(13,3))
