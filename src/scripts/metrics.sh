aws dynamodb list-tables
curl --request GET \
     --url https://circleci.com/api/v2/workflow/$CIRCLE_WORKFLOW_ID/job \
     --header "authorization: Basic $API_TOKEN"
