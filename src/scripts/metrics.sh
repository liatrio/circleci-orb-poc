curl --request GET \
     --url https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job \
     --header "authorization: Basic $API_TOKEN" > jobs.json

jq_select='.items[] | select(.name | contains("deploy"))'
started_at=$(cat jobs.json | jq -c "$jq_select" | jq -r .started_at)
#measureValue=$(cat jobs.json | jq -c "$jq_select" | jq -r .status)
Item=$(cat << EOF
[
  {
    "Dimensions": [
      {
        "Name": "job_number",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .job_number)",
        "DimensionValueType": "VARCHAR"
      },
      {
        "Name": "id",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .id)",
        "DimensionValueType": "VARCHAR"
      },
      {
        "Name": "started_at",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .started_at)",
        "DimensionValueType": "VARCHAR"
      },
      {
        "Name": "name",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .name)",
        "DimensionValueType": "VARCHAR"
      },
      {
        "Name": "project_slug",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .project_slug)",
        "DimensionValueType": "VARCHAR"
      },
      {
        "Name": "type",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .type)",
        "DimensionValueType": "VARCHAR"
      },
      {
        "Name": "stopped_at",
        "Value": "$(cat jobs.json | jq -c "$jq_select" | jq -r .stopped_at)",
        "DimensionValueType": "VARCHAR"
      }
    ],
    "MeasureName": "deployment_result",
    "MeasureValue": "failed",
    "MeasureValueType": "VARCHAR",
    "Time": "$(date -d "$started_at" +"%s")",
    "TimeUnit": "SECONDS",
    "Version": 1
  }
]
EOF
)
echo $Item
aws  timestream-write \
     write-records \
     --database-name pipeline-metrics \
     --table-name deployments \
     --records "$Item"
