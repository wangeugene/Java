#!/bin/zsh

set -euo pipefail
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error and exit immediately.
# -o pipefail: Return the exit status of the last command in the pipeline that failed.

API_BASE="http://127.0.0.1:9000"
API_KEY="euwang"
GROUP_NAME="GROUP"
YOUTUBE_URL="https://www.youtube.com/watch?v=aqz-KE-bpKQ"
RANGE_BYTES=$((50 * 1024 * 1024))
REPEAT=2
SLEEP_AFTER_SWITCH=2

hdr=(-H "X-Key: ${API_KEY}" -H "Accept: */*")

candidates_json="$(curl -s "${hdr[@]}" "${API_BASE}/v1/policy_groups")"
echo $candidates_json | pbcopy
# echo "Candidates JSON: $(echo "$candidates_json" | jq)"
# Extract Policy group named GROUP from the JSON response, using key named GROUP
candidates=($(echo "$candidates_json" | jq -r --arg group "$GROUP_NAME" '.[$group][] | .name'))
# only use first 2 candidates for quick test
candidates=("${candidates[@]:0:2}")
# echo "Extracted candidates: ${candidates[*]}"

if [[ ${#candidates[@]} -eq 0 ]]; then
  echo "No candidates found for group: $GROUP_NAME"
  echo "Tip: check your group name in Surge UI, or inspect: curl -s -H \"X-Key: ...\" ${API_BASE}/v1/policy_groups | jq"
  exit 1
fi

echo "Found ${#candidates[@]} nodes in group [$GROUP_NAME]."
echo "Testing YouTube URL: $YOUTUBE_URL"
echo

# CSV header
echo "node,avg_mbps,run_count" > results.csv

for node in "${candidates[@]}"; do
  echo "=== Node: $node ==="
  echo "Switching to node: $node in the GROUP_NAME: $GROUP_NAME"

  # Now test this node
  if ! curl -s \
      --connect-timeout 3 \
      --max-time 6 \
      https://www.google.com/generate_204 \
      -o /dev/null; then
    echo "  Connectivity test failed for node: $node, skipping..."
    continue
  fi

  # set -x
  curl "${hdr[@]}" \
    -X POST "${API_BASE}/v1/policy_groups/select" \
    -d "{\"group_name\":\"${GROUP_NAME}\",\"policy\":\"${node}\"}" 
  # set +x

  sleep "$SLEEP_AFTER_SWITCH"

  curl -s "${hdr[@]}" -X POST "${API_BASE}/v1/dns/flush" -d "{}" > /dev/null || true

  total_mbps=0

  for i in $(seq 1 $REPEAT); do

    media_url="$(yt-dlp -g -f "best[ext=mp4]/best" "$YOUTUBE_URL" 2>/dev/null | head -n 1)"

    if [[ -z "$media_url" ]]; then
      echo "  Run $i: failed to resolve media url"
      continue
    fi

    end=$((RANGE_BYTES - 1))
    # echo "media_url: $media_url, range: 0-$end"

    speed_bps="$(curl -L -s \
      -o /dev/null \
      -r "0-${end}" \
      --connect-timeout 5 \
      --max-time 25 \
      --speed-time 10 --speed-limit 10240 \
      -w "%{speed_download}" \
      "$media_url")"

    mbps="$(echo "scale=2; ($speed_bps*8)/1000000" | bc -l)"
    echo "  Run $i: ${mbps} Mbps"
    total_mbps="$(echo "$total_mbps + $mbps" | bc -l)"
  done

  avg_mbps="$(echo "scale=2; $total_mbps / $REPEAT" | bc -l)"
  echo "  AVG: ${avg_mbps} Mbps"
  echo "${node},${avg_mbps},${REPEAT}" >> results.csv
  echo
done

echo "=== Ranking (desc) ==="
sort -t, -k2 -nr results.csv | column -t -s,
echo
echo "Saved: results.csv"
set -a