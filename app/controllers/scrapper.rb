require 'nokogiri'
require 'open-uri'
require 'pry'


def separate(data)
  letters = ('a'..'z').to_a
  numbers = ('0'..'9').to_a
  elements = letters.concat(numbers)
  ans = []
  keys = []
  data.each_char do |char|
    if elements.include?(char.downcase)
      ans << char.downcase
    else
      if ans.length > 1
        keys << ans.join('')
      end
      ans = []
    end
  end
  return keys
end

def clean(movie)
	h = {}
    puts "Limpiando datos..."
    rgxTv = /([Ss]\d{2}[[Ee]\d{2}]*)/
    rgxMovie = /((\d{4})[^p])/
    puts movie
    if (rgxTv =~ movie) == nil
    	puts 'Película de nombre: '
    	name_i = rgxMovie =~ movie

    	name_i += 4

    	code = movie.scan(rgxMovie)[0]
    	code = code[1]
    else
    	puts 'Serie de nombre: '
    	name_i = rgxTv =~ movie

    	name_i += 6

   		code = movie.scan(rgxTv)[0]
   		code = code[0]
    end

    title = movie[0...name_i]
    body = movie[name_i..-1]

    keys =separate(body)
    title = separate(title).join(' ') +' '+ code
    puts title
    h = {title: title, keys: keys}
    return h
end	

def scraping(data)
	puts 'Scrapeando información...'
	data = data.split(' ').join('%20')
	h = {}
	p "http://www.subdivx.com/index.php?q=#{data}&accion=5&masdesc=&subtitulos=1&realiza_b=1"
	html = open("http://www.subdivx.com/index.php?q=#{data}&accion=5&masdesc=&subtitulos=1&realiza_b=1")
	s = "rick.and.morty.s04e09.1080p.webrip.x264-hola"
	#crea un objeto tipo Nokogiri HTML con la info de la web.
	doc = Nokogiri::HTML(html)
	links = {}
	description = []
	downloads = []
	links = []

	doc.search('#buscador_detalle_sub').map.with_index do |ele, i|
	    description << ele.content
	end

	doc.search('#buscador_detalle_sub_datos').map do |ele|
		downloads << ele.content.scan(/: (\d*,?\d+)/)[0][0].tr(',','').to_i
	end

	doc.search('.titulo_menu_izq').map.with_index do |ele, i|
    	links << ele['href']
   	end

	h = {description: description, downloads: downloads, links: links}
	#ele.at_css("b").content
end

def search(str, keys)
	arr = []
	keys.each do |ele|
		if str.scan(ele).length > 0
			arr << ele
		end
	end
	return arr
end


def hash_creator(keys, data)
	results = []
	sub_list = data[:description]
	sub_list.each.with_index do |ele,i|
		h = {
		 i: i,
		desc:  (ele),
		array: [],
		percentage: 0,
		downloads: 0,
		links: []
	}
		h[:array] = search(ele, keys)
		h[:percentage] = ((h[:array].length) *100)/keys.length
		h[:downloads] = data[:downloads][i]
		h[:links] = data[:links][i]
		results << h
	end
	return results
end



def calling(str)
	puts '////////////////////////////////////////////////////////////////////////////////////////////////' 

	string = str

    data = clean(string)
    
	info = scraping(data[:title])

	p data[:keys]
    puts
    
	final_data = hash_creator(data[:keys], info)
	quant = final_data.length
	puts "Se encontaron #{quant} en total."
	order = final_data.sort_by {|hash| - hash[:percentage]}

	order.each do |h|
		puts "Subtítulo Nº #{h[:i]} se acerca en un #{h[:percentage]}% y ha sido descargado #{h[:downloads]} veces."
		if quant > 0
			puts "El link de descarga es #{h[:links]}."
		end
		puts '-----------------------------------------------------------------------------------------------------------'
	end
    
end

def queControlador(str)
    puts "Estoy en el controlador #{str}."
end




