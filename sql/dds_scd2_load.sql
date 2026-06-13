-- Начальная загрузка если таблица пуста
INSERT INTO dds.dim_scd2_users (
    id, created_at, updated_at, first_name, last_name,
    middle_name, birthday, email, actual_from, actual_to, ts_db
)
WITH source AS (
    SELECT
        id, created_at, updated_at, first_name, last_name,
        middle_name, birthday, email, ts_db,
        LEAD(ts_db) OVER (PARTITION BY id ORDER BY ts_db) AS next_ts_db
    FROM raw.raw_users
)
SELECT
    id, created_at, updated_at, first_name, last_name,
    middle_name, birthday, email, ts_db, next_ts_db, ts_db
FROM source
WHERE NOT EXISTS (SELECT 1 FROM dds.dim_scd2_users);

-- Часть 1: Закрываем старые версии изменившихся пользователей
UPDATE dds.dim_scd2_users AS dds
SET actual_to = new_data.ts_db
FROM (
    SELECT DISTINCT ON (id)
        id, first_name, last_name, middle_name, birthday, email, ts_db
    FROM raw.raw_users
    WHERE ts_db NOT IN (SELECT ts_db FROM dds.dim_scd2_users)
    ORDER BY id, ts_db DESC
) AS new_data
WHERE dds.id = new_data.id
  AND dds.actual_to IS NULL
  AND (
      dds.first_name IS DISTINCT FROM new_data.first_name
   OR dds.last_name IS DISTINCT FROM new_data.last_name
   OR dds.middle_name IS DISTINCT FROM new_data.middle_name
   OR dds.birthday IS DISTINCT FROM new_data.birthday
   OR dds.email IS DISTINCT FROM new_data.email
  );

-- Часть 2: Вставляем новые версии изменившихся пользователей
INSERT INTO dds.dim_scd2_users (
    id, created_at, updated_at, first_name, last_name,
    middle_name, birthday, email, actual_from, actual_to, ts_db
)
SELECT
    r.id, r.created_at, r.updated_at, r.first_name, r.last_name,
    r.middle_name, r.birthday, r.email, r.ts_db, NULL, r.ts_db
FROM raw.raw_users r
WHERE r.ts_db NOT IN (SELECT ts_db FROM dds.dim_scd2_users)
  AND EXISTS (
      SELECT 1 FROM dds.dim_scd2_users d
      WHERE d.id = r.id AND d.actual_to = r.ts_db
  );

-- Часть 3: Вставляем совсем новых пользователей
INSERT INTO dds.dim_scd2_users (
    id, created_at, updated_at, first_name, last_name,
    middle_name, birthday, email, actual_from, actual_to, ts_db
)
SELECT
    r.id, r.created_at, r.updated_at, r.first_name, r.last_name,
    r.middle_name, r.birthday, r.email, r.ts_db, NULL, r.ts_db
FROM raw.raw_users r
WHERE r.ts_db NOT IN (SELECT ts_db FROM dds.dim_scd2_users)
  AND NOT EXISTS (
      SELECT 1 FROM dds.dim_scd2_users d
      WHERE d.id = r.id
  );