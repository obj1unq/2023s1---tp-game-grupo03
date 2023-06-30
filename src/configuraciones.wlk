import wollok.game.*
import personaje.*
import extras.*
import plantas.*
import entornos.*
import randomizer.*

class Pantalla {

	const property elementos = #{}

	method iniciar() {
		game.clear()
		game.addVisual(self)
		self.configTeclas()
		rocola.cambiarTrack(self.pista())
	}

	method agregarElemento(elemento) {
		elementos.add(elemento)
	}

	method quitarElemento(elemento) {
		elementos.remove(elemento)
	}

	method chequearEstadoDelJuegoParaFinalizacion() {
		game.onTick(5000, "FIN_JUEGO", { self.finalizarJuego()})
	}

	method finalizarJuego() {
		const plantas = elementos.filter({ elemento => elemento.esPlanta() })
		if (self.obtenerFlorecidas(plantas) >= 3 && self.obtenerMarchitas(plantas) < 4) {
			self.ganar()
		} else if (self.obtenerMarchitas(plantas) >= 4) {
			self.perder()
		}
	}

	method obtenerFlorecidas(plantas) {
		return plantas.filter({ planta => planta.etapa() == florecida }).size()
	}

	method obtenerMarchitas(plantas) {
		return plantas.filter({ planta => not planta.esSana() }).size()
	}

	method cerrarJuego() {
		game.schedule(3000, { game.stop()})
	}

	method ganar() {
		timer.removerEventos(self)
		game.say(jardinero, "¡Felicitaciones! ¡GANASTE!")
		self.cerrarJuego()
	}

	method perder() {
		timer.removerEventos(self)
		game.say(jardinero, "Game Over")
		self.cerrarJuego()
	}

	method position() {
		return game.origin()
	}

	method plantasDelEntorno() {
		return timer.plantas().filter({ planta => planta.entorno() == jardinero.ambiente().tipo() })
	}

	method mostrarParametros() {
		self.plantasDelEntorno().forEach({ planta => planta.agregarSiNoExiste(planta.parametros())})
	}

	method quitarParametros() {
		self.plantasDelEntorno().forEach({ planta => planta.quitarSiExiste(planta.parametros())})
	}

	// Todas tienen que declarar su imagen
	method image()

	// La configuración de sus teclas
	method configTeclas()

	method pista()

}

object menuInicial inherits Pantalla {

	override method image() {
		return "menuInicial.png"
	}

	override method configTeclas() {
		keyboard.enter().onPressDo({ pantallaPrincipal.iniciar()})
		keyboard.num1().onPressDo({ pantallaIntrucciones.iniciar()})
	}

	override method pista() {
		return musicaMenu
	}

}

object pantallaPrincipal inherits Pantalla {

	var property image = "exterior.png"

	method tipo() {
		return exterior
	}

	override method configTeclas() {
		keyboard.x().onPressDo({ jardinero.llevar(jardinero.obtenerObjetoDePosicion())})
		keyboard.z().onPressDo({ jardinero.dejar()})
		keyboard.n().onPressDo({ invernaderoNocturno.iniciar()})
		keyboard.d().onPressDo({ invernaderoDiurno.iniciar()})
		keyboard.i().onPressDo({ pantallaIntrucciones.iniciar()})
		keyboard.up().onPressDo{ jardinero.cambiarDireccion(up)}
		keyboard.down().onPressDo{ jardinero.cambiarDireccion(down)}
		keyboard.left().onPressDo{ jardinero.cambiarDireccion(left)}
		keyboard.right().onPressDo{ jardinero.cambiarDireccion(right)}
		keyboard.q().onPressDo{ game.say(jardinero, "Mi posición es" + jardinero.position())}
		keyboard.p().onPressDo{ self.mostrarParametros()
			game.schedule(3000, {=> self.quitarParametros()})
		}
	}

	override method iniciar() {
		super()
		game.addVisual(invernaderoDia)
		game.addVisual(invernaderoNoche)
		game.addVisualCharacter(jardinero)
		self.agregarElemento(pino)
		self.agregarElemento(tierra)
		self.agregarElemento(agua)
		jardinero.ambiente(self)
		jardinero.iniciar(self)
		elementos.forEach({ elemento => elemento.iniciar(self)})
		timer.iniciar(self)
	}

