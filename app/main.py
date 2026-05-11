import os

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World!"


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


@app.route("/db")
def db_check():
    import psycopg2

    dsn = os.environ.get("DATABASE_URL")
    if not dsn:
        return jsonify({"error": "DATABASE_URL not set"}), 500
    try:
        conn = psycopg2.connect(dsn)
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()[0]
        cur.close()
        conn.close()
        return jsonify({"database": version})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
