"""Executa as camadas SQL (silver e gold): cada arquivo .sql gera uma tabela."""

import logging

import duckdb

from config import SQL_DIR

logger = logging.getLogger(__name__)


def build_layer(con: duckdb.DuckDBPyConnection, layer: str) -> None:
    """Executa cada arquivo .sql de sql/<layer>. O nome do arquivo é o nome da tabela."""
    sql_files = sorted((SQL_DIR / layer).glob("*.sql"))
    if not sql_files:
        raise FileNotFoundError(f"Nenhum arquivo .sql encontrado em sql/{layer}/")

    con.execute(f"CREATE SCHEMA IF NOT EXISTS {layer}")

    for sql_file in sql_files:
        sql = sql_file.read_text(encoding="utf-8")
        if not sql.strip():
            raise ValueError(f"Arquivo SQL vazio: {sql_file}")

        con.execute(sql)
        table_name = sql_file.stem
        rows = con.execute(f"SELECT count(*) FROM {layer}.{table_name}").fetchone()[0]
        logger.info("%s.%s criada: %s linhas", layer, table_name, f"{rows:,}")