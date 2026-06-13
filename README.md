
```shell
python3.12 -m venv venv && \
source venv/bin/activate && \
pip install --upgrade pip && \
pip install poetry && \
poetry lock && \
poetry install

```

```md
raw.raw_users        ← генерирует raw_users_to_pg.py (каждую секунду)
      │
      ▼
ods.dim_users        ← ods_load.sql (каждую минуту, Airflow)
      
raw.raw_users
      │
      ▼
dds.dim_scd2_users   ← dds_scd2_load.sql (каждую минуту, Airflow)
```

