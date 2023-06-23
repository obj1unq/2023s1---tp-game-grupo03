import wollok.game.*

//class Necesidad
//{
//	const planta
//		
//	method image()
//	
//	method position()
//	{
//		return planta.position()
//	}
//}
//
//class IndicadorAgua inherits Necesidad
//{
//	override method image()
//	{
//		return "necesidadAgua.png"
//	}
//}
//
//class IndicadorTierra inherits Necesidad
//{
//	override method image()
//	{
//		return "necesidadTierra.png"
//	}
//}
//
//class IndicadorSol inherits Necesidad
//{
//	override method image()
//	{
//		return "necesidadSol.png"
//	}
//}


class Objeto{
	var property position
	var property meEstaLlevando = null
	
	method image()
	
	method position(){
		return if( meEstaLlevando != null ) meEstaLlevando.position() else position
	}
	
	method esDejado(){
		position = meEstaLlevando.position()
		meEstaLlevando = null
	}
}

class Elemento inherits Objeto{	
	method aplicarEfecto(planta)
}


class MonticuloTierra inherits Elemento{
	override method image(){
		return "tierra.png"
	}
	
	override method aplicarEfecto(planta){
		planta.aumentoTierra(10)
	}
}

class BaldeAgua inherits Elemento{
	override method image(){
		return "balde-agua.png"
	}
	
	override method aplicarEfecto(planta){
		planta.aumentoAgua(10)
	}
}



class Planta inherits Objeto{// subclase con los tipos de planta... 
	
	var property estado = sana // booleano
	var etapa = [brote, intermedio, florecida]
	var nivelAgua
	var nivelTierra
	var nivelSol = 5
	var desarrollo = 0
	var deterioro = 0
	method text() = "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
	method tipo()
	
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
	method aplicarDesarrollo(cantidad){
		desarrollo += cantidad
	}
	method aplicarDeterioro(cantidad){
		deterioro += cantidad
	}
	override method image(){
		return self.tipo() + "-" + self.etapa().toString() + "-" + estado.toString() + ".png"
	}
	method etapa(){
		return etapa.first()
	}
	method crecer(){
		etapa = etapa.drop(1)
		self.aplicarDesarrollo( -self.desarrollo() ) // El valor desarrollo vuelve a cero.
		self.aplicarDeterioro( -self.deterioro() ) // El valor deterioso vuelve a cero.
	}
	method marchitar(){
		estado = marchita
	}
	method aumentoSol(cantidad){
		nivelSol += cantidad
	}
	method aumentoAgua(cantidad){
		nivelAgua += cantidad
	}
	method aumentoTierra(cantidad){
		nivelTierra += cantidad
	}
	method puedeMarchitarse(){
		return self.etapa().necesidadesSatisfechas(self) < 2 and self.deterioro() >= 99
	}
	method puedeCrecer(){
		return self.etapa().necesidadesSatisfechas(self) == 3 and self.desarrollo() >= 99
	}
	
}






class PlantaPatagonica inherits Planta{
	override method tipo(){
		return "patagonica"
	}


}

class NivelDeCrecimiento{
	
	method minimoAgua()
	method maximoAgua()
	method minimoTierra()
	method maximoTierra()
	method minimoSol()
	method maximoSol()

	
	method aplicarDeterioro(planta){
		planta.aplicarDeterioro()
	}
	
	method aplicarDesarrollo(planta){
		planta.aplicarDesarrollo()
	}
	
	method necesidadesSatisfechas(planta){
		return planta.tieneAguaSuficiente() and planta.tieneTierraSuficiente() and planta.tieneSolSuficiente()
	}
	method tieneAguaSuficiente(planta){
		return planta.nivelAgua().between(planta.minimoAgua(), planta.maximoAgua())
	}
	method tieneTierraSuficiente(planta){
		return planta.nivelAgua().between(planta.minimoTierra(), planta.maximoTierra())
	}
	method tieneSolSuficiente(planta){
		return planta.nivelAgua().between(planta.minimoSol(), planta.maximoSol())
	}
	
