### Sebastian González, A01029746
### Karla Mondragón, A01025108
<br>

# ReadMe

El siguiente programa tuvo como objetivo desarrollar un un motor de expresiones regulares que tome las expresiones léxicas de JSON y con ello esté en condiciones de escanear los elementos léxicos de cualquier archivo fuente provisto. El programa convierte su entrada en documentos de HTML+CSS que resalta el léxico.

# Instalación 
El programa fue realizado en el lenguaje de programación de elixir. Para utilizar elixir y correr el programa se necesita descargar elixir (https://elixir-lang.org/install.html). Una vez que se ha descargado, en caso de que tenga una terminal tipo WSL se puede utilizar el siguiente comando: <br>
    &nbsp;&nbsp;&nbsp;&nbsp; sudo apt-get install elixir <br>
    Para verificar la instalación solo se debe de ingresar 'elixir' a la terminal. <br>
<br>

Dependiendo de su IDE se pueden descargar diferentes extensiones para trabajar con racket, para VSCode se utilizó la extensión "vscode-elixir" y se trabaja desde la terminal WSL con el siguiente comando: <br>
    &nbsp;&nbsp;&nbsp;&nbsp; iex 'nombreArchivo'.exs <br>
    Este comando permite ingresar al modo interactivo de elixir en el que el usuario final puede ingresar casos prueba. <br>
<br>

En caso de que se este utilizando un sistema operativo diferente a Windows 11 o Mac OS se puede consultar la siguiente documentación: <br>
* https://elixir-lang.org/install.html

<br>

# Correr este programa
Para poder correr este programa, en su terminal debe utilizar el comando:

&nbsp;&nbsp;&nbsp;&nbsp; iex token_test.exs <br>
&nbsp;&nbsp;&nbsp;&nbsp; JSONTest.json_to_html("path/input_filename","path/output_filename")

Lo que crea el archivo HTML y solamente se tiene que correr. El archivo CSS "token_colors.css" debe de estar en la misma carpeta que el archivo del resultado.