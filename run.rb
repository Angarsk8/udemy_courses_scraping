require 'ruby-progressbar'
require 'open-uri'
require 'nokogiri'
require 'json'
require('./categories')

include Categories

module Enumerable
	def map_with_index(&block)
		i = 0
		self.map do |val|
			val = block.call(val, i)
			i += 1
			val
		end
	end
end

def get_contact_link(object, query)
	selector = "i[class='icon-#{query}']"
	if object.at_css(selector)
		return object.at_css(selector)
			.parent.attribute("href")
			.value
	else
		return "none"
	end
end	

def get_authors_from_file (file_name)
	if !File.zero?(file_name)
		courses_hash = JSON.parse(File.read(file_name))
		authors_hash = []
		courses_hash.each do |course|
			course["authors"].each do |author|
				authors_hash << author
			end 
		end
		JSON.pretty_generate(authors_hash.uniq)
	else
		raise StandardError, "The file #{file_name} is empty"
	end
end

def write_text_to_file (file_name, mode = "w", data)
	output_file = File.new(file_name, mode)
	output_file.puts data
	output_file.close
end

def build_course_information (doc, url)
	source = "Udemy"
	_category = doc.css("span.cats").css("a")
	category = _category.empty? ? "Unknown" : _category.first.text.strip
	subcategory = _category.empty? ? "Unknown" : _category.last.text.strip
	topic = doc.at_css("h1.course-title").text.strip
	_enrolled = doc.css(".enrolled").at_css("span.rate-count").text.strip.scan(/\d+/).map(&:to_i)
	rating = _enrolled.first
	enrolled = _enrolled.last
	average_rating = doc.at_css(".average-rate") ? doc.at_css(".average-rate").text.strip.to_f : 0.0
	_price = doc.at_css('meta[property="udemy_com:price"]').attribute("content").value.scan(/\d+/)
	price = _price.empty? ? 0 : _price.first.to_i
	authors = doc.css('[id="instructor"]').map do |instructor|
		contact_list = instructor.css("a.iconed-btn")
		{
			name: instructor.at_css("a.ins-name").text.strip,
			twitter: get_contact_link(contact_list, 'twitter'),
			facebook: get_contact_link(contact_list, 'facebook'),
			googleplus: get_contact_link(contact_list, 'google-plus'),
			linkedin: get_contact_link(contact_list, 'linkedin'),
			youtube: get_contact_link(contact_list, 'youtube'),
			website: get_contact_link(contact_list, 'globe')
		}
	end
	return {
		source: source,
		url: url,
		category: category,
		subcategory: subcategory,
		topic: topic,
		authors: authors,
		enrolled: enrolled,
		rating: rating,
		average_rating: average_rating,
		price: price
    }
end

def fetch_data_from_udemy(base_url, courses_paths)
	bar = ProgressBar.create(
		:format => '%a |%b>>%i| %P%% %t',
		:total => courses_paths.length
	)
	return JSON.pretty_generate(
		courses_paths.map do |path|
			composed_url = "#{BASE_URL}#{path}"
			html = open(composed_url)
			doc = Nokogiri::HTML(html)
			bar.log "Fetching data from #{composed_url}"
			bar.increment
			build_course_information(doc, composed_url)
		end
	)
end

def main 
	begin 
		data = fetch_data_from_udemy(BASE_URL, COURSES_PATHS) 
		write_text_to_file("results.json", "w", data)
	    authors = get_authors_from_file("results.json")
	    write_text_to_file("authors.json", "w", authors)		
		puts "The process has finished succesfully"
	rescue Exception => e
		puts "An error has ocurred: #{e.message}"
	end
end

main		
