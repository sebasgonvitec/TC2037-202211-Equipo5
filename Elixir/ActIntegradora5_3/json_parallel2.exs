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
# :timer.tc(&JSONParse.json_multi_files/1, ["json_tests/*.json"])

# PARALLEL Function calls:
# JSONParse.json_to_html("json_tests/out_file_000001.json")
# JSONParse.json_html_par("json_tests/*.json")
# :timer.tc(&JSONParse.json_html_par/1, ["json_tests/*.json"])

defmodule JSONParse do

    def json_to_html(in_filename, out_filename) do
    #def json_to_html(in_filename) do
        json = 
            in_filename
        |> File.stream!()
        |> Enum.map(&regex/1)
        |> Enum.join()

        # Get current date from system
        dateTuple = Tuple.to_list(:calendar.local_time)
        dateList = Enum.at(dateTuple, 0)
        year = elem(dateList, 0)
        month = elem(dateList, 1)
        day = elem(dateList, 2)

        html =
        "
<!DOCTYPE html>
    <html>
        <head>
            <title>JSON Code</title>
            <link rel='stylesheet' href='token_colors.css'>
        </head>
        <body>
            <h1>Date: #{day}/#{month}/#{year}</h1>
            <div class='wrap'>
            <pre>
#{json}
            </pre>
            </div>
        </body>
    </html>
"

        File.write(out_filename, html)

    end

    def regex(string) do
        do_regex(string, "")
    end 

    def do_regex(string, res) do 
        cond do
            
            # PUNCTUATION
            Regex.run(~r/^[,:[\]{|}]\s*/, string) != nil ->
            match = hd(Regex.run(~r/^[,:[\]{|}]\s*/, string))
            res = res  <> "<span class='punctuation'>#{match}</span>"
            do_regex(remove_find(string, match), res)

            # OBJECT KEY
            Regex.run(~r/^"[^"\\\\]*"\s*:\s*/, string) != nil ->
            match = hd(Regex.run(~r/^"[^"\\\\]*"\s*:\s*/, string))
            res = res  <> "<span class='object-key'>#{match}</span>"
            do_regex(remove_find(string, match), res)

            # RESERVED WORD
            Regex.run(~r/^(true|false|null)\s*/, string) != nil ->
            match = hd(Regex.run(~r/^(true|false|null)\s*/, string))
            res = res  <> "<span class='reserved-word'>#{match}</span>"
            do_regex(remove_find(string, match), res) 

            # STRING
            Regex.run(~r/^"[^"\\\\]*"(?=(,|]|}|<|\n))/, string) != nil ->
            match = hd(Regex.run(~r/^"[^"\\\\]*"(?=(,|]|}|<|\n))/, string))
            res = res  <> "<span class='string'>#{match}</span>"
            do_regex(remove_find(string, match), res) 

            # NUMBER
            Regex.run(~r/^\+?\-?\d+\.?\d*E?e?\+?\-?\d*/, string) != nil ->
            match = hd(Regex.run(~r/^\+?\-?\d+\.?\d*E?e?\+?\-?\d*/, string))
            res = res  <> "<span class='number'>#{match}</span>"
            do_regex(remove_find(string, match), res) 

            # SPACE
            Regex.run(~r/^\s/, string) != nil ->
            res = res
            do_regex(remove_find(string, " "), res)

            true -> res
        end
    end

    # Removes characters from string based on byte size
    def remove_find(full, find) do
        base = byte_size(find)
        binary_part(full, base, byte_size(full) - base)
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

    # Function to call syntax highlighting for json files in certain path in parallel
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