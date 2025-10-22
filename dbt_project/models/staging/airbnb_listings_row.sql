WITH cleaned AS (

    SELECT 
        {{ handle_blank_auto('id') }} AS operation_id, 
        {{ handle_blank_auto('host_id') }} AS host_id, 
        
        CASE 
            WHEN host_identity_verified IN ('unconfirmed','verified') 
            THEN host_identity_verified
            ELSE NULL 
        END AS host_identity_verified,

        {{ handle_blank_auto('host_name') }} AS host_name, 
        {{ handle_blank_auto('neighbourhood_group') }} AS neighbourhood_group,
        instant_bookable,
        {{ handle_blank_auto('cancellation_policy') }} AS cancellation_policy,
        {{ handle_blank_auto('room_type') }} AS room_type, 
        {{ handle_blank_auto('construction_year') }} AS construction_year, -- 2003 , 2025 
        
        REGEXP_REPLACE(price , '[^0-9]' , '') AS price_clean, -- from $950 to 950
        REGEXP_REPLACE(service_fee , '[^0-9]' , '') AS service_fee_clean, 
        
        {{ handle_blank_auto('minimum_nights') }} AS minimum_nights, 
        {{ handle_blank_auto('number_of_reviews') }} AS number_of_reviews,
        last_review,  
        {{ handle_blank_auto('review_rate_number') }} AS review_rate_number, 
        {{ handle_blank_auto('calculated_host_listings_count') }} AS calculated_host_listings_count,
        {{ handle_blank_auto('availability_365') }} AS availability_365

    FROM {{ source('MAIN', 'AIRBNB_LISTINGS_DIRTY') }}

)

SELECT *
FROM cleaned
WHERE operation_id != 'N/A'
  AND construction_year < 2025;
