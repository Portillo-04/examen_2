from datetime import datetime
from pydantic import BaseModel


class Incidencia(BaseModel):
    id: int
    nombre_usuario: str
    correo: str
    numero_equipo: int
    descripcion: str
    prioridad: str
    estado: str
    fecha_registro: datetime
