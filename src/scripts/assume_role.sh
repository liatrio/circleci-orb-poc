assumed_role=$(aws sts assume-role --role-arn $<<parameters.role-arn>> --role-session-name <<parameters.role-session-name>>)
aws_access_key_id=$(echo $assumed_role | jq .Credentials.AccessKeyId | xargs)
aws_secret_access_key=$(echo $assumed_role | jq .Credentials.SecretAccessKey | xargs)
aws_session_token=$(echo $assumed_role | jq .Credentials.SessionToken | xargs)
echo "export AWS_ACCESS_KEY_ID=$aws_access_key_id" >> $BASH_ENV
echo "export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key" >> $BASH_ENV
echo "export AWS_SESSION_TOKEN=$aws_session_token" >> $BASH_ENV