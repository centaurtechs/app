#! /bin/bash
PROJECT_ID=navarch-dev
REGION_ID=australia-southeast1
CLUSTER_ID=navarch-app-demo
INSTANCE_ID=navarch-alloydb-cluster-au
ALLOY_SA=alloydb-au-bot@navarch-dev.iam.gserviceaccount.com

ALLOY_URI=projects/$PROJECT_ID/locations/$REGION_ID/clusters/$CLUSTER_ID/instances/$INSTANCE_ID
echo ./alloydb-auth-proxy $ALLOY_URI 