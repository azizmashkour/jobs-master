require 'json'
require 'date'

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