# WOLLOKPLANT

## Equipo de desarrollo

- Ventola, Gian Franco
- Sandoval, Mauro
- Salles, Patricio
- Salig, Francisco
- Rincon, Tatiana

![menuInicial](https://github.com/obj1unq/2023s1---tp-game-grupo03/assets/81172403/49d71ef0-939c-429e-82d2-110c8f563f58)

![instrucciones](https://github.com/obj1unq/2023s1---tp-game-grupo03/assets/81172403/a5c9dafc-9051-4cc2-b9f0-90ca1e03c9b9)

## Reglas de Juego / Instrucciones

El objetivo del juego es cuidar todas las plantas hasta que florezcan para ganar.

Se deberá cuidar las plantas dándoles agua y tierra, además de dejarlas al sol para que las mismas se mantengan sanas y no se marchiten, una vez que haya pasado un determinado tiempo, si una planta se encuentra sana pasará al siguiente nivel hasta florecer, los niveles de crecimiento son: brote, intermedio y florecida. Asi mismo, existen distintos tipos de plantas: patagónicas, tropicales y húmedas, las cuales tienen distintas necesidades en cuanto al porcentaje de agua, sol y tierra que requieren y cómo les afectan los distintos entornos (intemperie o invernadero). El juego se gana cuando se logre llegar a tener 5 plantas florecidas. Por el contrario, el juego se pierde si se marchita alguna planta.

## Controles

- Presione N para ingresar al invernadero nocturno.
- Presione D para ingresar al invernadero diurno.
- Presione C para salir de cualquiera de los dos invernaderos.
- Presione X para recoger un objeto (planta, tierra o agua).
- Presione Z para dejar un objeto
- Presione I para leer las instrucciones de juego en cualquier momento que lo necesite.

## Requerimientos plantas:
### Brote
- Tiempo a marchitarse: 7 segundos -> Si se deteriora se aumenta 33 al puntaje por deterioro
- Tiempo a crecer: 5 segundos / El puntaje ganado por desarrollo es 50
- Mínimo de Agua: 40
- Máximo de Agua: 70
- Mínimo de Tierra: 60
- Máximo de Tierra: 90
- Mínimo de Sol: 30
- Máximo de Sol: 60

### Intermedio
- Tiempo a marchitarse: 5 segundos -> Si se deteriora se aumenta 50 al puntaje por deterioro
- Tiempo a crecer: 7 segundos / El puntaje ganado por desarrollo es 33
- Mínimo de Agua: 40 * 1.3
- Máximo de Agua: 70 * 0.9
- Mínimo de Tierra: 60 * 1.3
- Máximo de Tierra: 90 * 0.9
- Mínimo de Sol: 30 * 1.3
- Máximo de Sol: 60 * 0.9

### Florecida
- Ya no tiene necesidades, es una planta florecida! 

## Entornos:
Los 3 entornos se ven afectados por las condiciones del exterior: calor y humedad, ambos toman un valor aleatorio entre 5 y 10, si hace mas o igual calor que humedad, se considera un dia Caluroso.
Cada entorno aportará una cantidad de sol, tierra y agua diferente.
Los invernaderos por su parte también tienen un rociador que puede estar o no activado en el invernadero diurno, pero no en el nocturno, y además el invernadero diurno se ve afectados por un "sol de invernadero".

### Intemperie
- Sol que aporta:
  - Si es un día caluroso: Aporta un valor igual a calor
  - Si no es día caluroso: aporta el doble de la diferencia entre la humedad y el calor
- Agua que aporta:
  - Si es un día caluroso: Resta el valor del calor
  - Si no es día caluroso: Aporta el mismo valor que la humedad
- Tierra que aporta:
  - Si es un día caluroso: Siempre resta -5
  - Si no es día caluroso: Aporta la diferencia entre la humedad y el calor

### Invernadero Diurno
- Sol de invernadero: Devuelve un número random entre 1 y 4
- Sol que aporta:
  - Si es un día caluroso: Aporta el calor de la intemperie + sol de invernadero
  - Si no es día caluroso: aporta el mismo sol que la intemperie
- Agua que aporta:
  - Si el rociador esta prendido aporta el absoluto pasado por la intemperie
  - Si el rociador esta apagado devuelve el mismo valor que la intemperie
- Tierra que aporta: siempre resta 3 de tierra

### Invernadero Nocturno
- Si el dia fue templado ( la diferencia de calor y humedad es entre 0 y 3) cambia su comportamiento
- Sol de invernadero: No aporta ni resta sol si el dia fue templado, si no fue templado resta la diferencia entre el calor y la humedad
  - 
- Agua que aporta:
  - Mismo comportamiento que el exterior, aunque si el dia fue templado suma la mitad de la humedad

- Tierra que aporta: Aporta la mitad del valor absoluto de la intemperie
    
## Condiciones Fin de Juego:
### Para ganar
- Si llegas a tener 3 o más plantas florecidas y menos de 4 plantas marchitas, ganarás el juego!

### Para perder
- Si llegas a tener 4 o más plantas marchitas, perderás el juego!

## Otros
- Objetos 1 - Comisión 2
- Una vez terminado, no tenemos problemas en que el repositorio sea público
