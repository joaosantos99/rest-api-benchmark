import json
import hashlib
from datetime import datetime

def print_hash(data, label=''):
    """Calculate and format MD5 hash of JSON-serialized data"""
    json_str = json.dumps(data, sort_keys=True)
    hash_obj = hashlib.md5(json_str.encode('utf-8'))
    hash_hex = hash_obj.hexdigest()
    prefix = f"{label} " if label else ""
    return f"{prefix}MD5 Hash: {hash_hex}"

def json_serde():
    """Perform JSON serialization/deserialization cycles"""
    sample_data = {
        "users": [
            {"id": 1, "name": "Alice", "email": "alice@example.com", "active": True},
            {"id": 2, "name": "Bob", "email": "bob@example.com", "active": False},
            {"id": 3, "name": "Charlie", "email": "charlie@example.com", "active": True}
        ],
        "metadata": {
            "version": "1.0.0",
            "timestamp": datetime.now().isoformat(),
            "settings": {
                "theme": "dark",
                "notifications": True,
                "language": "en"
            }
        },
        "statistics": {
            "totalUsers": 3,
            "activeUsers": 2,
            "averageAge": 28.5,
            "tags": ["javascript", "nodejs", "benchmark", "json", "serialization"]
        }
    }

    n = 100  # Number of serialization/deserialization cycles

    json_str = json.dumps(sample_data)
    parsed = json.loads(json_str)
    original_hash = print_hash(parsed, 'Original')

    results = []
    for i in range(n):
        serialized = json.dumps(parsed)
        deserialized = json.loads(serialized)
        results.append(deserialized)

    final_hash = print_hash(results, f'x{n} Cycles')

    return '\n'.join([
        original_hash,
        final_hash,
        f'Performed {n} serialization/deserialization cycles',
        f'Original data size: {len(json_str)} bytes',
        f'Final array size: {len(results)} objects'
    ])

