load File.expand_path(File.dirname(__FILE__)) << '/gyazo.conf'

class Gyazo < Sinatra::Base
    def rand_string(length)
        table = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
        length.times.map{table[rand(62)]}.join
    end

    get '/' do
        file_array = []
        Find.find(DATA_DIR) { |file|
            next unless FileTest.file?(file)
            file_stat = File::stat(file)
            file_array.push [file.sub(/^.*\//, "#{HOST}"), file_stat.mtime]
        }
        file_array = file_array.sort { |k,v|
            v[1] <=> k[1]
        }
        @file_array = file_array
        erb :index
    end

    post '/upload' do
        id = params[:id]
        if id != ID
            "#{HOST}error"
            exit!
        end

        imagedata = params[:imagedata][:tempfile].read
        begin
            hash = rand_string(STR_LENGTH)
        end while File.exist?("#{DATA_DIR}#{hash}.png")

        File.open("#{DATA_DIR}#{hash}.png", 'w') { |f| f.write(imagedata) }

        "#{HOST}#{hash}.png"
    end
    set :views, File.expand_path(File.dirname(__FILE__)) << '/views'
end

