---
title: Creating a Backend for a Godot Highscore System
---

# Goal

In this tutorial, you will learn how to create a simple backend for a Godot game by using Python, FastAPI, and PostgreSQL. The backend will receive a player's name and score, save this data in a database, and return a leaderboard with the best results.

This is useful because the game does not only store the data locally, but saves it in a real database. As a result, the highscore system becomes more realistic and works more like in an actual game project. At the end of this tutorial, you will have a working backend that communicates with your Godot project and makes it possible to save and load highscores.

# Previous Knowledge

Before starting this tutorial, you should already know some basic Python syntax and have a rough understanding of how a Godot project is structured. It is also helpful if you already know how to use the terminal to open folders and run commands.

You do not need to be an expert in backend development, but you should understand what files, folders, and scripts are. It is also useful if you already know that an API is a way for different programs to communicate with each other. In this project, Godot communicates with the backend through API routes.

# What you'll learn

In this tutorial, you will learn:

- how to create a backend with FastAPI
- how to connect Python to a PostgreSQL database
- how to create a table for player names and scores
- how to save new scores through an API route
- how to return the best scores with a leaderboard route
- how to test the backend locally
- how to connect the backend to Godot

# Tutorial

## 1. Create the backend folder

First, create a new folder for your backend project. This folder will contain your Python files and the code for the API.

A possible project structure could look like this:

game-backend-project/  
└── backend/  
  ├── main.py  
  └── requirements.txt  

The file `main.py` will contain the backend code.  
The file `requirements.txt` will contain the Python libraries needed for the project.

It is useful to keep the backend in its own folder because this makes the project easier to organise and understand.

## 2. Install the required libraries

Now create a file called `requirements.txt` and add the following libraries:

fastapi  
uvicorn[standard]  
psycopg2-binary  
pydantic  

These libraries are used for different tasks.

- FastAPI is used to create the API
- Uvicorn is used to run the backend server
- psycopg2-binary is used to connect Python to PostgreSQL
- Pydantic is used to validate incoming JSON data

After creating the file, install everything with this command in the terminal:

pip install -r requirements.txt

This step is important because the backend cannot run if the required libraries are missing.

## 3. Set up PostgreSQL

The next step is to make sure PostgreSQL is running. In this project, PostgreSQL is used to store the highscores permanently.

The database should later contain a table called `scores`. This table stores:

- an id
- the player name
- the score
- the creation date

PostgreSQL was chosen because it is structured, reliable, and often used in real projects. It works very well for storing data such as names, scores, rankings, and timestamps. In comparison to storing data only inside the game, a database is more realistic and easier to expand later.

For example, in a bigger project you could later add more features such as:

- different levels
- timestamps
- player ids
- login data
- several game modes

## 4. Write the backend code

Now open `main.py` and add the backend code.

This backend does four important things:

- it creates a connection to PostgreSQL
- it makes sure that the scores table exists
- it saves new scores
- it returns the top scores in the leaderboard

Add this code to `main.py`:

from fastapi import FastAPI  
from pydantic import BaseModel  
import psycopg2  

app = FastAPI()  

def get_conn():  
 return psycopg2.connect(  
  host="localhost",  
  port=5432,  
  dbname="game",  
  user="gameuser",  
  password="gamepass",  
 )  

def ensure_table():  
 conn = get_conn()  
 cur = conn.cursor()  
 cur.execute("""  
  CREATE TABLE IF NOT EXISTS scores (  
   id SERIAL PRIMARY KEY,  
   player VARCHAR(64) NOT NULL,  
   score INT NOT NULL,  
   created_at TIMESTAMPTZ DEFAULT NOW()  
  );  
 """)  
 conn.commit()  
 cur.close()  
 conn.close()  

class ScoreIn(BaseModel):  
 player: str  
 score: int  

@app.get("/")  
def root():  
 return {"message": "backend is running"}  

@app.get("/hello")  
def hello():  
 conn = get_conn()  
 cur = conn.cursor()  
 cur.execute("SELECT 1;")  
 cur.fetchone()  
 cur.close()  
 conn.close()  
 return {"message": "hello world", "db_connected": True}  

@app.post("/score")  
def save_score(payload: ScoreIn):  
 ensure_table()  
 conn = get_conn()  
 cur = conn.cursor()  
 cur.execute(  
  "INSERT INTO scores (player, score) VALUES (%s, %s);",  
  (payload.player, payload.score),  
 )  
 conn.commit()  
 cur.close()  
 conn.close()  
 return {"saved": True, "player": payload.player, "score": payload.score}  

