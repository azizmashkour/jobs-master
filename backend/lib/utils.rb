require 'json'
require 'date'

<<-RETURN
  This `helper` contains a list of reusable `functions` accross
  all the app. Should be included in all the challenge levels
  to make it works. Otherwise, the code will get broken. It's actually used in:
    - [Level1](../level1/main.rb)
    - [Level2](../level2/main.rb)
    - [Level3](../level3/main.rb)
    - [Level4](../level4/main.rb)
RETURN

module Utils
  class << self
    def load_input file_path
      file           = File.read(file_path)
      return_json    = JSON.parse(file)
      cars           = return_json["cars"]
      rentals        = return_json["rentals"]
      return cars, rentals
    end

    # Code that creates a new `data/output.json` file.
    def build_output output_path
      output_data            = {}
      output_data["rentals"] = yield
      File.write(output_path, JSON.dump(output_data))
    end
  end
end