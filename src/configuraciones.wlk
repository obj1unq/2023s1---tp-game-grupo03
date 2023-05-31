import wollok.game.*
import personaje.*
import extras.*
import invernadero.*

class Pantalla {
	
	method iniciar() { 
		game.clear()
		game.addVisual(self)
		self.configTeclas()
		rocola.cambiarTrack(self.pista())
	}
	
	// Siempre es la misma posicion de fondo
	method position(){return game.origin()}
	
	// Todas tienen que declarar su imagen
	method image()
	
	// La configuración de sus teclas
	method configTeclas()
	
	method pista() // <-- es el número de pista de la rocola
}

object menuInicial inherits Pantalla {
	
	override method image(){ return "menuInicial.png"}
	
	override method configTeclas() {
		keyboard.enter().onPressDo({ pantallaPrincipal.iniciar() })
		keyboard.num1().onPressDo({ pantallaIntrucciones.iniciar() })
	}
	
	override method pista() {return musicaMenu}
}

object pantallaPrincipal inherits Pantalla {
	var property image = "pantallaGeneral.png"
	
	override method configTeclas() {
		keyboard.k().onPressDo({planta1.crecer()})
	    keyboard.x().onPressDo{ jardinero.llevar(jardinero.obtenerObjetoDePosicion()) }
		keyboard.z().onPressDo{ jardinero.dejar(jardinero.obtenerObjetoDePosicion()) }
		keyboard.n().onPressDo{ pantallaInvernadero.iniciar() }
		keyboard.d().onPressDo{ pantallaInvernadero.iniciar() }
		keyboard.i().onPressDo{ pantallaIntrucciones.iniciar() }
	
		keyboard.up().onPressDo { jardinero.cambiarDireccion(up) }
		keyboard.down().onPressDo { jardinero.cambiarDireccion(down) }
		keyboard.left().onPressDo { jardinero.cambiarDireccion(left) }
		keyboard.right().onPressDo { jardinero.cambiarDireccion(right) }
	}
	
	override method iniciar() {
		super()
		game.addVisual(invernaderoDia)
		game.addVisual(invernaderoNoche)
		game.addVisualCharacter(jardinero)
		game.addVisual(planta1)
		game.addVisual(agua)
		game.addVisual(tierra)
	}
	
	override method pista() {return musicaMenu}
}

object pantallaIntrucciones inherits Pantalla {
	var property image = "instrucciones.png"
	
	override method configTeclas() {
		keyboard.enter().onPressDo({ pantallaPrincipal.iniciar() })
	}
	
	override method pista() {return musicaMenu}
}

object pantallaInvernadero inherits Pantalla {
	var property image = "invernadero-interior.png"
	
	override method configTeclas() {
		keyboard.c().onPressDo{ pantallaPrincipal.iniciar() }
		keyboard.i().onPressDo{ pantallaIntrucciones.iniciar() }
		keyboard.x().onPressDo{ jardinero.llevar(jardinero.obtenerObjetoDePosicion()) }
		keyboard.z().onPressDo{ jardinero.dejar(jardinero.obtenerObjetoDePosicion()) }
	}
	
	override method iniciar() {
		super()
		game.addVisualCharacter(jardinero)
		self.validarSiTienePlanta()
	}
	
	override method pista() {return musicaInvernadero}
	
	// TO DO: Mejorar este método para que ingrese al invernadero con planta
	method validarSiTienePlanta() {
		if (jardinero.position() == planta1.position()) {
			game.addVisual(planta1)
		}
	}
}

object rocola {
	
	var track = musicaMenu.sonido()
	
	method iniciar(){
		track.shouldLoop(true)
		track.volume(0.2)
		game.schedule(100,{track.play()})
	}
	
	method cambiarTrack(musica){
		if(self.hayTrackSonando()){
			if(self.hayCambioDeTrack(musica)){
				track.pause()
				track = musica.sonido()
				track.volume(0.2)
				track.shouldLoop(true)
				self.reproducirTrack()
			}
		}else{
			self.iniciar()
		}
	}
	
	method hayCambioDeTrack(musica) {
		return track != musica.sonido()
	}
	
	method hayTrackSonando(){
		return track.played() and not track.paused()
	}
	
	method trackEstaPausada(){	
		return track.played() and track.paused()	
	}	

	method reproducirTrack() {	
		if(self.trackEstaPausada()){	
			track.resume()	
		}else{	
			track.play()	
		}	
	}
}

object musicaMenu {
	
	const property sonido = game.sound("openingSound.wav")
}

object musicaInvernadero {
	
	const property sonido = game.sound("invernaderoSound.mp3")
}