$GitHubOwner = $Env:OWNER
$GitHubRepo = $Env:REPO
$VariableName = $Env:VARNAME
$VariableValue = $Env:VARVALUE

$Headers = @{
    'Accept' = 'application/vnd.github+json'
    'Authorization' = "Bearer $Env:GH_TOKEN"
    'X-GitHub-Api-Version' = '2022-11-28'
}

$GetPatchUri = "https://api.github.com/repos/$GitHubOwner/$GitHubRepo/actions/variables/$VariableName"
$PostUri = "https://api.github.com/repos/$GitHubOwner/$GitHubRepo/actions/variables"
$PatchPostBody = "{ `"name`": `"$VariableName`", `"value`": `"$VariableValue`" }"

$StatusCode = $null
Invoke-RestMethod -Method Get -Uri $GetPatchUri -headers $Headers -StatusCodeVariable "StatusCode" -SkipHttpErrorCheck
if ($StatusCode -eq 200)
{
    Invoke-RestMethod -Method Patch -Uri $GetPatchUri -headers $Headers -body $PatchPostBody
}
else
{
    Invoke-RestMethod -Method Post -Uri $PostUri -headers $Headers -body $PatchPostBody
}
