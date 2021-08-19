curl --request GET \
     --url https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job \
     --header "authorization: Basic $API_TOKEN" > jobs.json

cat jobs.json | jq -c '.items[] | select(.name | contains("deploy"))' > deploy-result.json

aws dynamodb put-item \
    --table-name deployments \
    --item file://deploy-result.json
