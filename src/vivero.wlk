class Vivero {
	const tipoVivero= null
	const plantas= #{}
	const capacidad = 3
	
	method agregarPlanta(planta){
		plantas.add(planta)
		
	}
	
	method aplicarEfecto(){
		plantas.forEach{planta=>planta.recibirEfecto(self)}
	}
	
	method efecto(){
		
	}

}
