"""Camada silver: aplica as regras de limpeza e tipagem definidas no perfilamento."""

import logging

import duckdb

from config import SQL_DIR

logger = logging.getLogger(__name__)


def build_silver(con: duckdb.DuckDBPyConnection) -> None:
    """Executa cada arquivo .sql de sql/silver. O nome do arquivo é o nome da tabela."""
    con.execute("CREATE SCHEMA IF NOT EXISTS silver")

    for sql_file in sorted((SQL_DIR / "silver").glob("*.sql")):
        con.execute(sql_file.read_text(encoding="utf-8"))
        table_name = sql_file.stem
        rows = con.execute(f"SELECT count(*) FROM silver.{table_name}").fetchone()[0]
        logger.info("silver.%s criada: %s linhas", table_name, f"{rows:,}")