{register repository}

PUT /_snapshot/anthracite
{
    "type": "fs",
    "settings": {
        "location": "/Users/jjardel/Work/anthracite/backups/anthracite_backup",
        "compress": true
    }
}

{confirm repo registered}
GET /_snapshot/anthracite

{create snapshot with name snapshot_2}
PUT /_snapshot/anthracite/snapshot_2
{
    "indices": "anthracite",
    "ignore_unavailable": "true",
    "include_global_state": false
}


{restore from snapshot_1}
POST /_snapshot/anthracite/snapshot_1/_restore
{
    "indices": "anthracite",
    "ignore_unavailable": "true",
    "include_global_state": false
}

GET /anthracite/_search