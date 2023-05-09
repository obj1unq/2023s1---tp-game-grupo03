import wollok.game.*

class Planta {
	
	var property tipo = null
	var property estado = sana
//	var property nivelCrecimiento = brote
	var property crecimiento = [brote,intermedio]
	const property necesidad = new Necesidad()
	var property position = game.center()
	
	
	method image(){
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
	var property agua = 0
	var property sol = 0
	var property tierraAbonada = 0 
	
	method cambiarNecesidad(necesidad){
		agua += necesidad.agua()
		sol += necesidad.sol()
		tierraAbonada += necesidad.tierraAbonada()
	}
}

object sana {
	
}

object marchita {
	
}


object brote {
	
}

object intermedio{
	
}

object florecida {
	
}
const necesidadPlanta1 = new Necesidad(agua=3, sol=3, tierraAbonada=1)
const planta1 = new Planta(tipo = "planta1", estado = sana, necesidad = necesidadPlanta1, position = game.at(10,3))