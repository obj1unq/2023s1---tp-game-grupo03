import planta.*

class Vivero {
	const tipoVivero= null
	const plantas= #{}
	const capacidad = 3
	const property necesidad = new Necesidad()
	
	method agregarPlanta(planta){
		plantas.add(planta)
		
	}
	
	method aplicarEfecto(){
		plantas.forEach{planta=>planta.recibirEfecto(self)}
	}
	
	method efecto(){
		return necesidad
		
	}

}
