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

@app.get("/hello")
def hello():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("SELECT 1;")
    cur.fetchone()
    cur.close() 

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
    return {"saved": True}

@app.get("/leaderboard")
def leaderboard():
    ensure_table()
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("""
        SELECT player, score
        FROM scores
        ORDER BY score DESC
        LIMIT 10;
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [{"player": r[0], "score": r[1]} for r in rows]