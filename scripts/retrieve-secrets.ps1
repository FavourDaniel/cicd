param (
    [ValidateScript({-not([string]::IsNullOrWhiteSpace($_))})]
    [string] $Project,
    [ValidateScript({-not([string]::IsNullOrWhiteSpace($_))})]
    [string] $Secret,  
    [string] $Impersonate
    
)



Import-Module -Name GoogleCloud

# Init google cloud

gcloud init --project $Project --console-only

# Retrieve the google secret
if ($Impersonate){ 
  Write-Output "impersonating $Impersonate@$Project.iam.gserviceaccount.com"
  $secretValue = (gcloud secrets versions access latest --secret=$Secret --impersonate-service-account=$Impersonate@$Project.iam.gserviceaccount.com) 
}
else {
  $secretValue = (gcloud secrets versions access latest --secret=$Secret)
}
[hashtable] $secrets = ($secretValue | ConvertFrom-JSON -AsHashtable)



# Iterate through the secret values and set them as environment variables

[System.Text.StringBuilder] $builder = [System.Text.StringBuilder]::new()

$secrets.keys | ForEach-Object {
    $name = $_
    $value = $secrets[$name]

    if($value -is [hashtable]) {
        $value = $value | ConvertTo-Json -Compress
    }
    
    $builder.AppendLine("export $($name)=`'$($value)`'") | Out-Null
}

Set-Content -Path /tmp/secrets.sh -NoNewline -Force -PassThru -Value $builder.ToString() | Out-Null

chmod +x /tmp/secrets.sh