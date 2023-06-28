import wollok.game.*
import extras.*
import configuraciones.*


class Planta inherits Objeto{
	
	var property estado = sana
	var property etapas = [brote, intermedio, florecida]
	var nivelAgua
	var nivelTierra
	var nivelSol
	var desarrollo = 0
	var deterioro = 0

	const property temporizador = new TemporizadorPlanta(planta=self) // tiene que ser el utimo atributo porque necesita recibir a la planta ya con sus atributos definidos
	
	var property indicadorDeficitAgua = new IndicadorDeficitAgua( planta = self, position = self.position(), meEstaLlevando = self )
	var property indicadorExcesoAgua = new IndicadorExcesoAgua( planta = self, position = self.position(), meEstaLlevando = self )
	var property indicadorDeficitSol = new IndicadorDeficitSol( planta = self, position = self.position(), meEstaLlevando = self )
	var property indicadorExcesoSol = new IndicadorExcesoSol( planta = self, position = self.position(), meEstaLlevando = self )
	var property indicadorDeficitTierra = new IndicadorDeficitTierra( planta = self, position = self.position(), meEstaLlevando = self )
	var property indicadorExcesoTierra = new IndicadorExcesoTierra( planta = self, position = self.position(), meEstaLlevando = self )

	method actualizarNecesidades()
	{
		const necesidades = #{indicadorDeficitAgua, indicadorExcesoAgua, indicadorDeficitSol, indicadorExcesoSol, indicadorDeficitTierra, indicadorExcesoTierra}
		necesidades.forEach({ necesidad => necesidad.iniciar() })
	}
	
	override 	method iniciar(pantalla)
	{
		if( pantalla == self.pantallaActual() )
		{
			self.quitarSiExiste(self)
			self.actualizarNecesidades()
			game.addVisual(self)
		}	
	}

	override method esPlanta() {
		return true
	}
	
	method text() // = "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
	
	method tipo()
	
	method tiempoDeCrecimiento(){
		return self.etapa().tiempoCrecimiento()
	}
	method tiempoDeMarchitarse(){
		return self.etapa().tiempoMarchitar()
	}
	
	method nivelAgua(){
		return nivelAgua
	}
	method nivelTierra(){
		return nivelTierra
	}
	method nivelSol(){
		return nivelSol
	}
	method desarrollo(){
		return desarrollo
	}
	method deterioro(){
		return deterioro
	}
	
	/*
	method aplicarEfecto(planta) {		
		game.say(self, "Ya hay una planta en esta posición.")
	}
	*/
	
	method aplicarDesarrollo(cantidad)/*suma "cantidad" a la variable desarrollo*/{
		desarrollo += cantidad
	}
	
	method aplicarDeterioro(cantidad)/*suma "cantidad" a la variable deterioro*/{
		deterioro += cantidad
	}
	
	method etapa()/*devuelve el primer elemento del listado etapas */{
		return etapas.first()
	}
	
	override method image(){
		return self.tipo() + "-" + self.etapa().toString() + "-" + estado.toString() + ".png"
	}
	method crecer(){
		self.validarCrecer()
		etapas = etapas.drop(1)
		desarrollo = 0 //self.aplicarDesarrollo(0) // El valor desarrollo vuelve a cero.
		deterioro = 0 //self.aplicarDeterioro(0) // El valor deterioso vuelve a cero.
	}
	method marchitar(){
		estado = marchita
	}
	method aumentoSol(cantidad){
		nivelSol += cantidad
	}
	override method aumentoAgua(cantidad){
		nivelAgua += cantidad
	}
	override method aumentoTierra(cantidad){
		nivelTierra += cantidad
	}
	
	method mayoriaNecesidadesInsatisfechas()/*condicion para aplicar deterioro*/{
		return self.etapa().necesidadesSatisfechas(self) < 2
	}
	
	method puedeMarchitarse(){
		return self.mayoriaNecesidadesInsatisfechas() and self.deterioro() >= 99
	}
	
	method validarCrecer(){
		if (not self.puedeCrecer()){
			self.error("NO PUEDO CRECER")
		}
	}
	
