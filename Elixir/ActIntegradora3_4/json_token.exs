
# Actividad Integradora 3.4 Resaltador de sintaxis (evidencia de competencia)

# Sebastian Gonzalez Villacorta
# A01029746
# Karla Mondragón Rosas
# A01025108 05-03-2022

# Test Run: JSONTest.json_to_html("path/input_filename","path/output_filename")

#       Ej: JSONTest.json_to_html("./json_tests/example_0.json","./results/result0.html") 


defmodule JSONTest do
@moduledoc """
  JSON syntax highlighter with html style using Regex
"""

  @doc """
    Main function to read input file and write output file
  """
  def json_to_html(in_filename, out_filename) do
    json = 
      in_filename
      |> File.stream!()
      |> Enum.map(&prueba/1)

    # Get current date from system
    dateTuple = Tuple.to_list(:calendar.local_time)
    dateList = Enum.at(dateTuple, 0)
    year = elem(dateList, 0)
    month = elem(dateList, 1)
    day = elem(dateList, 2)
    
    # Interpolate json to base html file
    html =
      "<!DOCTYPE html>
<html>
  <head>
    <title>JSON Code</title>
    <link rel='stylesheet' href='token_colors.css'>
  </head>
  <body>
    <h1>Date: #{day}/#{month}/#{year}</h1>
    <pre>
      #{json}
    </pre>
  </body>
</html>"

    File.write(out_filename, html)
  end

  @doc """
    Function with condition for each token matched
  """
  def prueba(line) do
    cond do
    # OBJECT-KEY condition
    Regex.run(~r/(?<!>)"[^"\\\\]*"\s*(?=:)/, line) != nil ->
      line = Regex.replace(~r/(?<!>)"[^"\\\\]*"\s*(?=:)/, line, "<span class='object-key'>\\0</span>" )
      prueba(line)

    # PUNCTUATION condition
    Regex.run(~r/(?<!(punctuation'>))[,:[\]{|}](?!")/, line) != nil ->
      line = Regex.replace(~r/(?<!(punctuation'>))[,:[\]{|}]/, line, "<span class='punctuation'>\\0</span>")
      prueba(line)
    
    # RESERVED-WORD condition
    Regex.run(~r/(?<!>)(true|false|null)/, line) != nil ->
      line = Regex.replace(~r/(?<!>)(true|false|null)/, line, "<span class='reserved-word'>\\0</span>" )
      prueba(line)

    # STRING condition
    Regex.run(~r/(?<!'>)"[^"\\\\]*"(?=(,|]|}|<|\n))/, line) != nil ->
      line = Regex.replace(~r/(?<!'>)"[^"\\\\]*"(?=(,|]|}|<|\n))/, line, "<span class='string'>\\0</span>" )
      prueba(line)
    
    # NUMBER condition
    Regex.run(~r/((?<=: )|(?<=> ))(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!")/, line) != nil ->
      line = Regex.replace(~r/((?<=: )|(?<=> ))(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!")/, line, "<span class='number'>\\0</span>")
      prueba(line)
    
    true -> line
    
    end

  end

end