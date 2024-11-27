#I know there are better ways to do this, but this is just how i keep a backup of the repos here, just in case I mess up or something.
#!/bin/bash

today=$(date +%F)

backup_dir="sigbackup-$today"

if [ -d "$backup_dir" ]; then
  timestamp=$(date +%H%M%S)
  backup_dir="sigbackup-${today}-$timestamp"
fi

mkdir "$backup_dir"

cd "$backup_dir" || exit

org="sigmanauts"
api_url="https://api.github.com/orgs/$org/repos?per_page=100"

repos=$(curl -s $api_url | jq -r '.[].clone_url')

if ! command -v jq &> /dev/null; then
  echo "jq is required but not installed. Please install jq to continue."
  exit 1
fi

for repo in $repos; do
  git clone "$repo"
  repo_name=$(basename "$repo" .git)
  chmod -R a-w "$repo_name"
  echo "Cloned and made $repo_name read-only."
done

echo "All repositories cloned and set to read-only."