	method todasNecesidadesSatisfechas()/*condicion para aplicar desarrollo*/{
		return self.etapa().necesidadesSatisfechas(self) == 3
	}
	
	method puedeCrecer(){
		return self.todasNecesidadesSatisfechas() and self.desarrollo() >= 99
	}
	
	method recibirEfectos(){
		//los efectos van a ser recibidos del entorno
		//solo por ahora simplemente se le va descontar 5 a cada necesidad
		//para que haga algo por ahora. REEMPLAZAR CUANDO YA ESTE LO DE ENTORNO
		nivelAgua -=5
		nivelTierra-=5
		nivelSol-=5
	}
}

class PlantaPatagonica inherits Planta{
	override method tipo(){
		return "patagonica"
	}
	//esto me suena raro que quede tan vacio. Cualquier cosa lo revisamos despues
}


class PlantaHumeda inherits Planta{
	override method tipo(){
		return "humeda"
	}
	//esto me suena raro que quede tan vacio. Cualquier cosa lo revisamos despues
}

class PlantaTropical inherits Planta{
	override method tipo(){
		return "tropical"
	}
	//esto me suena raro que quede tan vacio. Cualquier cosa lo revisamos despues
}



class NivelDeCrecimiento{
	method deterioroaAplicar()
	
	method desarrolloaAplicar()
	
	method minimoAgua(){
		return 40
	}
	method maximoAgua(){
		return 70
	}
	method minimoTierra(){
		return 60
	}
	method maximoTierra(){
		return 90
	}
	method minimoSol(){
		return 30
	}
	method maximoSol(){
		return 60
	}
	method tiempoCrecimiento()
	method tiempoMarchitar()

	method aplicarDeterioro(planta){
		planta.aplicarDeterioro(self.deterioroaAplicar())
	}

	method aplicarDesarrollo(planta){
		planta.aplicarDesarrollo(self.desarrolloaAplicar())
	}

	method necesidadesSatisfechas(planta){
		return [self.tieneAguaSuficiente(planta),self.tieneTierraSuficiente(planta),self.tieneSolSuficiente(planta)].occurrencesOf(true)
	}
	method tieneAguaSuficiente(planta){
		return planta.nivelAgua().between(self.minimoAgua(), self.maximoAgua())
	}
	method tieneTierraSuficiente(planta){
		return planta.nivelTierra().between(self.minimoTierra(), self.maximoTierra())
	}
	method tieneSolSuficiente(planta){
		return planta.nivelSol().between(self.minimoSol(), self.maximoSol())
	}
	
}

object brote inherits NivelDeCrecimiento{
	override method tiempoMarchitar(){
		return 7000
	}
	
	override method tiempoCrecimiento(){
		return 5000
	}
	
	override method deterioroaAplicar(){
		return 33
	}
	
	override method desarrolloaAplicar(){
		return 50
	}

}

object intermedio inherits NivelDeCrecimiento{
	override method tiempoMarchitar(){
		return 5000
	}
	override method tiempoCrecimiento(){
		return 7000
	}
	
	
	override method minimoAgua(){
		return super()* 1.3
	}
	override method maximoAgua(){
		return super()* 0.9
	}
	override method minimoTierra(){
		return super()* 1.3
	}
	override method maximoTierra(){
		return super()* 0.9
	}
	override method minimoSol(){
		return  super()* 1.3
	}
	override method maximoSol(){
		return super()* 0.9
	}
	override method deterioroaAplicar(){
		return 50
	}
	
	override method desarrolloaAplicar(){
		return 33
	}
}

object florecida inherits NivelDeCrecimiento{
	override method tiempoMarchitar(){
		return 0
	}
	override method tiempoCrecimiento(){
		return 0
	}
	
	override method deterioroaAplicar(){
		return 0
	}
	
	override method desarrolloaAplicar(){
		return 0
	}

}



object sana{}
object marchita{}



const indicadorPino = new TextoAtributo( planta = pino )
const pino = new PlantaPatagonica(estado = sana, position = game.at(5,0), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)


