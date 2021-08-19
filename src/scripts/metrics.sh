#curl --request GET \
#     --url https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job \
#     --header "authorization: Basic $API_TOKEN" > jobs.json

#cat jobs.json | jq -c '.items[] | select(.name | contains("deploy"))' > deploy-result.json
jq_select='.items[] | select(.name | contains("deploy"))'
Item=$(cat << EOF
{
  'job_number': {
      'N': '$(cat jobs.json | jq -c "$jq_select" | jq -r .job_number)',
  },
  'id': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .id)',
  },
  'started_at': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .started_at)',
  },
  'name': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .name)'
  }
  'project_slug': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .project_slug)'
  }
  'status': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .status)'
  }
  'type': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .type)'
  }
  'stopped_at': {
      'S': '$(cat jobs.json | jq -c "$jq_select" | jq -r .stopped_at)'
  }
}
EOF
)
echo $Item
echo $Item > deploy-result.json
aws dynamodb put-item \
    --table-name deployments \
    --item file://deploy-result.json
