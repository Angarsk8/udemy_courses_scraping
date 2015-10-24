##Udemy Courses Scraping

###Usage

To use this script be sure you have installed the required gems (you can see them in the Gemfile). I have already configured a bundle so check if you have the ***bundler*** gem installed, if not just execute `gem install bundler` in a terminal shell and then execute `bundle install` (this will install all the gems required to run the run.rb script)

Once you have install all the gems, execute the following command:

`ruby run.rb`

The above commad will scrape the data from some Udemy courses pages (The ones that are in the COURSES_PATHS constant in the categories.rb file) and retrieves the relevant data as a JSON that will be stored in a file called results.json.