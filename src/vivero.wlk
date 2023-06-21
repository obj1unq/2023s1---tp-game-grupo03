import extras.*



class Vivero
{
	const tipoVivero= null
	const plantas= #{}
	const capacidad = 3
	
	method agregarPlanta(planta)
	{
		self.validarSiPuedeAlmacenar()
		plantas.add(planta)
	}
	
	method validarSiPuedeAlmacenar()
	{
		return plantas.size() >= capacidad
	}
	
	method aplicarEfecto()
	{
		plantas.forEach{planta=>planta.recibirEfecto(self) } // 
	}
	
	method efecto()
	{
		return necesidad
	}
}

class CuentaRegresiva
	{
		var contador = 0
		
		method iniciarConteo(planta)
		{
			game.onTick( 5000, planta.identity(), {=> self.descontar(planta) ; self.aplicarEfecto(planta)} )
		}
		
		// identity
		
		method descontar(planta)
		{
			{
				if( planta.puedeCrecer() or planta.puedeMarchitarse() )
				{
					contador += 1
				}
			}
		}
			
		method aplicarEfecto(planta)
		{
			if( planta.puedeCrecer() and contador == 5 )
			{
				planta.crecer()
				game.removeTickEvent("planta.toString()")
				}
			}
			else if( planta.puedeMarchitarse() and contador.isEmpty() )
			{
				planta.marchitar()
				game.removeTickEvent("planta.toString()")
			}
		}

	// Contador
/*
1° Debe existir un tiempo global que al avanzar aplique un efecto global a todas las plantas del juego.

2° Cuando una planta llega a cumplir los requisitos para crecer o marchitar, deberá sumar +1 a un contador que al llegar a 5 evaluará si esa planta puede crecer
	o marchitar.
 






















 */	
	
		