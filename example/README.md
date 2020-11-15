# Usage example

## How to run
Go to `gad-usage` folder. Then init the container:

    sh init-volume-snippet.sh

Then run the container:

    sh run-snippet.sh

## Config
It mounts `config.json` as a volume and deploy key and registry credentials as secrets.

Configuration manages two example projects: `nginx` and `python`.

## Workflow

Assuming workflow is following:

1. Commit a new version of a managed project.
2. Tag it with a new tag: `en/99`
3. Push the tag to GitHub, so actions build a new tagged image of the project, e.g. `example-nginx:en-99`
4. Move `en-nginx` branch to the tagged commit and push to GitHub, so following happens:
    * GAD triggers the project change and pulls `en-nginx` branch.
    * It checks tags of the current commit and matches them to `en.*` pattern.
    * If it founds the tag it triggers docker to pull the tagged image and restart the service.

