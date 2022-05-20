### Sebastian González, A01029746
### Karla Mondragón, A01025108
<br>

# Reflexión 

Como se observa en el programa, solamente se utiliza un mapa y una función recursiva. A pesar de la sencillez de la estructura, se optó por usar Regex.run() y Regex.replace() los cuales aumentan la complejidad del programa. Debido a las características de las propiedades utilizadas, la complejidad se aproxima a $n^3$. <br> <br>
Tanto como Regex.run() como Regex.replace() funcionan iterando la línea ingresada hasta que se encuentran todos los tokens, por lo que un cálculo acertado de la complejidad del algoritmo es sumamente complicado ya que depende de la cantidad de caractéres y de la cantidad de tokens en una sola línea. Es gracias a estas complicaciones que se deduce que la complejidad del algoritmo es mayor a $n^2$ pero menor a $n^3$. <br> <br>
Con respecto al tiempo de ejecución,
* para el primer test "example_0.json" fueron 2593 microsegundos, 
* para el segundo test "example_1.json" fueron 2871 microsegundos, 
* para el tercer test "example_2.json" fueron 2608 microsegundos,
* para el cuarto test "example_3.json" fueron 3666 microsegundos,
* para el quinto test "example_4.json" fueron 8666 microsegundos,
* para el sexto test "example_5.json" fueron 3541 microsegundos. <br> 

Una vez que examinamos el contenido de todos los archivos "example_x.json", se observa que hay una relación directamente proporcional entre la longitud del contenido del archivo y el tiempo de ejecución. El archivo "example_4.json" que tuvo un tiempo de ejecución de 8666 microsegundos (el mayor tiempo de todos los archivos), contiene más líneas y más tokens, lo que significa que el programa hace más iteraciones, causando que el sistema al crear el archivo HTML, se demore en comparación. En el caso del primer test "example_0.json" y el tercer test "example_2.json", se puede deducir que es debido a su simplicidad y a la cantidad de líneas que no solo tienen una diferencia de 15 microsegundos, sino que, son los que tienen un menor tiempo de ejecución.