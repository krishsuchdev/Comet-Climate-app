# Comet Climate App
Comet Climate is a weather application for iOS devices designed specifically for students, faculty, and staff at The University of Texas at Dallas. By providing up-to-date weather information, five-hour forecasts, Twitter updates, and link shortcuts to the University’s website, our goal is to give information about the campus’ physical and social atmosphere.
## About the Application
The app is a page-based application with the first page showing the current weather conditions and for the next 5 hours, the second displaying tweets and retweets from our university's official Twitter account, and the third displaying quick shortcuts to important websites to students. While each page serves its own purpose, the current weather conditions influence the background on all three.

Upon launch, the app sends GET requests to the server and receives the data in a JSON format to populate the weather and Twitter data displayed in the first two pages.
