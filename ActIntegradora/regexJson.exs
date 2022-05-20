# First test for json token recognition
#
# Sebastian Gonzalez Villacorta
# A01029746
# Karla Mondragón Rosas
# A01025108
# 05-03-2022
#


defmodule JSONTests do

  def json_to_html(in_filename, out_filename) do
    json = 
      in_filename
      |> File.stream!()
      |> Enum.map(&prueba/1)

    dateTuple = Tuple.to_list(:calendar.local_time)
    dateList = Enum.at(dateTuple, 0)
    year = elem(dateList, 0)
    month = elem(dateList, 1)
    day = elem(dateList, 2)
    

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

  def prueba(line) do
    cond do

    # KINDA DONE
    Regex.run(~r/((?m)^[ ]*([^\r\n:]+?)\s*:)/, line) != nil ->
      line = Regex.replace(~r/(?<!>)"[^"\\\\]"\s(?=:)/, line, "<span class='object-key'>\\0</span>" )
      prueba(line)

    # DONE
    Regex.run(~r/(?<!(punctuation'>))[,:[\]{|}]/, line) != nil ->
      line = Regex.replace(~r/(?<!(punctuation'>))[,:[\]{|}]/, line, "<span class='punctuation'>\\0</span>")
      prueba(line)
    
    # DONE
    Regex.run(~r/(?<!>)(true|false|null)/, line) != nil ->
      line = Regex.replace(~r/(?<!>)(true|false|null)/, line, "<span class='reserved-word'>\\0</span>" )
      prueba(line)

    # # BROKEN BUT DONE
    # Regex.run(~r/(?m)^[ ]([^\r\n:]+?)\s:/, line) != nil ->
    # #Regex.run(~r/"[^"\\\\]*"(?=:)/, line) != nil ->
    #   line = Regex.replace(~r/(?m)^[ ]([^\r\n:]+?)\s:/, line, "<span class='object-key'>\\1</span>" )
    #   #line = Regex.replace(~r/"[^"\\\\]*"(?=:)/, line, "<span class='object-key'>\\0</span>" )
    #   prueba(line)

    # NOT QUITE DONE
    Regex.run(~r/((?<!'>)"[^"\\\\]*"(?=(,|]|}|<)))/, line) != nil ->
      line = Regex.replace(~r/(?<!'>)"[^"\\\\]*"(?=(,|]|}|<))/, line, "<span class='string'>\\0</span>" )
      prueba(line)
    
    # BROKEN BUT DONE
    Regex.run(~r/((?<=: )(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!"))/, line) != nil ->
      line = Regex.replace(~r/(?<=: )(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!")/, line, "<span class='number'>\\0</span>")
      prueba(line)
    true -> line
    
    end

  end

end