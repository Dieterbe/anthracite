{register repository}

PUT /_snapshot/anthracite
{
    "type": "fs",
    "settings": {
        "location": "/github/anthracite/backups/anthracite",
        "compress": true
    }
}

{confirm repo registered}
GET /_snapshot/anthracite

{create snapshot with name snapshot_20150220}
PUT /_snapshot/anthracite/snapshot_20150220
{
    "indices": "anthracite",
    "ignore_unavailable": "true",
    "include_global_state": false
}


{restore from snapshot_20150220}
POST /_snapshot/anthracite/snapshot_20150220/_restore
{
    "indices": "anthracite",
    "ignore_unavailable": "true",
    "include_global_state": false
}