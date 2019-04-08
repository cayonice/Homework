from flask import Flask, render_template, jsonify
from scrape_mars import scrape
import pymongo

app = Flask(__name__)

conn = 'mongodb://localhost:27017'

client = pymongo.MongoClient(conn)

db = client.mars_db

@app.route("/scrape")
def mars_scrape():
    mars_data = scrape()
    #json_mars_data = jsonify(mars_data)
    db.mars.drop()
    db.mars.insert(mars_data)
    del mars_data['_id']
    return render_template('index.html', **mars_data)

@app.route('/mars_facts')
def mars_facts():
    return render_template('mars_facts_table.html')

@app.route("/hemispheres")
def hemispheres():
    mars_data = db.mars.find()[0]
    del mars_data['_id']
    return render_template('hemispheres.html', **mars_data)

@app.route('/')
def index():
    mars_data = db.mars.find()[0]
    del mars_data['_id']
    return render_template('index.html', **mars_data)

if __name__ == "__main__":
    app.run(debug=True)