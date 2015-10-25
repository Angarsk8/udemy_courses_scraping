require 'ruby-progressbar'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'csv'
require('./categories')

include Categories

def get_contact_link(object, query)
	selector = "i[class='icon-#{query}']"
	if object.at_css(selector)
		return object.at_css(selector)
			.parent
			.attribute("href")
			.value
	else
		return "none"
	end
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
			composed_url = "#{base_url}#{path}"
			html = open(composed_url)
			doc = Nokogiri::HTML(html)
			bar.log "Fetching data from #{composed_url}"
			bar.increment
			build_course_information(doc, composed_url)
		end
	)
end

def write_text_to_file (file_name, mode = "w", data)
	output_file = File.new(file_name, mode)
	output_file.puts data
	output_file.close
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

def build_courses_csv(file_name, mode="w", courses)
	CSV.open(file_name, mode, {:col_sep => "; "}) do |csv|
		csv << [
			"source", "url","category", "subcategory",
			"topic", "name", "twitter", "facebook",
			"googleplus", "linkedin", "youtube", "website"
		]
		JSON.parse(courses).each do |course|
			course["authors"].each do |author|
				csv << [
					course["source"], course["url"], course["category"],
					course["subcategory"], course["topic"], author["name"],
					author["twitter"], author["facebook"], author["googleplus"],
					author["linkedin"], author["youtube"], author["website"]
				]
			end
		end
	end
end

def build_authors_csv(file_name, mode = "w", authors)
	CSV.open(file_name, mode, {:col_sep => "; "}) do |csv|
		csv << [
			"name", "twitter","facebook",
			"googleplus", "linkedin", "youtube",
			"website"
		]
		JSON.parse(authors).each do |author|
			csv << [
				author["name"], author["twitter"], author["facebook"],
				author["googleplus"], author["linkedin"], author["youtube"],
				author["website"]
			]
		end
	end
end

def build_data_for_courses(dir_name, file_name, base_url, courses_paths)
	courses = fetch_data_from_udemy(base_url, courses_paths)
	write_text_to_file("#{dir_name}/#{file_name}.json", "w", courses)
	build_courses_csv("#{dir_name}/#{file_name}.csv", "w", courses)
end

def build_data_for_authors(dir_name, src_file_name, file_name)
    authors = get_authors_from_file("#{dir_name}/#{src_file_name}.json")
    write_text_to_file("#{dir_name}/#{file_name}.json", "w", authors)		
    build_authors_csv("#{dir_name}/#{file_name}.csv", "w", authors)
end

def create_output_folder(dir_name)
	Dir.mkdir(dir_name) unless Dir.exist? dir_name
end

def main 
	begin 
		output_dir = "output"
		base_url = BASE_URL
		courses_paths = COURSES_PATHS
		create_output_folder(output_dir)
		build_data_for_courses(output_dir,"courses", base_url, courses_paths)
		build_data_for_authors(output_dir, "courses", "authors")
		puts "The process has finished succesfully"
	rescue Exception => e
		puts "An error has ocurred: #{e.message}"
	end
end

main		
