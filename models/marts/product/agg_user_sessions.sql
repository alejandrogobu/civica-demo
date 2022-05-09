
WITH fact_events AS (
    SELECT * 
    FROM {{ ref('fct_events') }}
    ),


int_session_events_agg AS (
    SELECT * 
    FROM {{ ref('int_sessions_events_agg') }}
    ),
    

dim_users AS (
    SELECT * 
    FROM {{ ref('dim_users') }}
    ),


session_length AS (
    SELECT 
        session_id
        ,MIN(created_at_utc) AS first_event_time
        ,MAX(created_at_utc) AS last_event_time
    FROM fact_events
    GROUP BY 1
),


fact_user_sessions AS (
    SELECT
        i.session_id
        ,i.user_id
        ,u.first_name
        ,u.email
        ,i.page_view
        ,i.add_to_cart
        ,i.checkout
        ,i.package_shipped
        ,s.first_event_time
        ,s.last_event_time
        ,(DATEDIFF(DAY, s.first_event_time::timestamp, s.last_event_time::timestamp) * 24 +
        DATEDIFF(HOUR, s.first_event_time::timestamp, s.last_event_time::timestamp)) * 60 +
        DATEDIFF(MINUTE, s.first_event_time::timestamp, s.last_event_time::timestamp) AS session_length_minutes

    FROM int_session_events_agg I
    LEFT JOIN dim_users U ON i.user_id = u.user_id
    LEFT JOIN session_length S ON i.session_id = s.session_id
    )

SELECT * FROM fact_user_sessions