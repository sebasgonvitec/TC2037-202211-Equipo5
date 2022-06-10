### Sebastian González, A01029746
### Karla Mondragón, A01025108
<br>

# ReadMe

El siguiente programa tuvo como objetivo adaptar y mejorar el resaltador de sintaxis desarrollado como parte de la Actividad Integradora 3.4 con el propósito de que se pudiera aplicar el resaltado léxico de manera secuencial y paralela a múltiples archivos JSON contenidos en un directorio.

# Instalación 
El programa fue realizado en el lenguaje de programación de elixir. Para utilizar elixir y correr el programa se necesita descargar elixir (https://elixir-lang.org/install.html). Una vez que se ha descargado, en caso de que tenga una terminal tipo WSL se puede utilizar el siguiente comando: <br>
    &nbsp;&nbsp;&nbsp;&nbsp; sudo apt-get install elixir <br>
    Para verificar la instalación solo se debe de ingresar 'elixir' a la terminal. <br>
<br>

Dependiendo de su IDE se pueden descargar diferentes extensiones para trabajar con Elixir, para VSCode se utilizó la extensión "vscode-elixir" y se trabaja desde la terminal con el siguiente comando: <br>
    &nbsp;&nbsp;&nbsp;&nbsp; iex 'nombreArchivo'.exs <br>
    Este comando permite ingresar al modo interactivo de elixir en el que el usuario final puede ingresar casos prueba. <br>
<br>

En caso de que se este utilizando un sistema operativo diferente a Windows 11 o Mac OS se puede consultar la siguiente documentación: <br>
* https://elixir-lang.org/install.html

<br>

# Correr este programa
Se recomienda que para correr el programa por primera vez se eliminen todos los archivos del directorio "results" para poder visualizar en tiempo real la creación de cada archivo de resultado.
Las llamadas para correr las distintas funciones que contiene este programa son las siguientes:

&nbsp;&nbsp;&nbsp;&nbsp; > iex json_parallel2.exs <br>

- Secuencial <br>
&nbsp;&nbsp;&nbsp;&nbsp; > JSONParse.json_multi_files("json_tests/*.json") <br>
<br>
- Paralelo <br>
&nbsp;&nbsp;&nbsp;&nbsp; > JSONParse.json_html_par("json_tests/*.json") <br>
<br>
Estas llamadas crean una serie de archivos HTML en el directorio results. El archivo CSS "token_colors.css" debe de estar en la misma carpeta que los archivos de resultado.