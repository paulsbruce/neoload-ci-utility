RESULTS_ID=
ITER_C=0
while [ -z "$RESULTS_ID" ] && [ $ITER_C -le 100 ]; do
  echo "Waiting for results to show up in NLW"
  RESULTS_ID=$(neoload test-results --filter="status=RUNNING" ls | jq '[.[]|.id]|first' -r)
  if [ "$RESULTS_ID" == "null" ]; then RESULTS_ID=""; fi
  ITER_C=$((ITER_C+1))
  if [ -z "$RESULTS_ID" ]; then sleep 5; fi
done

echo "Using test-results $RESULTS_ID"
neoload test-results use $RESULTS_ID
neoload fastfail --max-failure 25 -c $'curl -X POST "http://localhost:7400/Runtime/v1/Service.svc/StopTest" -H "Content-type: application/json" --data \'{"d":{"ForceStop":true,"QualityStatus":"FAILED"}}\'' slas cur
