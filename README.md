##Udemy Courses Scraping

###Usage

To use this script be sure you have installed the required gems (you can see them in the Gemfile). I have already configured a bundle so check if you have the ***bundler*** gem installed, if not just execute `gem install bundler` in a terminal shell and then execute `bundle install` (this will install all the gems required to run the run.rb script)

Once you have install all the gems, execute the following command:

```
ruby run.rb
```

The above commad will scrape the data from some Udemy courses pages (The ones that are in the COURSES_PATHS constant in the categories.rb file) and retrieves the relevant data as a JSON that will be stored in a file called results.json.

###Sample Output (results.json)

```javascript
[
    {
      "source": "Udemy",
      "url": "https://www.udemy.com/curso-completo-desarrollador-ios-15-apps/",
      "category": "Programación",
      "subcategory": "Aplicaciones Móviles",
      "topic": "iOS 8 y Swift Completo: Aprende creando 15 Apps reales",
      "authors": [
        {
          "name": "Rob Percival",
          "twitter": "https://twitter.com/techedrob",
          "facebook": "https://www.facebook.com/rpcodestars",
          "googleplus": "https://plus.google.com/112310006632536121434?rel=author",
          "linkedin": "none",
          "youtube": "https://www.youtube.com/user/robpercival",
          "website": "http://www.completewebdevelopercourse.com"
        },
        {
          "name": "Juan José  Ramírez",
          "twitter": "none",
          "facebook": "none",
          "googleplus": "none",
          "linkedin": "none",
          "youtube": "none",
          "website": "http://agbo.biz/tech/curso-android-basico/"
        },
        {
          "name": "KeepCoding Online",
          "twitter": "https://twitter.com/@KeepCoding_es",
          "facebook": "https://www.facebook.com/pages/Agbotraining/463644126986852",
          "googleplus": "https://plus.google.com/https://plus.google.com/u/1/b/104277667088859577707/+KeepCoding/posts?rel=author",
          "linkedin": "https://linkedin.com/company/keepcoding",
          "youtube": "https://www.youtube.com/https://www.youtube.com/channel/UCz-oGx94gqD1lICJQZGniLA",
          "website": "http://keepcoding.io/es/"
        }
      ],
      "enrolled": 743,
      "rating": 28,
      "average_rating": 4.9,
      "price": 205
    },
    {
      "source": "Udemy",
      "url": "https://www.udemy.com/android-basico/",
      "category": "Development",
      "subcategory": "Mobile Apps",
      "topic": "Android básico",
      "authors": [
        {
          "name": "José Luján",
          "twitter": "https://twitter.com/josedlujan",
          "facebook": "https://www.facebook.com/josedlujan",
          "googleplus": "https://plus.google.com/103871608091491576854?rel=author",
          "linkedin": "https://linkedin.com/in/josedlujan/",
          "youtube": "https://www.youtube.com/josedlujan1",
          "website": "http://josedlujan.com"
        }
      ],
      "enrolled": 4223,
      "rating": 75,
      "average_rating": 4.7,
      "price": 20
    },
    ...
]
```