#!/bin/bash

function post_comment_to_gist() {
  local gist_id="$1"
  local access_token="$2"
  local comment="$3"

  local url="https://api.github.com/gists/${gist_id}/comments"
  local headers=("Accept: application/vnd.github+json" "Authorization: Bearer ${access_token}" "X-GitHub-Api-Version: 2022-11-28")
  local body="{\"body\":\"$comment\"}"

  curl -L -X POST -H "${headers[0]}" -H "${headers[1]}" -H "${headers[2]}" "${url}" -d "${body}"
}

gist_url="$@"
# Handler for paperspace gradeint
url=$(echo "$gist_url" | grep -oE "https?://[a-zA-Z0-9./_-]+")

if [ -z "$url" ]; then
  echo "No URL found in the input string."
  exit 1
else
  echo "URL found: $url"
  gist_url="$url"
fi

echo "Gist URL: $gist_url"

gist_id="${gist_url##*/}"
echo "Gist ID: $gist_id"

curl -L -s -o downloaded_gist.sh "$gist_url/raw"

if [ -f "downloaded_gist.sh" ]; then
  echo "Gist downloaded successfully"
  source downloaded_gist.sh
  rm downloaded_gist.sh
else
  echo "Failed to download the Gist"
  exit 1
fi

file_path="/etc/ssh/auth.keys"
echo -e "\n${PUBLIC_SSH_KEY}" >> "${file_path}"

echo "USE_OWN_CLOUDFLARE: $USE_OWN_CLOUDFLARE"
if [ "$USE_OWN_CLOUDFLARE" == "NO" ]; then 
  temp_file=$(mktemp)
  cloudflared tunnel --url ssh://localhost:22 > $temp_file 2>&1 &
  pid=$!

  url=""
  while [ -z "$url" ]; do
    sleep 1
    url=$(grep -o 'https://[^ ]*\.trycloudflare\.com' $temp_file)
  done

  rm $temp_file

  if [ -n "$url" ]; then
    echo "Extracted URL: $url"
  else
    echo "Failed to extract the URL from the output"
  fi

  if [ -z "${GITHUB_PERSONAL_ACCESS_TOKEN}" ]; then
    echo "GITHUB_PERSONAL_ACCESS_TOKEN is not set. Using my own token"
    post_comment_to_gist "$gist_id" "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" "Your server is up and running at $url"
  else
    echo "GITHUB_PERSONAL_ACCESS_TOKEN is set. Proceeding."
    post_comment_to_gist "$gist_id" "$GITHUB_PERSONAL_ACCESS_TOKEN" "Your server is up and running at $url"
  fi
else
  echo "Using your own domain"
  if [ -z "${CLOUDFLARED_TOKEN}" ]; then
    echo "CLOUDFLARED_TOKEN is not set. Exiting"
    post_comment_to_gist "$gist_id" "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" "CLOUDFLARED_TOKEN is not set. Exiting"
    exit 1
  else
    echo "CLOUDFLARED_TOKEN is set. Proceeding."
    cloudflared service install "$CLOUDFLARED_TOKEN"
  fi
fi

jupyter lab --allow-root --ip=0.0.0.0 --no-browser --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False --ServerApp.allow_remote_access=True --ServerApp.allow_origin='*' --ServerApp.allow_credentials=True

service ssh start

tail -f /dev/null