	method llegoAlLimiteDePlantas() {
		return elementos.filter({ elemento => elemento.esPlanta() }).size() >= 8
	}

	override method pista() {
		return musicaMenu
	}

}

object pantallaIntrucciones inherits Pantalla {

	var property image = "instrucciones.png"

	override method configTeclas() {
		keyboard.enter().onPressDo({ pantallaPrincipal.iniciar()})
	}

	override method pista() {
		return musicaMenu
	}

}

class PantallaInvernadero inherits Pantalla {

	override method configTeclas() {
		keyboard.c().onPressDo{ pantallaPrincipal.iniciar()}
		keyboard.i().onPressDo{ pantallaIntrucciones.iniciar()}
		keyboard.x().onPressDo{ jardinero.llevar(jardinero.obtenerObjetoDePosicion())}
		keyboard.z().onPressDo{ jardinero.dejar()}
		keyboard.q().onPressDo{ game.say(jardinero, "Mi posición es" + jardinero.position())}
		keyboard.p().onPressDo{ self.mostrarParametros()
			game.schedule(3000, {=> self.quitarParametros()})
		}
	}

	override method iniciar() {
		super()
		game.addVisualCharacter(jardinero)
		jardinero.iniciar(self)
		jardinero.ambiente(self)
		elementos.forEach({ elemento => elemento.iniciar(self)})
		timer.iniciar(self)
	}

	override method pista() {
		return musicaInvernadero
	}

}

object invernaderoNocturno inherits PantallaInvernadero {

	var property image = "invernadero-interior-nocturno.png"

	method tipo() {
		return invernaderoNoche
	}

}

object invernaderoDiurno inherits PantallaInvernadero {

	var property image = "invernadero-interior-dia.png"

	method tipo() {
		return invernaderoDia
	}

}

object rocola {

	var track = musicaMenu.sonido()

	method iniciar() {
		track.shouldLoop(true)
		track.volume(0.2)
		game.schedule(100, { track.play()})
	}

	method cambiarTrack(musica) {
		if (self.hayTrackSonando()) {
			if (self.hayCambioDeTrack(musica)) {
				track.pause()
				track = musica.sonido()
				track.volume(0.2)
				track.shouldLoop(true)
				self.reproducirTrack()
			}
		} else {
			self.iniciar()
		}
	}

	method hayCambioDeTrack(musica) {
		return track != musica.sonido()
	}

	method hayTrackSonando() {
		return track.played() and not track.paused()
	}

	method trackEstaPausada() {
		return track.played() and track.paused()
	}

