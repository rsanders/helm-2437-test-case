#!/bin/sh -x

: ${NAMESPACE:=default}

(cd step1 && helm install --name helm-2437 .)
sleep 2
(cd step2 && helm upgrade helm-2437 .)
sleep 5
(cd step3 && helm upgrade helm-2437 .)

cat <<EXP
Step 1: Install a chart successfully. This includes an env var with value "step1".

Step 2: Then we upgrade the release with a version that fails 
validation in the K8S API. Set the env var in the Deployment to "step2"

Step 3: Upgrade the release with the version from Step 2 with the validation errors
  corrected. The var's value is still set to "step2" in the manifest.

Somewhere in Step 2 the attempted upgrade fails, leaving the Deployment only 
partially updated. The env var has *not* been updated due to the validation failure
in the 'resources' section.

However, the upgrade in step3 should update the variable to the value 'step2', as that
is what the chart contains. But because Helm believes that the env var had been set to
'step2' in the failed upgrade at Step 2 above, it doesn't update the env var.

The following will show "step1" if the release state has become corrupted
per HELM #2437.  If the upgrade in Step 3 had successfully brought the Deployment
fully up to date, it would say "step1".
EXP

kubectl get deploy helm-2437-dep  -o jsonpath='{.spec.template.spec.containers[0].env[0].value}'

