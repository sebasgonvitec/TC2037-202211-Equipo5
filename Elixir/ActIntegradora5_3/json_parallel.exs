#
#   Evidencia Final V1: Parallel Syntax Highlighter
# 
#   Sebastián González Villacorta
#   A01029746
#   Karla Valeria Mondragón Rosas
#   A01025108
#
#   10/06/2022
#

# SEQUENTIAL Function calls:
# JSONParse.json_multi_files("json_tests/*.json")
# :timer.tc(&JSONParallel.json_multi_files/1, ["json_tests/*.json"])

# PARALLEL Function calls:
# JSONParse.json_to_html("json_tests/out_file_000001.json")
# JSONParse.json_html_par("json_tests/*.json")
# :timer.tc(&JSONParallel.json_html_par/1, ["json_tests/*.json"])

defmodule JSONParallel do

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

    # Call function for all json input files in directory
    def json_multi_files(in_path) do
        do_json_multi_files(Path.wildcard(in_path), length(Path.wildcard(in_path)))    
    end

    def do_json_multi_files([], 0), do: IO.puts "Done!"

    def do_json_multi_files([h_in | t_in], n) do
        json_to_html(h_in, "results/result#{n}.html")
        do_json_multi_files(t_in, n-1)
    end

    # Function to call syntax highlighting for json files in certain path
    def json_html_par(input_path) do
        json_list = Path.wildcard(input_path)
        json_html_par_fpt(json_list, length(json_list))
    end

    # Creates a thread for each file and runs the syntax highlighting in each
    def json_html_par_fpt(jsonList, threads) do
        0..(threads-1)
        |> Enum.map(&Task.async(fn -> json_to_html(
                Enum.at(jsonList, &1),
                "results/result#{&1}.html") end))
        |> Enum.map(&Task.await(&1))
    end
end