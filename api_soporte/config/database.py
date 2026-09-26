import os
import pymysql
from dotenv import load_dotenv
from fastapi import HTTPException

load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "127.0.0.1"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "soporte_app"),
    "cursorclass": pymysql.cursors.DictCursor,
    "autocommit": True,
}


def get_connection():
    try:
        return pymysql.connect(**DB_CONFIG)

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error al conectar con MySQL: {str(e)}"
        )
