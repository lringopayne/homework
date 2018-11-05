# import libraries
from flask import Flask, render_template, jsonify, redirect
from flask_pymongo import PyMongo
from pymongo import MongoClient
import pymongo
import scrape_mars

# create instance of Flask app
app = Flask(__name__)
# Use flask_pymongo to set up mongo connection
#app.config["MONGO_URI"] = "mongodb://localhost:27017/marsmission_app"
#mongo = PyMongo(app)

# Or set inline
mongo = PyMongo(app, uri="mongodb://localhost:27017/marsmission_app")
# Connect to MongoDB
#conn = "mongodb://localhost:5000"
#client = PyMongo.MongoClient(conn)

# Use database and create it if it does not exist 
#db = client.marsDB

#  create route that renders index.html template
@app.route("/")
def index():
    marsdata = mongo.db.marsdata.find_one()
    return render_template("index.html", marsdata = marsdata)


@app.route("/scrape")
def scrape():
    marsdata = mongo.db.marsdata
    mars_data = scrape_mars.scrape()
    mars.update(
        {},
        marsdata,
        upsert=True
    )
    return redirect("/", code=302)


if __name__ == "__main__":
    app.run(debug=True)