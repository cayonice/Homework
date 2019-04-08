from splinter import Browser
from bs4 import BeautifulSoup
import pandas as pd

def scrape():
    mars_dict = {}
    
    executable_path = {'executable_path': '/usr/local/bin/chromedriver'}
    browser = Browser('chrome', **executable_path, headless=False)
    url = 'https://mars.nasa.gov/news/'
    browser.visit(url)
    html = browser.html
    soup = BeautifulSoup(html, 'lxml')
    title = soup.title.text
    latest_articles = soup.find_all('li', class_='slide')
    latest_article = latest_articles[0]
    latest_news = latest_article.find_all('div', class_='content_title')
    news_title = latest_news[0].a.text
    print(news_title)
    mars_dict['news_title'] = news_title

    latest_p = latest_article.find_all('div', class_='article_teaser_body')
    news_p = latest_p[0].text
    print(news_p)
    mars_dict['news_paragraph'] = news_p

    featured_img_url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(featured_img_url)
    featured_img_soup = BeautifulSoup(browser.html, 'lxml')
    image_info = featured_img_soup.find_all('article', class_='carousel_item')
    image_url = image_info[0]['style'].split("('", 1)[1].split("')")[0] 
    featured_image_url = "https://www.jpl.nasa.gov" + image_url
    print(featured_image_url)
    mars_dict['featured_image'] = featured_image_url

    mars_weather_url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(mars_weather_url)
    mars_weather_soup = BeautifulSoup(browser.html, 'lxml')
    weather_info = mars_weather_soup.find_all('div', class_='tweet')
    mars_weather = weather_info[0].p.text
    print(mars_weather)
    mars_dict['mars_weather'] = mars_weather

    mars_facts_url = 'http://space-facts.com/mars/'
    browser.visit(mars_facts_url)
    mars_facts_soup = BeautifulSoup(browser.html, 'lxml')
    tables = pd.read_html(mars_facts_url)
    tables
    df = tables[0]
    df.columns = ['Description', 'Value']
    df.head()
    html_table = df.to_html()
    html_table
    html_table.replace('\n', '')
    df.to_html('templates/mars_facts_table.html')
    mars_dict['mars_facts'] = 'mars_facts_table.html'

    mars_hemi_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(mars_hemi_url)
    mars_hemi_soup = BeautifulSoup(browser.html, 'lxml')
    hemispheres = mars_hemi_soup.find_all('div', class_='description')
    hemisphere_image_urls = []
    for hemisphere in hemispheres:
        browser.visit('https://astrogeology.usgs.gov' + hemisphere.a['href'])
        hemi_fullimg_soup = BeautifulSoup(browser.html, 'lxml')
        full_img = hemi_fullimg_soup.find_all('img', class_='wide-image')   
        hemi_one = {'title': hemisphere.h3.text,
                   'img_url': 'https://astrogeology.usgs.gov' + full_img[0]['src']}
        hemisphere_image_urls.append(hemi_one)
    print(hemisphere_image_urls)
    mars_dict['mars_hemispheres'] = hemisphere_image_urls
    return mars_dict