from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes.incidencia import router

app = FastAPI(
    title="Soporte App",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router)


@app.get("/")
def root():
    return {
        "app": "SoporteApp API",
        "status": "ok",
        "message": "API funcionando correctamente",
        "docs": "/docs"
    }
