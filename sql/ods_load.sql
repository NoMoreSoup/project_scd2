INSERT INTO ods.dim_users (
    id, created_at, updated_at, first_name, last_name,
    middle_name, birthday, email
)
WITH latest_users AS (
    SELECT DISTINCT ON (id)
        id,
        created_at,
        updated_at,
        first_name,
        last_name,
        middle_name,
        birthday::date,
        email,
        ts_db
    FROM raw.raw_users
    ORDER BY id, ts_db DESC  -- Используем ts_db для определения актуальности
)
SELECT
    id, created_at, updated_at, first_name, last_name,
    middle_name, birthday, email
FROM latest_users
ON CONFLICT (id) DO UPDATE SET
    created_at = EXCLUDED.created_at,
    updated_at = EXCLUDED.updated_at,
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    middle_name = EXCLUDED.middle_name,
    birthday = EXCLUDED.birthday,
    email = EXCLUDED.email;