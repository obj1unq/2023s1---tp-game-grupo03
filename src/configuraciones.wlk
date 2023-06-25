import wollok.game.*
import personaje.*
import extras.*
import plantas.*
import entornos.*

class Pantalla{
	
	method iniciar(pantalla) {
		game.clear()
		game.addVisual(self)
		self.configTeclas()
		rocola.cambiarTrack(self.pista())
	}
	
	// Siempre es la misma posicion de fondo
	method position()
	{
		return game.origin()
	}
	
	// Todas tienen que declarar su imagen
	method image()
	
	// La configuración de sus teclas
	method configTeclas()
	
	method pista() // <-- Es el número de pista de la rocola
}

object menuInicial inherits Pantalla
{
	override method image()
	{ 
		return "menuInicial.png"
	}
	
	override method configTeclas()
	{
		keyboard.enter().onPressDo({ pantallaPrincipal.iniciar(pantallaPrincipal) })
		keyboard.num1().onPressDo({ pantallaIntrucciones.iniciar(pantallaIntrucciones) })
	}
	
	override method pista()
	{
		return musicaMenu
	}
}


object pantallaPrincipal inherits Pantalla
{
	var property image = "exterior.png"
	
	override method configTeclas()
	{
//		keyboard.k().onPressDo( {pino.crecer()} )
//		keyboard.s().onPressDo( {pino.aumentoSol(5)} )
//		keyboard.a().onPressDo( {pino.aumentoAgua(5)} )
//		keyboard.t().onPressDo( {pino.aumentoTierra(5)} )
//		keyboard.q().onPressDo( {pino.aplicarDesarrollo(100)} )
//      el codigo de arriba comentado lo use para probar el crecimiento de la planta ( y sus excepciones) 
		

		// Objetos
	    keyboard.x().onPressDo( {jardinero.llevar( jardinero.obtenerObjetoDePosicion() )} )
		keyboard.z().onPressDo( {jardinero.dejar()} )
		// keyboard.k().onPressDo( game.say(jardinero, "Los objetos son:" + game.colliders(jardinero) )		
		
		// Pantallas
		keyboard.n().onPressDo( {invernaderoNocturno.iniciar(self)} )
		keyboard.d().onPressDo( {invernaderoDiurno.iniciar(self)} )
		keyboard.i().onPressDo( {pantallaIntrucciones.iniciar(self)} )
	
		// Moverse
		keyboard.up().onPressDo { jardinero.cambiarDireccion(up) }
		keyboard.down().onPressDo { jardinero.cambiarDireccion(down) }
		keyboard.left().onPressDo { jardinero.cambiarDireccion(left) }
		keyboard.right().onPressDo { jardinero.cambiarDireccion(right) }
	}
	
	override method iniciar(pantalla)
	{
		super(self)
		game.addVisual(invernaderoDia)
		game.addVisual(invernaderoNoche)
		game.addVisualCharacter(jardinero)
		//game.addVisual( pino.iconoAgua() ) // Aparecerá por encima del pino
		//game.addVisual(pino)
		agua.iniciar(self)
		tierra.iniciar(self)
		jardinero.ambiente(self)
		pino.iniciar(self)
	}
	
	override method pista() {return musicaMenu}
}


object pantallaIntrucciones inherits Pantalla
{
	var property image = "instrucciones.png"
	
	override method configTeclas()
	{
		keyboard.enter().onPressDo({ pantallaPrincipal.iniciar(pantallaPrincipal) })
	}
	
	override method pista() { return musicaMenu }
}


class PantallaInvernadero inherits Pantalla
{
	override method configTeclas()
	{
		keyboard.c().onPressDo{ pantallaPrincipal.iniciar(pantallaPrincipal) }
		keyboard.i().onPressDo{ pantallaIntrucciones.iniciar(pantallaIntrucciones) }
		keyboard.x().onPressDo{ jardinero.llevar(jardinero.obtenerObjetoDePosicion()) }
		keyboard.z().onPressDo{ jardinero.dejar() }
		keyboard.p().onPressDo{ game.say(jardinero, "Mi posición es" + jardinero.position()) }
	}

	override method iniciar(pantalla)
	{
		super(self)
		game.addVisualCharacter(jardinero)
		jardinero.iniciar(self)
		jardinero.ambiente(self)
		pino.iniciar(self)
	}

	override method pista()
	{
		return musicaInvernadero
	}
}


object invernaderoNocturno inherits PantallaInvernadero
{
	var property image = "invernadero-interior-nocturno.png"
}


object invernaderoDiurno inherits PantallaInvernadero
{
	var property image = "invernadero-interior-dia.png"
}


object rocola
{
	
	var track = musicaMenu.sonido()
	
	method iniciar()
	{
		track.shouldLoop(true)
		track.volume(0.2)
		game.schedule(100,{track.play()})
	}
	
	method cambiarTrack(musica)
	{
		if( self.hayTrackSonando() )
		{
			if( self.hayCambioDeTrack(musica) )
			{
				track.pause()
				track = musica.sonido()
				track.volume(0.2)
				track.shouldLoop(true)
				self.reproducirTrack()
			}
		}
		else
		{
			self.iniciar()
		}
	}
	
	method hayCambioDeTrack(musica)
	{
		return track != musica.sonido()
	}
	
	method hayTrackSonando()
	{
		return track.played() and not track.paused()
	}
	
	method trackEstaPausada()
	{	
		return track.played() and track.paused()	
	}	

	method reproducirTrack()
	{	
		if( self.trackEstaPausada() )
		{	
			track.resume()	
		}
		else
		{	
			track.play()	
		}	
	}
}

object musicaMenu
{
	const property sonido = game.sound("openingSound.wav")
}

object musicaInvernadero
{
	const property sonido = game.sound("invernaderoSound.mp3")
}