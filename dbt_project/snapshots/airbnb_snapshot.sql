{% snapshot airbnb_snapshot %}
 {{
        config(
          target_schema = 'snapshots',
          unique_key = 'id', 
          strategy = 'timestamp',
          updated_at = 'last_updated'
        )
  }}
select * 
from 
{{ source('MAIN', 'airbnb_listings_dirty') }} 

{% endsnapshot %}