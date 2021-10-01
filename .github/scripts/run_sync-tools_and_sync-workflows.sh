#!/usr/bin/env bash

# Set for failure
set -euo pipefail

# Set Globals
CWL_ICA_REPO_PATH="$PWD"

# Exports
export CWL_ICA_REPO_PATH

# Check env vars
if [[ ! -v GIT_COMMIT_ID ]]; then
  echo "Error - expected env var GIT_COMMIT_ID" 1>&2
  exit 1
fi

if [[ ! -v SECRETS_JSON ]]; then
  echo "Error - expected env var SECRETS_JSON" 1>&2
  exit 1
fi

if [[ ! -v ICA_BASE_URL ]]; then
  echo "Error - expected env var ICA_BASE_URL" 1>&2
  exit 1
fi

# Run export over jq secrets -
# Secrets are in nested form:
# '{"PROJECT_X": {"ICA_ACCESS_TOKEN": "foo"}, "PROJECT_Y": {"ICA_ACCESS_TOKEN": "bar"}}'
echo "Collecting access tokens" 1>&2

# decode secrets json
SECRETS_JSON="$(echo "${SECRETS_JSON}" | base64 -d)"

for project in $(echo "${SECRETS_JSON}" | jq -r 'keys[]'); do
    # Now export each token env var as CWL_ICA_ACCESS_TOKEN_PROJECT_X=<PROJECT_X_ACCESS_TOKEN>
    # Sub out hypens for underscores
    project_underscore="${project//-/_}"
    # Get token from secrets json
    project_token="$(echo "${SECRETS_JSON}" | \
                     jq -r \
                       --arg project "${project}" \
                       '.[$project].ICA_ACCESS_TOKEN' \
                   )"
    # Get env var name
    project_token_env_var_name="CWL_ICA_ACCESS_TOKEN_${project_underscore^^}"
    # Export env var from project token
    export "${project_token_env_var_name}"="${project_token}"
done

# Now run the github-schema-sync-command
echo "Syncing all schemas" 1>&2
cwl-ica github-actions-sync-schemas

# Now run the github-expression-sync-command
echo "Syncing all expressions" 1>&2
cwl-ica github-actions-sync-expressions

# Now run the github-tool-sync-command
echo "Syncing all tools" 1>&2
cwl-ica github-actions-sync-tools \

# Now run the github-workflow-sync-command
echo "Syncing all workflows" 1>&2
cwl-ica github-actions-sync-workflows


