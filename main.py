from fastapi import FastAPI
import psycopg2

app = FastAPI()

def db_ping() -> bool:
    conn = psycopg2.connect(
        host="localhost",
        port=5432,
        dbname="game",
        user="gameuser",
        password="gamepass",
    )
    cur = conn.cursor()
    cur.execute("SELECT 1;")
    cur.fetchone()
    cur.close()
    conn.close()
    return True

@app.get("/hello")
def hello():
    ok = db_ping()
    return {"message": "hello world", "db_connected": ok}