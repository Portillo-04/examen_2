from fastapi import APIRouter, HTTPException

from config.database import get_connection
from schemas.incidencia import Incidencia, IncidenciaIn

router = APIRouter(
    prefix="/api/incidencias",
    tags=["Incidencias"]
)


def obtener_o_404(cursor, incidencia_id: int):

    cursor.execute(
        """
        SELECT
            id,
            nombre_usuario,
            correo,
            numero_equipo,
            descripcion,
            prioridad,
            estado,
            fecha_registro
        FROM incidencias
        WHERE id = %s
        """,
        (incidencia_id,)
    )

    incidencia = cursor.fetchone()

    if incidencia is None:
        raise HTTPException(
            status_code=404,
            detail="Incidencia no encontrada"
        )

    return incidencia


@router.get(
    "",
    response_model=list[Incidencia]
)
def listar_incidencias():

    conexion = get_connection()

    try:
        with conexion.cursor() as cursor:

            cursor.execute(
                """
                SELECT
                    id,
                    nombre_usuario,
                    correo,
                    numero_equipo,
                    descripcion,
                    prioridad,
                    estado,
                    fecha_registro
                FROM incidencias
                ORDER BY id DESC
                """
            )

            return cursor.fetchall()

    finally:
        conexion.close()


@router.get(
    "/{incidencia_id}",
    response_model=Incidencia
)
def obtener_incidencia(incidencia_id: int):

    conexion = get_connection()

    try:
        with conexion.cursor() as cursor:
            return obtener_o_404(
                cursor,
                incidencia_id
            )

    finally:
        conexion.close()


@router.post(
    "",
    response_model=Incidencia,
    status_code=201
)
def crear_incidencia(data: IncidenciaIn):

    conexion = get_connection()

    try:
        with conexion.cursor() as cursor:

            cursor.execute(
                """
                INSERT INTO incidencias
                (
                    nombre_usuario,
                    correo,
                    numero_equipo,
                    descripcion,
                    prioridad,
                    estado
                )
                VALUES
                (
                    %s,
                    %s,
                    %s,
                    %s,
                    %s,
                    %s
                )
                """,
                (
                    data.nombre_usuario,
                    data.correo,
                    data.numero_equipo,
                    data.descripcion,
                    data.prioridad,
                    data.estado
                )
            )

            return obtener_o_404(
                cursor,
                cursor.lastrowid
            )

    finally:
        conexion.close()


@router.put(
    "/{incidencia_id}",
    response_model=Incidencia
)
def actualizar_incidencia(
    incidencia_id: int,
    data: IncidenciaIn
):

    conexion = get_connection()

    try:
        with conexion.cursor() as cursor:

            obtener_o_404(
                cursor,
                incidencia_id
            )

            cursor.execute(
                """
                UPDATE incidencias
                SET
                    nombre_usuario = %s,
                    correo = %s,
                    numero_equipo = %s,
                    descripcion = %s,
                    prioridad = %s,
                    estado = %s
                WHERE id = %s
                """,
                (
                    data.nombre_usuario,
                    data.correo,
                    data.numero_equipo,
                    data.descripcion,
                    data.prioridad,
                    data.estado,
                    incidencia_id
                )
            )

            return obtener_o_404(
                cursor,
                incidencia_id
            )

    finally:
        conexion.close()


@router.delete(
    "/{incidencia_id}"
)
def eliminar_incidencia(incidencia_id: int):

    conexion = get_connection()

    try:
        with conexion.cursor() as cursor:

            obtener_o_404(
                cursor,
                incidencia_id
            )

            cursor.execute(
                """
                DELETE FROM incidencias
                WHERE id = %s
                """,
                (incidencia_id,)
            )

            return {
                "mensaje": "Incidencia eliminada correctamente"
            }

    finally:
        conexion.close()