@app.get("/leaderboard")  
def leaderboard():  
 ensure_table()  
 conn = get_conn()  
 cur = conn.cursor()  
 cur.execute("""  
  SELECT player, score, created_at  
  FROM scores  
  ORDER BY score DESC, created_at ASC  
  LIMIT 10;  
 """)  
 rows = cur.fetchall()  
 cur.close()  
 conn.close()  

 return [  
  {  
   "player": row[0],  
   "score": row[1],  
   "created_at": row[2].isoformat()  
  }  
  for row in rows  
 ]  

## 5. Understand the backend code

It is important to understand what the code does.

The function `get_conn()` creates the connection to PostgreSQL. Without this function, Python would not be able to communicate with the database.

The function `ensure_table()` checks if the table `scores` already exists. If it does not exist yet, it creates it automatically. This is practical because you do not have to create the table manually every time.

The class `ScoreIn` defines the JSON format that the backend expects when a score is sent. It contains two values:

- `player`
- `score`

The route `/` is a simple route that shows whether the backend is running.

The route `/hello` is useful for testing because it checks whether the backend can connect to the database.

The route `/score` is used to save a new score in PostgreSQL.

The route `/leaderboard` returns the best 10 scores from the database in sorted order.

This means that the backend is already able to do the most important parts of a highscore system.

## 6. Start the backend

Once the code is finished, you can start the backend with the following command:

uvicorn main:app --host 127.0.0.1 --port 8000 --reload

If everything works, you should see something like this in the terminal:

Uvicorn running on http://127.0.0.1:8000

This means that the backend is active and ready to receive requests.

The option `--reload` is useful because the backend restarts automatically whenever you save changes in the file.

## 7. Test the backend

Now the backend should be tested before connecting it to Godot.

### Test the root route

Open this in your browser:

http://127.0.0.1:8000/

You should see a message that the backend is running.

### Test the database connection

Open this in your browser:

http://127.0.0.1:8000/hello

You should get a message such as:

{"message":"hello world","db_connected":true}

This shows that the backend can connect to the database correctly.

### Test saving a score

In the terminal, use this command:

curl -X POST http://127.0.0.1:8000/score -H "Content-Type: application/json" -d '{"player":"Mina","score":15}'

If the request is successful, the backend should return a response confirming that the score has been saved.

### Test the leaderboard

Then test the leaderboard route with this command:

curl http://127.0.0.1:8000/leaderboard

You should get a JSON list with the stored highscores.

This step is important because it proves that the backend can both save and return data correctly.

## 8. Connect the backend to Godot

After the backend works on its own, it can be connected to Godot.

In Godot, an `HTTPRequest` node can be used to send requests to the backend. This means that the game can communicate with the backend whenever it needs to save or load data.

For example, when the game ends, the player can enter a name. After that, Godot sends the player name and score to the `/score` route.

Then the game can send another request to `/leaderboard` and show the best results in the user interface.

This is the connection between the game and the backend:

- Godot sends data to the backend
- the backend saves the data in PostgreSQL
- the backend returns the leaderboard
- Godot displays the leaderboard in the game

As a result, the game now uses a real backend instead of only local variables.

## 9. Why this backend is useful

This backend is a good introduction to backend development because it combines several important technologies:

- FastAPI for creating the API
- PostgreSQL for storing structured data
- JSON for data exchange
- Godot as the frontend or game client

It is also practical because the project can be extended later. For example, you could later add:

- more detailed player profiles
- several leaderboards
- filtering by level
- deleting scores
- authentication
- online multiplayer features

This shows that even a simple backend can become the basis for a larger project.

# Result

At the end of this tutorial, you have a working backend for a Godot highscore system. The backend can receive player names and scores, save them in PostgreSQL, and return a sorted leaderboard.

This means that your game can now communicate with a real backend instead of only saving data locally. As a result, the project is more realistic and closer to how games and web applications work in practice.

# What could go wrong?

There are several common problems when building this backend.

One possible problem is that PostgreSQL is not running. In that case, the backend cannot connect to the database, and routes such as `/hello` or `/score` will fail.

Another possible problem is that the wrong route is called. For example, if `/score` is opened directly in the browser, it may not work because `/score` expects a `POST` request with JSON data, not a normal `GET` request.

A third problem is that the JSON data sent from Godot is incorrect. If the fields do not match the expected structure, FastAPI will reject the request.

It is also possible that the Godot UI is connected incorrectly. For example, if a button signal is missing, the score may never be sent to the backend even though the backend itself works.

Finally, small mistakes in the database configuration, such as the wrong user name, password, port, or database name, can stop the backend from working. For this reason, it is important to test every step separately and not only at the very end.