	method necesidadMasUrgente()
	{
		
	}
}

object brote inherits NivelDeCrecimiento{
	override method minimoAgua(){
		return 40
	}
	override method maximoAgua(){
		return 70
	}
	override method minimoTierra(){
		return 60
	}
	override method maximoTierra(){
		return 90
	}
	override method minimoSol(){
		return 30
	}
	override method maximoSol(){
		return 60
	}
	
	override method aplicarDeterioro(planta)
	{
		super(33) 
	}
	
	override method aplicarDesarrollo(planta)
	{
		super(50)
	}
}

object intermedio inherits NivelDeCrecimiento{
	override method minimoAgua(){
		return 40
	}
	override method maximoAgua(){
		return 70
	}
	override method minimoTierra(){
		return 60
	}
	override method maximoTierra(){
		return 90
	}
	override method minimoSol(){
		return 30
	}
	override method maximoSol(){
		return 60
	}
	override method aplicarDeterioro(planta)
	{
		super(50)
	}
	
	override method aplicarDesarrollo(planta)
	{
		super(33)
	}
}

object florecida inherits NivelDeCrecimiento{
	override method minimoAgua(){
		return 40
	}
	override method maximoAgua(){
		return 70
	}
	override method minimoTierra(){
		return 60
	}
	override method maximoTierra(){
		return 90
	}
	override method minimoSol(){
		return 30
	}
	override method maximoSol(){
		return 60
	}
	override method aplicarDeterioro(planta)
	{
		super(33)
	}
	
	override method aplicarDesarrollo(planta)
	{
		super(50)
	}
}


// Esta clase es para agregar un segundo texto a las plantas que podría indicar alguna necesidad a cubrir.
class TextoAtributo
{
	const planta 
	
	method text() = "Necesidad: " + planta.necesidad()
	
	method position() = game.at(self.x(), self.y())
	
	method x()
	{
		return planta.position().x()
	}
	
	method y()
	{
		return planta.position().y() + 1
	}
	
	method textColor() = paleta.verde()
}

const indicadorPino = new TextoAtributo( planta = pino )



object paleta
{
	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property blanco = "FFFFFFFF"
	const property azul = "032EFFF7"
}




object sana{}
object marchita{}


// const palmera = new Planta(tipo = "tropical", estado = sana, position = game.at(7,3), nivelAgua = 45, nivelSol = 85, nivelTierra = 55)
const pino = new PlantaPatagonica(estado = sana, position = game.at(5,0), nivelAgua = 55, nivelSol = 50, nivelTierra = 75)
// const orquidea = new Planta(tipo = "humeda", estado = sana, position = game.at(7,5), nivelAgua = 85, nivelSol = 60, nivelTierra = 55)

const tierra = new MonticuloTierra(position = game.at(6,0))
const agua = new BaldeAgua(position = game.at(7,0))


//Esto estaba comentado en la clase Planta. No lo borro todavia
/*
	 - Si la planta tiene una necesidad, 
	 1° game.removeVisual(self)
	 2° game.addVisual(necesidad, (iconoAgua, iconoTierra, etc) )
	 3° game.addVisual(self)
*/
	// Hay que arreglar el tema de que el personaje quiere agarrar el objeto indicador y no la planta. Debería ignorar el objeto indicador.
//	const property iconoAgua = new IndicadorAgua( planta = self )
//	const property iconoTierra = new IndicadorAgua( planta = self )
//	const property iconoSol = new IndicadorAgua( planta = self )
// method text() = "A: " + self.nivelAgua() + " | " + "T: " + self.nivelTierra() + " | " + "S: " + self.nivelSol()
	
	// method textColor() = paleta.verde()
	
	
/*
	method generarBrote()
	{
		const
	}
*/

/*	
	method buscarPosicionLibre()
	{
		return #{game.getObjectsIn( self.position().x() - 1 ), game.getObjectsIn( self.position().x() + 1 ), game.getObjectsIn( self.position().y() - 1 ), game.getObjectsIn( self.position().x() + 1 )}.find({posicion => })
	}
*/

