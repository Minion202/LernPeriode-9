---
title: Creating a Backend for a Godot Highscore System
---

# Goal

In this tutorial, you will create a simple backend for a Godot game using Python, FastAPI, and PostgreSQL. The backend will save player names and scores and return a leaderboard.

This makes the game more realistic because the data is stored in a real database instead of only locally.

# Previous Knowledge

You should know basic Python and have a rough idea of how Godot works. It also helps if you know how to use the terminal.

You do not need deep backend knowledge, but you should understand files, folders, and basic concepts like APIs.

# What you'll learn

- how to create a backend with FastAPI  
- how to connect Python to PostgreSQL  
- how to store player names and scores  
- how to create routes like /score and /leaderboard  
- how to test the backend  
- how to connect it to Godot  

# Tutorial

## 1. Create the backend folder

Create a folder like this:

game-backend-project/  
└── backend/  
  ├── main.py  
  └── requirements.txt  

## 2. Install libraries

Add this to requirements.txt:

fastapi  
uvicorn[standard]  
psycopg2-binary  
pydantic  

Install them:

pip install -r requirements.txt

## 3. Set up PostgreSQL

Make sure PostgreSQL is running.

The backend will create a table called `scores` with player name and score. PostgreSQL is used because it is reliable and structured.

## 4. Backend code

Add this to main.py:

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
   player VARCHAR(64),  
   score INT  
  );  
 """)  
 conn.commit()  
 cur.close()  
 conn.close()  

class ScoreIn(BaseModel):  
 player: str  
 score: int  

@app.post("/score")  
def save_score(payload: ScoreIn):  
 ensure_table()  
 conn = get_conn()  
 cur = conn.cursor()  
 cur.execute("INSERT INTO scores (player, score) VALUES (%s, %s);", (payload.player, payload.score))  
 conn.commit()  
 cur.close()  
 conn.close()  
 return {"saved": True}  

@app.get("/leaderboard")  
def leaderboard():  
 ensure_table()  
 conn = get_conn()  
 cur = conn.cursor()  
 cur.execute("SELECT player, score FROM scores ORDER BY score DESC LIMIT 10;")  
 rows = cur.fetchall()  
 cur.close()  
 conn.close()  
 return [{"player": r[0], "score": r[1]} for r in rows]  

## 5. Start backend

Run:

uvicorn main:app --host 127.0.0.1 --port 8000 --reload

## 6. Test

Save score:

curl -X POST http://127.0.0.1:8000/score -H "Content-Type: application/json" -d '{"player":"Mina","score":15}'

Get leaderboard:

curl http://127.0.0.1:8000/leaderboard

## 7. Connect to Godot

Use an HTTPRequest node.

Send score to /score and fetch /leaderboard to display results in the game.

# Result

You now have a working backend that saves scores in PostgreSQL and returns a leaderboard.

# What could go wrong?

Database not running  
Wrong login data  
Wrong route used  
JSON format incorrect  
Godot button not connected  
Backend not started  
