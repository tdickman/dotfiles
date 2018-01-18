CUTOFF="2017-08-25T16:13:42Z"

for job in $( kubectl get jobs -o name ); do
   if [[ "$( kubectl get "${job}" -o jsonpath="{.status.conditions[0]['status','type']}" )" != "True Complete" ]]; then
       continue
   fi

   completionTime="$( kubectl get ${job} -o jsonpath='{.status.completionTime}' )"
   if [[ "$completionTime" < "$CUTOFF" ]]; then
       kubectl delete "${job}"
   fi
done
