# CI-3661 Proyecto II: Jaque Mate, Jack
Miembros:  
Diego Peña 15-11095  
Wilfredo Graterol 15-10639

## Detalles de implementacion
- Cuando se llama a leer, el nombre del archivo ingresado debe ser sin puntos ni extension, por ejemplo, archivoPruebas seria una entrada correcta pero archivoPruebas.txt no.
- El archivo de entrada debe tener en las casillas en blanco a lo sumo dos espacios.
- Se supone que el archivo de entrada es correcto, es decir, ue sigue el formato de una fila de por medio entre casillas y que las piezas siguen el formato dado en el ejemplo del enunciado del proyecto.
- En la funcion 'puedeGanar' se pone un maximo de jugadas de forma de que el programa termine al hacer backtracking en ese caso.
- La funcion de 'jaque' es implementada de la siguiente manera: se revisa todas las direcciones desde donde puede estar amenzado el rey, hasta que se llega al final del tablero o hay una pieza que impide que el rey esté en jaque y para acelerar la revisión se guardan en memoria las posiciones de las piezas vía el predicado dinámico piezas/4.
- Otro detalle es que el caballo y el rey se mueven utilizando el mismo predicado, haciendo backtracking sobre una lista de desplazamientos, lo que varia es que la lista de desplazamientos es diferente para cada uno.