"""Camada bronze: carrega os CSVs originais para o DuckDB, sem transformação."""

import logging

import duckdb

from config import RAW_DIR, RAW_FILES

logger = logging.getLogger(__name__)


def load_bronze(con: duckdb.DuckDBPyConnection) -> None:
    """Carrega cada CSV de data/raw para uma tabela no schema bronze.

    Todas as colunas são lidas como texto (all_varchar) para que a carga
    nunca falhe por tipo inválido. A tipagem é feita na camada silver.
    """
    con.execute("CREATE SCHEMA IF NOT EXISTS bronze")

    for file_name, table_name in RAW_FILES.items():
        file_path = RAW_DIR / file_name
        if not file_path.exists():
            raise FileNotFoundError(
                f"Arquivo não encontrado: {file_path}. "
                "Baixe o dataset da Olist no Kaggle e extraia em data/raw/ (veja o README)."
            )

        con.execute(f"""
            CREATE OR REPLACE TABLE bronze.{table_name} AS
            SELECT
                *,
                '{file_name}' AS _source_file,
                now() AS _ingested_at
            FROM read_csv('{file_path.as_posix()}', header = true, all_varchar = true)
        """)

        rows = con.execute(f"SELECT count(*) FROM bronze.{table_name}").fetchone()[0]
        logger.info("bronze.%s carregada: %s linhas", table_name, f"{rows:,}")