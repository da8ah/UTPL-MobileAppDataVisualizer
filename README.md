# Proyecto Final - MATLAB INTERMEDIO

## Objetivos de aprendizaje
- Aplicar nuevas habilidades a un problema del mundo real
- Sintetizar las técnicas aprendidas

## Herramientas
- git
- github
- MATLAB 2019+
- slack (chat privado para consultas puntuales, chat grupal para consultas sobre uso de git o consultas generales)


## Flujo de Trabajo
1. Clona este repositorio en tu máquina local    
2. Edite los archivos que sean necesario y complete todas las tareas semanales que se señalan en los entregables.
3. Confirme sus cambios y envíelos a github. 


## Entregables
- **Semana 2 (16 dic.):**  Selección de funete de datos, lectura de datos, definición de clases, visualización de graficas 
- **Semana 4 (6 ene.):**   Implementación de widgets 1, 2, 3
- **Semana 6, (20 ene.):** Implementación de widgets 4, 5
- **Semana 8, (3 feb.):**  Implementación de widget 6, pruebas, documentación, defensa de proyecto.

## Organización de carpetas
- img/
- data/
- src/
- gui/
- main.mlapp

## Instrucciones

El objetivo del proyecto final es sintetizar una serie de conceptos nuevos aprendidos en este curso y aplicarlos en la práctica para resolver un problema del mundo real. Específicamente, deberá utilizar técnicas de programación orientada a objetos (recomendado) y crear una aplicación con una interfaz gráfica de usuario moderna para procesar y visualizar datos relacionados a una fuente de datos (Ej. COVID-19).


### Criterios de revisión

La especificación del problema describe una lista de requisitos sobre la funcionalidad y el enfoque requerido. La calificación se basa en cuántos de los requisitos se satisfacen con la solución dada.

### Instrucciones de asignación paso a paso

El objetivo del proyecto final es crear un programa MATLAB que procese y visualice los datos (Ej. pandemia de COVID-19). 

Sus conjuntos de datos pueden incluir datos recopilados por usted o su laboratorio, o pueden provenir de un repositorio de datos público. Idealmente, su elección de conjunto de datos debería estar impulsada por su investigación.

Si no sabe qué conjunto de datos usar, aquí hay un par de enlaces para comenzar:

