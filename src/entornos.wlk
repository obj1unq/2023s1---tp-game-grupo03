import wollok.game.*
import plantas.*

class Intemperie {
	// Los valores de calor varian entre 5 y 10
	// Los valores de humedad varian entre 5 y 10
	var property calor = 5.randomUpTo(10).roundUp() // Int
	var property humedad = 5.randomUpTo(10).roundUp() // Int

	method diaCaluroso() {
		return calor > humedad
	}

	method solQueAporta() {
		if (self.diaCaluroso()) {
			return calor
		} else {
			return ((humedad - calor) * 2)
		}
	}

	method aguaQueAporta() {
		if (self.diaCaluroso()) {
			return - calor
		} else {
			return humedad
		}
	}

	method tierraQueAporta() {
		if (self.diaCaluroso()) {
			return -5
		} else {
			return humedad - calor
		}
	}
}

class Invernadero inherits Intemperie {

	var property position
	var property tipo
	var property rociador

	method image() {
		return "invernadero-" + tipo.toString() + ".png"
	}

	method iniciar() {
		game.addVisual("invernadero-interior-" + tipo + ".png")
	}


}

class InvernaderoDiurno inherits Invernadero {
	var property solInvernadero = 1.randomUpTo(4).roundUp()

	override method solQueAporta() {
		return super() + solInvernadero
	}
	
	
	override method aguaQueAporta() {
		if (rociador) {
			return super().abs()
		} else {
			return super()
		}
	}

	override method tierraQueAporta() {
		return -3
	}

}

class InvernaderoNocturno inherits Invernadero {

	method diaTemplado() {
		return (calor - humedad).abs().between(0,3)
	}	

	override method solQueAporta() {
		if ( self.diaTemplado()) {
			return 0
		}
		else {
			return (calor - humedad).abs() * -1
		}
	}
	
	
	method aguaFueDiaTemplado() {
		if (self.diaTemplado()) {
			return humedad / 2
		}
		else {
			return 0
		}
	}

	override method aguaQueAporta() {
		return super().abs() + self.aguaFueDiaTemplado()
	}

	override method tierraQueAporta() {
		return (super() / 2).roundUp().abs()
	}
}

// --------------------------------------------------------------------- //
//class Intemperie {

//	var property calor = 10 
//	const humedad  = 4/
//	
//	method diaCaluroso() {
//		return calor > humedad
//	}
//	
//	method solQueAporta() {
//		if (self.diaCaluroso()) {
//			return calor
//		}
//		else {
//			return (calor / humedad).roundUp() //-1 * (humedad / 2)
//		}
//	}
//	
//	
//	method aguaQueAporta() {
//		if (self.diaCaluroso()) {
//			return  - humedad
//		}
//		else {
//			return    humedad
//		}
//	}
//	
//	method tierraQueAporta() {
//		if (self.diaCaluroso()) {
//			return -5
//		}
//		else {
//			return (calor - humedad).abs()
//		}
//	}
//}
//
//class InvernaderoDiurno inherits Intemperie {
//	var property position 
//	var property tipo 
//	var property rociador
//	
//	method image() {
//		return "invernadero-" + tipo.toString() + ".png"
//	}
//	
//	method iniciar() {
//		game.addVisual("invernadero-interior-" + tipo + ".png")
//	}	
//	
//	method solDeInvernadero() {
//		return 1.randomUpTo(4)
//	}
//	
//	override method solQueAporta() {
//			return super() + self.solDeInvernadero()
//
//	}
//	
//	
//	override method aguaQueAporta() {
//		if (rociador) {
//			return super().abs()
//		}
//		else {
//			return super()
//		}
//	}
//	
//	override method tierraQueAporta() {
//		return -3
//	}		
//}
//	
//
//class InvernaderoNocturno inherits InvernaderoDiurno {
//	
//	
//	override method solDeInvernadero() {
//		return 0
//	}
//
//	override method solQueAporta() {
//		return super() * -1
//	}
//	
//	override method aguaQueAporta() {
//		return super() + (humedad * 2)
//	}
//	
//	override method tierraQueAporta() {
//		return (super() / 2).roundUp().abs()
//	}
//}
const invernaderoDia = new InvernaderoDiurno(calor = exterior.calor(), humedad = exterior.humedad(),rociador = true, tipo = "dia", position = game.at(10.5, 4.9))  

const invernaderoNoche = new InvernaderoNocturno(calor = exterior.calor(), humedad = exterior.humedad(),rociador = false, tipo = "nocturno",position = game.at(12.5, 4.9)) 

const exterior = new Intemperie()
