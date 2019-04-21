from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd
import time
import requests
def scrape():
  executable_path = {'executable_path': 'chromedriver.exe'}
  browser = Browser('chrome', **executable_path, headless=False)
  url = "https://mars.nasa.gov/news/"
  browser.visit(url)
  html = browser.html
  soup = BeautifulSoup(html, 'html.parser')
  article = soup.find('li', class_='slide')
  # Use Beautiful Soup's find() method to navigate and retrieve attributes
  div = article.find('div', class_='content_title')
  news_p = article.find('div', class_='article_teaser_body')
  news_title = div.find('a')
  print('-----------')
  print(news_title.text)
  print(news_p.text)
  url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
  browser.visit(url)
  # Design an XPATH selector to grab the featured image
  xpath = '//*[@id="full_image"]'
  # Use splinter to Click the "Mars in natural color in 2007" image 
  # to bring up the full resolution image
  results = browser.find_by_xpath(xpath)
  img = results[0]
  img.click()
  # Scrape the browser into soup and use soup to find the full resolution image of mars
  # Save the image url to a variable called `img_url`
  html = browser.html
  soup = BeautifulSoup(html, 'html.parser')
  print(soup.find("img", class_="fancybox-image"))
  img_url = soup.find("img", class_="fancybox-image")["src"]
  featured_image_url = url + img_url
  featured_image_url
  twitter_url = 'https://twitter.com/marswxreport?lang=en'
  twitter_response = requests.get(twitter_url)
  twitter_soup = BeautifulSoup(twitter_response.text, 'lxml')
  twitter_result = twitter_soup.find('div', class_='js-tweet-text-container')
  # save the tweet as a variable
  mars_weather = twitter_result.find('p', class_='js-tweet-text').text
  mars_weather
  # Scrape for Mars facts
  mars_facts_url = 'https://space-facts.com/mars/'
  facts_tables = pd.read_html(mars_facts_url)
  facts_tables
  # Create pandas dataframe
  df = facts_tables[0]
  df.columns = ['Description', 'Value']
  df.head()
  # Reset index
  df.set_index('Description', inplace=True)
  df.head()
  # Export pandas df to html script
  html_mars = df.to_html()
  html_mars
  # Scrape for hemisphere image urls and titles
  hemisphere_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
  browser.visit(hemisphere_url)
  hemisphere_html = browser.html
  hemisphere_soup = BeautifulSoup(hemisphere_html, 'lxml')
  base_url ="https://astrogeology.usgs.gov"
  image_list = hemisphere_soup.find_all('div', class_='item')
  # Create list to store dictionaries of data
  hemisphere_image_urls = []
  # Loop through each hemisphere and click on link to find large resolution image url
  for image in image_list:
    hemisphere_dict = {}
    href = image.find('a', class_='itemLink product-item')
    link = base_url + href['href']
    browser.visit(link)
    time.sleep(1)
    hemisphere_html2 = browser.html
    hemisphere_soup2 = BeautifulSoup(hemisphere_html2, 'lxml')
    img_title = hemisphere_soup2.find('div', class_='content').find('h2', class_='title').text
    hemisphere_dict['title'] = img_title
    img_url = hemisphere_soup2.find('div', class_='downloads').find('a')['href']
    hemisphere_dict['url_img'] = img_url
  # Append dictionary to list
    hemisphere_image_urls.append(hemisphere_dict)
    hemisphere_image_urls
    mars_dict = {
      "newsTitle": news_title.text,
      "newPara": news_p.text,
      "featImg": featured_image_url,
      "marsWeather": mars_weather,
      "marsHtml": html_mars,
      "hemisphere_dict": ""#hemisphere_dict
    }
    print(mars_dict)
    browser.quit()
    return mars_dict
    # Close the browser after scraping
   
#scrape()