- [Datos COVID en Ecuador](https://github.com/andrab/ecuacovid)
- [Biblioteca de datos de IRI](http://iridl.ldeo.columbia.edu/)
- [Catálogo de datos de USGS](https://data.usgs.gov/datacatalog/)
- [Centro Nacional de Datos Climáticos de la NOAA](https://www.ncdc.noaa.gov/)
- [Datos de Ciencias de la Tierra de la NASA](https://earthdata.nasa.gov/)

El siguiente planteamiento lo debe ajustar a su fuente de datos. El ejemplo que se presenta correponde a datos de la pandemia COVID-19.

Los datos (obtenidos del Centro de recursos sobre coronavirus de la Universidad Johns Hopkins) están disponibles en el archivo [.mat](http://purl.org/matlabintermedio/proyectofinal/data) adjunto. Una vez que lo cargue, obtendrá una única variable llamada covid_data que es una gran matriz de celdas. (¡Asegúrese de que su aplicación cargue el archivo!) Contiene los recuentos globales de casos y muertes por país, estado y fecha. Específicamente, la primera fila de la matriz de celdas especifica lo que contiene cada columna: país y estado seguidos de una serie de fechas que comienzan en "22/1/20", es decir, 22 de enero de 2020. No codifique la fecha de finalización, ya que anticipamos actualizar los datos regularmente a medida que avanza el tiempo. Cada celda de datos para un país y una fecha determinada contiene un vector de dos elementos: el primer elemento es el recuento acumulativo de casos, mientras que el segundo es el número acumulativo de muertes.

Su programa debe convertir estos datos en un conjunto de objetos: un objeto por país y estado. Los estados deben estar contenidos por sus países. Los países se pueden almacenar en un vector de objetos de países en la propia aplicación. Otra forma es crear una instancia de la misma clase que usa para países y estados, llamarla global y hacer que almacene todos los países. Entonces, la aplicación contendría el objeto global único como una propiedad. Esta opción crearía una jerarquía de 3 niveles: el objeto global almacena datos para todo el mundo y un vector de objetos de país, mientras que los objetos de países que tienen estados en la base de datos almacenarían sus estados correspondientes. Nuevamente, puede usar la misma definición de clase para los tres tipos de objetos porque almacenan esencialmente el mismo tipo de datos.

La interfaz gráfica de usuario de su programa debe contener varios widgets:
1. Un área única donde grafica los datos. El título de la gráfica debe ser informativo mostrando qué país / estado se muestra y también indicando las opciones relevantes que se utilizaron para generar la gráfica. (Ver más abajo). Las etiquetas x deben ser fechas. Debe implementar diferentes escalas y para los dos gráficos de la izquierda y la derecha, como se muestra a continuación.
2. Un cuadro de lista que muestra todos los países disponibles. El primer elemento debe llamarse "Global" y seleccionarlo debe trazar los datos globales. Esto no está contenido en la base de datos, por lo que deberá calcularlo.
3. Otro cuadro de lista que muestra todos los estados del país seleccionado actualmente. La primera opción debería ser "Todos". Como la mayoría de los países no tienen estados, regiones, territorios o provincias asociados con ellos en la base de datos, esta será la única opción para ellos. Al seleccionarlo, se deberían mostrar los datos del propio país. Hay dos tipos de países con estados en la base de datos. Australia, Canadá, China y Estados Unidos tienen todos sus estados, provincias, etc. enumerados. Otros países como el Reino Unido, los Países Bajos o Dinamarca no están subdivididos, pero tienen una serie de territorios de ultramar enumerados. Por ejemplo, el Reino Unido no se divide en Inglaterra, Escocia, Gales e Irlanda del Norte, pero tiene territorios adicionales, como las Islas Malvinas, en la lista.
4. Un widget para seleccionar el número de días utilizados para calcular un promedio móvil de los datos (de 1 a 15). Asegúrese de que la selección sea un número entero. Seleccionar 1 significa que no hay promedios. Tenga en cuenta que el promedio móvil debe utilizar los últimos N-1 días y el día actual, donde N es el número de días seleccionados.
5. Un widget para seleccionar qué trazar: casos, muertes o ambos.
6. Un widget para seleccionar si se trazan datos acumulados o números diarios. La base de datos contiene datos acumulativos. Debe calcular los datos diarios teniendo en cuenta los posibles errores de datos. Específicamente, asegúrese de no trazar nunca valores negativos.

Siempre que cambie alguno de los widgets de la GUI, el gráfico y su título deben actualizarse de inmediato.

A continuación se muestra una captura de pantalla de una implementación de ejemplo. 



<div align="center">
<img src="./img/prototipo.png" >
</div>


<div align="center">
<a href="http://purl.org/matlabintermedio/proyectofinal/demostracion" target="_blank">
<img src="./img/demostracion.png" >
</a>
<p>Demostración de funcionamiento</p>
</div>

<br/><br/>

Tenga en cuenta que tiene flexibilidad para resolver el problema. Solo asegúrese de cumplir con los requisitos anteriores. Puede agregar funciones adicionales si lo desea. Por ejemplo, tener un cuadro de búsqueda, para que el usuario no tenga que desplazarse y buscar países manualmente en el cuadro de lista, sería una buena característica. También sería útil cambiar el rango de fechas para trazar.

También tenga en cuenta que el curso no ha cubierto una serie de cosas que necesita utilizar para el proyecto. Por ejemplo, nunca le enseñamos cómo hacer que las etiquetas x aparezcan como valores de fecha con un formato agradable. ¿Por qué te hacemos esto? Simplemente porque una vez que intente usar sus habilidades de MATLAB en la vida real, se encontrará con muchos casos en los que tendrá que descubrir cómo resolver un problema con funciones y técnicas integradas de MATLAB que no ha visto antes. No hay forma de que podamos cubrir todo lo que es MATLAB en 2 o 3 cursos. Por lo tanto, es una habilidad importante poder encontrar nuevas técnicas, herramientas, clases y funciones que pueda utilizar cuando se encuentre con un problema. Utilice la documentación de MATLAB y Google.

Por ejemplo, si busca en Google "etiquetas de fecha de trazado de matlab", el primer resultado, al menos para mí, es esta página . Contiene todo lo que necesita para configurar las etiquetas de fecha como se muestra arriba. La página no muestra un ejemplo que coincida exactamente, por lo que aún tiene trabajo por hacer. Bienvenidos a la programación.

[covid_data.mat](http://purl.org/matlabintermedio/proyectofinal/data)


### Cómo enviar proyecto final:

El repositorio debe actualizarse de forma continua, creando los commits necesarios. Su proyecto debe contener todos los archivos MATLAB necesarios para ejecutar su programa . Normalmente, tendría tres archivos: el archivo de la aplicación (.mlapp), el archivo m con la definición de clase de los objetos de su país / estado y el archivo .mat con los datos. Esto último es útil para asegurarse de que se revise su programa con los datos con los que lo probó. 







