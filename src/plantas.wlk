import wollok.game.*
import extras.*
import configuraciones.*
import entornos.*

class TextoAtributo {
	const planta
	
	method text() = "Agua: " + planta.nivelAgua() + " | " + "Tierra: " + planta.nivelTierra() + " | " + "Sol: " + planta.nivelSol()
	
	method position() = game.at(planta.position().x(), planta.position().y() + 1)
	
	method textColor() = paleta.verde()
}

class Planta inherits Transportable {
	var property esSana = true
	var property etapas = [ brote, intermedio, florecida ]
	var etapa = brote
	var nivelAgua
	var nivelTierra
	var nivelSol
	var desarrollo = 0
	var deterioro = 0
	var property entorno = exterior
	const property temporizador = new TemporizadorPlanta(planta = self) 
	var property indicadorDeficitAgua = new IndicadorDeficitAgua(planta = self)
	var property indicadorExcesoAgua = new IndicadorExcesoAgua(planta = self)
	var property indicadorDeficitSol = new IndicadorDeficitSol(planta = self)
	var property indicadorExcesoSol = new IndicadorExcesoSol(planta = self)
	var property indicadorDeficitTierra = new IndicadorDeficitTierra(planta = self)
	var property indicadorExcesoTierra = new IndicadorExcesoTierra(planta = self)
	var property parametros = new TextoAtributo(planta = self)
	

	method actualizarNecesidades(pantalla) {
		const necesidades = #{ indicadorDeficitAgua, indicadorExcesoAgua, indicadorDeficitSol, indicadorExcesoSol, indicadorDeficitTierra, indicadorExcesoTierra }
		necesidades.forEach({ necesidad => necesidad.iniciar(pantalla)})
	}

	override method iniciar(pantalla)
	{
		if( pantalla == self.pantallaActual() )
		{
			self.actualizarNecesidades(pantalla)
			self.agregarSiNoExiste(self)
		}
	}
	
	method actualizarEtapa() {
		etapa = etapas.first()
	}
	
	override method esDejado(ambiente) {
		super(ambiente)
		entorno = ambiente.tipo()
	}

	override method esPlanta() {
		return true
	}
	
	// method text() = "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
	// method textColor() = paleta.verde()
//	method text(){
//		return "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
//	} 
	
	method tipo()

	method tiempoDeCrecimiento() {
		return self.etapa().tiempoCrecimiento()
	}

	method tiempoDeMarchitarse() {
		return self.etapa().tiempoMarchitar()
	}

	method nivelAgua() {
		return nivelAgua
	}

	method nivelTierra() {
		return nivelTierra
	}

	method nivelSol() {
		return nivelSol
	}

	method desarrollo() {
		return desarrollo
	}

	method deterioro() {
		return deterioro
	}

	method aplicarDesarrollo(cantidad) {
		desarrollo += cantidad
	}

	method aplicarDeterioro(cantidad) {
		deterioro += cantidad
	}

	method etapa() {
		return etapas.first()
	}

	override method image() { 
		return self.tipo() + "-" + self.etapa().toString() + if (self.esSana()) "-sana.png" else "-marchita.png" 
	}

	method crecer() {
		self.validarCrecer()
		etapas = etapas.drop(1)
		desarrollo = 0 
		deterioro = 0 
	}

	method marchitar() {
		esSana = false
	}

	method aumentoSol(cantidad) {
		nivelSol += cantidad
	}

	override method aumentarAgua(cantidad) {
		nivelAgua += cantidad
	}

	override method aumentarTierra(cantidad) {
		nivelTierra += cantidad
	}

	method mayoriaNecesidadesInsatisfechas() {
		return self.etapa().necesidadesSatisfechas(self) < 2
	}

	method puedeMarchitarse()
	{
		return self.mayoriaNecesidadesInsatisfechas() and self.deterioro() >= 99
	}

	method validarCrecer() {
		if (not self.puedeCrecer()) {
			self.error("NO PUEDO CRECER")
		}
	}

	method todasNecesidadesSatisfechas() {
		return self.etapa().necesidadesSatisfechas(self) == 3
	}

