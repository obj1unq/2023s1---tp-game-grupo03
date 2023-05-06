
class Planta {
	
	var property tipo = null
	var property estado = sana
	var property nivelCrecimiento = brote
	const property necesidad = new Necesidad()
	
	
	method image(){
		return tipo.toString()+ "-" + nivelCrecimiento.toString() + "-" + estado.toString() + ".png"
	}
	
	method recibirEfecto(objeto){
		necesidad.cambiarNecesidad(objeto.efecto())
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