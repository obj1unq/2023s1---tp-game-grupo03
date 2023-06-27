import wollok.game.*
import configuraciones.*

object jardinero
{
	var property position = game.at(3, 3)
	var property direccion = right
	var property objetoEnPosesion = null
	var property ambiente = pantallaPrincipal
	
	method iniciar(pantalla)
	{
		ambiente = pantalla
		if( objetoEnPosesion != null )
		{
			game.addVisual(objetoEnPosesion)
		}
	}
	
	method image()
	{
		return "jardinero-" + self.imagenSegunDireccion() + ".png"
	}

	method imagenSegunDireccion()
	{
		return direccion.image()
	}

	method cambiarDireccion(nuevoSentido)
	{
		direccion = nuevoSentido
	}

	method move(personaje)
	{
		position = direccion.move(self)
	}

	method obtenerObjetoDePosicion()
	{
		const objetos = game.colliders(self)
		return if( objetos.size() > 0 )
		{
			objetos.first()
		} 
		else self
	}

	method llevar(objeto)
	{
		if( self.puedeLlevar(objeto) )
		{
			objeto.meEstaLlevando(self)
			objetoEnPosesion = objeto
		}
	}

	method puedeLlevar(objeto)
	{
		return objeto != self && position == objeto.position() && objetoEnPosesion == null
	}

	method dejar()
	{
		self.aplicarEfecto(objetoEnPosesion)
		if( objetoEnPosesion != null and game.colliders(self).size() < 2 )
		{
			objetoEnPosesion.esDejado(ambiente)
			objetoEnPosesion = null
		}
	}
	
	method aplicarEfecto(objeto) {
		if( game.colliders(self).size() > 1 ) {
			objeto.aplicarEfecto(game.colliders(self).first())
		}
	}
}

object right {

	method image() {
		return "right"
	}

	method move(personaje) {
		return personaje.position().right(1)
	}

}

object left {

	method image() {
		return "left"
	}

	method move(personaje) {
		return personaje.position().left(1)
	}

}

object up {

	method image() {
		return "right"
	}

	method move(personaje) {
		return personaje.position().up(1)
	}
}

object down {

	method image() {
		return "left"
	}

	method move(personaje) {
		return personaje.position().down(1)
	}

}

