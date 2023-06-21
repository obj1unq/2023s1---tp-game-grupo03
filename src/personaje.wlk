  import wollok.game.*

object jardinero
{

	var property position = game.at(3, 3)
	var property direccion = right
	var property objetoEnPosesion = null

	method iniciar()
	{
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
		if( self.validarSiPuedeLlevar(objeto) )
		{
			objeto.meEstaLlevando(self)
			objetoEnPosesion = objeto
		}
	}

	method validarSiPuedeLlevar(objeto)
	{
		return objeto != self && position == objeto.position() && objetoEnPosesion == null
	}

	method dejar()
	{
		self.validarSiPuedeDejar()
		if( objetoEnPosesion != null and game.colliders(self).size() < 2 )
		{
			objetoEnPosesion.esDejado()
			objetoEnPosesion = null
		}
	}
	
	method validarSiPuedeDejar()
	{
		if( game.colliders(self).size() > 1 )
		{
			game.say(self, "Ya hay un objeto en esta posición.")
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

