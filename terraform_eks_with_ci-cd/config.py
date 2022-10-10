import botocore 
import botocore.session 
import json
from aws_secretsmanager_caching import SecretCache, SecretCacheConfig 

client = botocore.session.get_session().create_client('secretsmanager', region_name='ap-south-1')
cache_config = SecretCacheConfig()
cache = SecretCache( config = cache_config, client = client)
def get_db_details():
    secret = cache.get_secret_string('poc-project-rds_admin')
    db_details = json.loads(secret)
    return db_details
