"""Configurações centrais do projeto: caminho e nomes das tabelas."""

from pathlib import Path

#Raiz do projeto, calculada a partir deste arquivo (funciona em qualquer maqunia)
ROOT_DIR = Path(__file__).resolve().parent.parent

DATA_DIR = ROOT_DIR / "data"
RAW_DIR = DATA_DIR / "raw"
DB_PATH = DATA_DIR / "olist.duckdb"
SQL_DIR = ROOT_DIR / "sql"

#Arquivo CSV de origem -> nome da tabela na camada bronze
RAW_FILES ={
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "category_translation",
}