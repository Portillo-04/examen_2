from datetime import datetime
from pydantic import BaseModel, Field, field_validator

PRIORIDADES = {"Baja", "Media", "Alta"}
ESTADOS = {"Pendiente", "En proceso", "Resuelta"}


class IncidenciaIn(BaseModel):
    nombre_usuario: str = Field(
        ...,
        min_length=3,
        max_length=100
    )

    correo: str = Field(
        ...,
        max_length=150
    )

    numero_equipo: int = Field(
        ...,
        gt=0
    )

    descripcion: str = Field(
        ...,
        min_length=10,
        max_length=500
    )

    prioridad: str
    estado: str

    @field_validator("nombre_usuario")
    @classmethod
    def validar_nombre(cls, v):
        v = v.strip()

        if len(v) < 3:
            raise ValueError(
                "El nombre debe tener como mínimo 3 caracteres..."
            )

        return v

    @field_validator("correo")
    @classmethod
    def validar_correo(cls, v):
        v = v.strip()

        if "@" not in v or "." not in v:
            raise ValueError(
                "El correo debe contener @ y un punto (.)..."
            )

        return v

    @field_validator("descripcion")
    @classmethod
    def validar_descripcion(cls, v):
        v = v.strip()

        if len(v) < 10:
            raise ValueError(
                "La descripción debe tener como mínimo 10 caracteres..."
            )

        return v

    @field_validator("prioridad")
    @classmethod
    def validar_prioridad(cls, v):
        if v not in PRIORIDADES:
            raise ValueError(
                "La prioridad debe ser entre Baja, Media o Alta..."
            )

        return v

    @field_validator("estado")
    @classmethod
    def validar_estado(cls, v):
        if v not in ESTADOS:
            raise ValueError(
                "El estado debe ser entre Pendiente, En proceso o Resuelta..."
            )

        return v


class Incidencia(IncidenciaIn):
    id: int
    fecha_registro: datetime
