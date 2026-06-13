from datetime import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

with DAG(
    dag_id="scd2_dag",
    start_date=datetime(2026, 1, 1),
    schedule_interval="*/1 * * * *",
    catchup=False,
) as dag:

    ods_load = PostgresOperator(
        task_id="ods_load",
        postgres_conn_id="postgres_default",
        sql="sql/ods_load.sql",
    )

    dds_load = PostgresOperator(
        task_id="dds_scd2_load",
        postgres_conn_id="postgres_default",
        sql="sql/dds_scd2_load.sql",
    )

    ods_load >> dds_load