	method reproducirTrack() {
		if (self.trackEstaPausada()) {
			track.resume()
		} else {
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

object timer {

	const property plantas = #{ pino }
	const ticks = 500

	method agregarPlanta(planta) {
		plantas.add(planta)
	}

	method removerPlanta(planta) {
		plantas.remove(planta)
	}

	method iniciar(pantalla) {
		const randomNumber = new Range(start = 0, end = 2).anyOne()
		game.onTick(ticks, "CUENTA_REGRESIVA", { self.iniciarCuentasRegresivas(pantalla)})
		if (pantalla.equals(pantallaPrincipal)) {
			game.onTick(10000, "NUEVAS_PLANTAS", { self.aparecerNuevaPlanta(randomNumber, pantalla)})
			game.onTick(8000, "NUEVOS_ELEMENTOS", { self.aparecerNuevosElementos(pantalla)})
		}
		pantalla.chequearEstadoDelJuegoParaFinalizacion()
	}

	method removerEventos(pantalla) {
		if (pantalla.equals(pantallaPrincipal)) {
			game.removeTickEvent("CUENTA_REGRESIVA")
			game.removeTickEvent("NUEVAS_PLANTAS")
			game.removeTickEvent("NUEVOS_ELEMENTOS")
		}
		game.removeTickEvent("FIN_JUEGO")
	}

	method iniciarCuentasRegresivas(pantalla) {
		plantas.forEach({ planta => planta.iniciar(pantalla)})
		plantas.forEach{ planta => planta.temporizador().iniciar(ticks)}
	}

	method aparecerNuevaPlanta(randomNumber, pantalla) {
		if (not pantalla.llegoAlLimiteDePlantas()) {
			var nuevaPlanta
			if (randomNumber == 0) {
				nuevaPlanta = new PlantaPatagonica(esSana = true, position = randomizer.emptyPosition(), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)
			} else if (randomNumber == 1) {
				nuevaPlanta = new PlantaHumeda(esSana = true, position = randomizer.emptyPosition(), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)
			} else {
				nuevaPlanta = new PlantaTropical(esSana = true, position = randomizer.emptyPosition(), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)
			}
			self.agregarPlanta(nuevaPlanta)
			pantalla.agregarElemento(nuevaPlanta)
			game.addVisual(nuevaPlanta)
		}
	}

	method aparecerNuevosElementos(pantalla) {
		const tierra = new MonticuloTierra(position = randomizer.emptyPosition())
		const agua = new BaldeAgua(position = randomizer.emptyPosition())
		tierra.iniciar(pantalla)
		agua.iniciar(pantalla)
		pantalla.agregarElemento(tierra)
		pantalla.agregarElemento(agua)
	}

}

class TemporizadorPlanta {

	const planta
	var tiempoBase = 3000 // 3 seg
	var contadorCrecer = planta.tiempoDeCrecimiento()
	var contadorMarchitar = planta.tiempoDeMarchitarse()
	var contadorEfectos = tiempoBase

	method iniciar(ticks) {
		self.iniciarEfectos(ticks)
		self.iniciarCrecerSiPuede(ticks)
		self.iniciarMarchitarSiPuede(ticks)
	}

	// CRECIMIENTO O DESARROLLO
	method iniciarCrecerSiPuede(ticks) {
		if (planta.puedeCrecer()) {
			self.iniciarCrecimiento(ticks)
		} else if (planta.todasNecesidadesSatisfechas()) {
			self.iniciarDesarrollo(ticks)
		} else { // Mejorar
			contadorCrecer = planta.tiempoDeCrecimiento()
		}
	}

	// CREMIENTO
	method iniciarCrecimiento(ticks) {
		contadorCrecer -= ticks
		if (self.finalizoContador(contadorCrecer)) {
			planta.crecer()
			contadorCrecer = planta.tiempoDeCrecimiento()
		}
	}

	// DESARROLLO
	method iniciarDesarrollo(ticks) {
		contadorCrecer -= ticks
		if (self.finalizoContador(contadorCrecer)) {
			planta.etapa().aplicarDesarrollo(planta)
			contadorCrecer = planta.tiempoDeCrecimiento()
		}
	}

	// MARCHITARSE O DETERIORAR
	method iniciarMarchitarSiPuede(ticks) {
		if (planta.puedeMarchitarse()) {
			self.iniciarMarchitarse(ticks)
		} else if (planta.mayoriaNecesidadesInsatisfechas()) {
			self.iniciarDeterioro(ticks)
		} else {
			contadorMarchitar = planta.tiempoDeMarchitarse()
		}
	}

	// MARCHITARSE
	method iniciarMarchitarse(ticks) {
		contadorMarchitar -= ticks
		if (self.finalizoContador(contadorMarchitar)) {
			planta.marchitar()
			timer.removerPlanta(planta)
			contadorMarchitar = planta.tiempoDeMarchitarse()
		}
	}

	// DETERIORO
	method iniciarDeterioro(ticks) {
		contadorMarchitar -= ticks
		if (self.finalizoContador(contadorMarchitar)) {
			planta.etapa().aplicarDeterioro(planta)
			contadorMarchitar = planta.tiempoDeMarchitarse()
		}
	}

	// EFECTOS DE ENTORNO
	method iniciarEfectos(ticks) { // VER SI CAMBIA DE PANTALLA EL CONTADOR IGUAL SIGUE DESDE DONDE QUEDO
		contadorEfectos -= ticks
		if (self.finalizoContador(contadorEfectos)) {
			planta.recibirEfectos()
			contadorEfectos = tiempoBase
		}
	}

	// COMPROBAR CONTADOR
	method finalizoContador(_contador) {
		return _contador == 0
	}

}

