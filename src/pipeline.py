"""Ponto de entrada do pipeline: executa as camadas em ordem."""

import logging

import duckdb

from bronze import load_bronze
from config import DB_PATH

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
)
logger = logging.getLogger(__name__)


def main() -> None:
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    logger.info("Iniciando pipeline. Banco: %s", DB_PATH)

    with duckdb.connect(str(DB_PATH)) as con:
        load_bronze(con)

    logger.info("Pipeline concluído.")


if __name__ == "__main__":
    main()