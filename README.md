# Terrahelp GitHub Action

GitHub Action as wrapper for [opencredo/terrahelp](https://github.com/opencredo/terrahelp).

## Usage

The most common use case is decryption of version controlled Terraform state files
just before their usage in a GitHub Action workflow.

The following workflow gives an example in combination with the [Terraform GitHub Actions](https://github.com/hashicorp/terraform-github-actions).

````yaml
---
name: 'Terraform GitHub Actions'
on:
  - pull_request
env:
  tf_version: 0.12.24
  tf_working_dir: .
jobs:
  terraform:
    name: 'Terraform Plan'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terrahelp Decrypt'
        uses: gesellix/terrahelp-github-action@master
        with:
          th_working_dir: ${{ env.tf_working_dir }}
          args: decrypt --mode=full --simple-key=${{ secrets.TERRAHELP_KEY }} --nobackup --file terraform.tfstate --file terraform.tfstate.backup
      - name: 'Terraform Init'
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: ${{ env.tf_version }}
          tf_actions_working_dir: ${{ env.tf_working_dir }}
          tf_actions_subcommand: 'init'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terraform Plan'
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: ${{ env.tf_version }}
          tf_actions_working_dir: ${{ env.tf_working_dir }}
          tf_actions_subcommand: 'plan'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terrahelp Encrypt'
        uses: gesellix/terrahelp-github-action@master
        with:
          th_working_dir: ${{ env.tf_working_dir }}
          args: encrypt --mode=full --simple-key=${{ secrets.TERRAHELP_KEY }} --nobackup --file terraform.tfstate --file terraform.tfstate.backup
...
````

## Inputs

Inputs configure the GitHub Action to modify its behaviour.
You can pass most parameters via the generic `args` input, which is shown in the example above.
For a complete overview of command line paramters and options,
please read the official [opencredo/terrahelp](https://github.com/opencredo/terrahelp) documentation.

- `th_working_dir` - (Optional) The working directory to change into
 before executing Terraform subcommands.
 Defaults to `.` which means use the root of the GitHub repository.

## Secrets

Secrets are similar to inputs except that they are encrypted and only used by GitHub Actions.
It's a convenient way to keep sensitive data out of the GitHub Actions workflow YAML file.

**WARNING**: These secrets could be exposed if the action is executed on a malicious Terraform file.
To avoid this, it is recommended not to use these GitHub Actions on repositories where untrusted users can submit pull requests.

The example above shows how to use the `secrets.TERRAHELP_KEY` as `simple-key` for decryption.

## Outputs

None.