	method puedeCrecer() {
		return self.todasNecesidadesSatisfechas() and self.desarrollo() >= 99
	}
	
	method recibirEfectos(){
		self.modificarSol()
		self.modificarAgua()
		self.modificarTierra()
	}
	
	method modificarSol() {
		nivelSol += entorno.solQueAporta()
	}
	
	method modificarAgua() {
		nivelAgua += entorno.aguaQueAporta()
	}
	
	method modificarTierra() {
		nivelTierra += entorno.tierraQueAporta()
	}

}

// Para los distintos tipos de plantas en una iteración del juego se sobreescribirían los métodos de modificar sol, tierra y agua
class PlantaPatagonica inherits Planta {

	override method tipo() {
		return "patagonica"
	}
}

class PlantaHumeda inherits Planta {

	override method tipo() {
		return "humeda"
	}
}

class PlantaTropical inherits Planta {

	override method tipo() {
		return "tropical"
	}
}

class NivelDeCrecimiento {

	method deterioroaAplicar()
	method desarrolloaAplicar()

	method minimoAgua()
	{
		return 40
	}

	method maximoAgua()
	{
		return 70
	}

	method minimoTierra()
	{
		return 60
	}

	method maximoTierra()
	{
		return 90
	} // 90 - 60 = 30

	method minimoSol()
	{
		return 30
	}

	method maximoSol()
	{
		return 60
	}

	method tiempoCrecimiento()
	method tiempoMarchitar()

	method aplicarDeterioro(planta)
	{
		planta.aplicarDeterioro(self.deterioroaAplicar())
	}

	method aplicarDesarrollo(planta)
	{
		planta.aplicarDesarrollo(self.desarrolloaAplicar())
	}

	method necesidadesSatisfechas(planta) {
		return [ self.tieneAguaSuficiente(planta), self.tieneTierraSuficiente(planta), self.tieneSolSuficiente(planta) ].occurrencesOf(true)
	}

	method tieneAguaSuficiente(planta) {
		return planta.nivelAgua().between(self.minimoAgua(), self.maximoAgua())
	}

	method tieneTierraSuficiente(planta) {
		return planta.nivelTierra().between(self.minimoTierra(), self.maximoTierra())
	}

	method tieneSolSuficiente(planta) {
		return planta.nivelSol().between(self.minimoSol(), self.maximoSol())
	}

}

object brote inherits NivelDeCrecimiento {

	override method tiempoMarchitar() {
		return 7000
	}

	override method tiempoCrecimiento() {
		return 5000
	}

	override method deterioroaAplicar() {
		return 33 //En tres ticks llega a 99, se cumple el deterioro >= 99
	}

	override method desarrolloaAplicar() {
		return 50
	}

}

object intermedio inherits NivelDeCrecimiento
{

	override method tiempoMarchitar()
	{
		return 5000
	}

	override method tiempoCrecimiento() {
		return 7000
	}

	override method minimoAgua() {
		return super() * 1.3 // 40 * 1.3 = 52
	}

	override method maximoAgua()
	{
		return super() * 0.9 // 70 * 0.9 = 63 --> 63 - 52 = 11
	}

	override method minimoTierra()
	{
		return super() * 1.3 // 60 * 1.3 = 78
	}

	override method maximoTierra()
	{
		return super() * 0.9 // 90 * 0,9 = 81 --> 81-78 = 3
	}

	override method minimoSol()
	{
		return super() * 1.3 // 30 = 39
	}

	override method maximoSol()
	{
		return super() * 0.9 // 60 = 54 --> 54-39 = 15
	}

	override method deterioroaAplicar()
	{
		return 50 // Se muere en dos ticks
	}

	override method desarrolloaAplicar()
	{
		return 33 // Crece en 3 ticks
	}

}

object florecida inherits NivelDeCrecimiento {

	override method tiempoMarchitar() {
		return 0
	}

	override method tiempoCrecimiento() {
		return 0
	}

	override method deterioroaAplicar() {
		return 0
	}

	override method desarrolloaAplicar() {
		return 0
	}

}

const pino = new PlantaPatagonica(esSana = true, position = game.at(5, 0), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)

