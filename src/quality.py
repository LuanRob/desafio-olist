"""Checagens de qualidade: validam as regras do pipeline ao final de cada execução."""

import logging
from dataclasses import dataclass

import duckdb

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class QualityCheck:
    """Uma checagem: a consulta devolve quantos registros violam a regra (o esperado é zero)."""

    name: str
    sql: str
    blocking: bool = True


CHECKS = [
    # Unicidade
    QualityCheck(
        "fact_orders: um registro por pedido",
        "SELECT count(*) - count(DISTINCT order_id) FROM gold.fact_orders",
    ),
    QualityCheck(
        "fact_order_items: chave (order_id, order_item_id) única",
        """SELECT count(*) - count(DISTINCT order_id || '-' || CAST(order_item_id AS VARCHAR))
           FROM gold.fact_order_items""",
    ),
    QualityCheck(
        "silver.order_reviews: uma avaliação por pedido (regra #1)",
        "SELECT count(*) - count(DISTINCT order_id) FROM silver.order_reviews",
    ),
    # Integridade referencial
    QualityCheck(
        "fact_order_items: todo produto existe em dim_products",
        """SELECT count(*) FROM gold.fact_order_items AS f
           LEFT JOIN gold.dim_products AS d ON f.product_id = d.product_id
           WHERE d.product_id IS NULL""",
    ),
    QualityCheck(
        "fact_order_items: todo vendedor existe em dim_sellers",
        """SELECT count(*) FROM gold.fact_order_items AS f
           LEFT JOIN gold.dim_sellers AS d ON f.seller_id = d.seller_id
           WHERE d.seller_id IS NULL""",
    ),
    QualityCheck(
        "fact_orders: todo cliente existe em dim_customers",
        """SELECT count(*) FROM gold.fact_orders AS f
           LEFT JOIN gold.dim_customers AS d ON f.customer_id = d.customer_id
           WHERE d.customer_id IS NULL""",
    ),
    # Regras de negócio
    QualityCheck(
        "dim_products: nenhuma categoria nula (regras #2 e #3)",
        "SELECT count(*) FROM gold.dim_products WHERE category_pt IS NULL OR category_en IS NULL",
    ),
    QualityCheck(
        "fact_payments: nenhum pagamento 'not_defined' (regra #8)",
        "SELECT count(*) FROM gold.fact_payments WHERE payment_type = 'not_defined'",
    ),
    QualityCheck(
        "fact_orders: métricas de entrega só para pedidos entregues (regra #5)",
        """SELECT count(*) FROM gold.fact_orders
           WHERE delivery_days IS NOT NULL AND order_status <> 'delivered'""",
    ),
    QualityCheck(
        "fact_order_items: nenhum valor negativo",
        "SELECT count(*) FROM gold.fact_order_items WHERE price < 0 OR freight_value < 0",
    ),
    QualityCheck(
        "fact_orders: notas entre 1 e 5",
        "SELECT count(*) FROM gold.fact_orders WHERE review_score NOT BETWEEN 1 AND 5",
    ),
    # Alerta (não bloqueia)
    QualityCheck(
        "fact_orders: entrega registrada antes da data da compra",
        "SELECT count(*) FROM gold.fact_orders WHERE delivery_days < 0",
        blocking=False,
    ),
]


def run_quality_checks(con: duckdb.DuckDBPyConnection) -> None:
    """Executa todas as checagens. Interrompe o pipeline se uma checagem bloqueante falhar."""
    failures = []

    for check in CHECKS:
        violations = con.execute(check.sql).fetchone()[0]
        if violations == 0:
            logger.info("OK     | %s", check.name)
        elif check.blocking:
            logger.error("FALHOU | %s: %s registros", check.name, f"{violations:,}")
            failures.append(check.name)
        else:
            logger.warning("ALERTA | %s: %s registros", check.name, f"{violations:,}")

    if failures:
        raise ValueError(f"{len(failures)} checagem(ns) de qualidade falharam: {failures}")