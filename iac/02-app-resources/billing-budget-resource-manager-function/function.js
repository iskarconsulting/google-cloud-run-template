'use strict';

const { ServicesClient } = require('@google-cloud/run').v2;

const GCP_REGION = process.env.GCP_REGION;
const GCP_PROJECT_ID = process.env.GCP_PROJECT_ID;
const GCP_CLOUDRUN_ID = process.env.GCP_CLOUDRUN_ID

exports.limitUse = async pubsubEvent => {

  const pubsubData = JSON.parse(
    Buffer.from(pubsubEvent.data, 'base64').toString()
  );

  console.log(`Current cost: ${pubsubData.costAmount}, budget: ${pubsubData.budgetAmount}.`);

  if (pubsubData.costAmount <= pubsubData.budgetAmount) {
    console.log(`No action necessary. Current cost less than budget.`);
    return;
  }

  console.log(`Current cost exceeds budget. Disabling cloud run resource '${GCP_CLOUDRUN_ID}'.`);

  await _removeRunInvokeIamPolicyBinding(GCP_PROJECT_ID, GCP_REGION, GCP_CLOUDRUN_ID);

  console.log(`Role 'role/run.invoker' removed from IAM bindings on resource '${GCP_CLOUDRUN_ID}'.`);
};

const _removeRunInvokeIamPolicyBinding = async (projectId, region, cloudRunId) => {

  const runClient = new ServicesClient();

  const gcpResourceId = `projects/${projectId}/locations/${region}/services/${cloudRunId}`;

  const getIamPolicyRequest = {
    resource: gcpResourceId,
  };

  const policy = await runClient.getIamPolicy(getIamPolicyRequest);

  // Remove the 'roles/run.invoker' policy 
  policy[0].bindings = policy[0].bindings.filter(binding => binding.role !== 'roles/run.invoker');

  const setRequest = {
    resource: gcpResourceId,
    policy: policy,
    updateMask: {
      paths: [
        "bindings"
      ]
    }
  }

  await runClient.setIamPolicy(setRequest)
};
