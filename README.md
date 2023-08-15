# Custom DAMASK image

This repo is meant to be used to generate docker images with custom modifications to the [DAMASK](https://github.com/eisenforschung/DAMASK) source code.

## Usage

Fork the [DAMASK](https://github.com/eisenforschung/DAMASK) repo to modify the source code.

Fork this repo too, and go to the actions tab in github.
The first time you go the the actions tab it will ask you to confirm that you want to activate workflows.
After confirming and enabling the workflows, you should see a `build-push` action on the leftmost menu. Select it.
Highlighted in blue, you should see a flash that indicates the workflow has a "workflow_dispatch" event trigger, and a dropdown button to trigger the workflow.

When you click the "Run workflow" button, it should prompt you with some options.

The most important ones are the source (your DAMASK fork) and target (the ghcr repo where the image will be pushed).

When the action runs, it will try to push the image to:
```
ghcr.io/xxxxx/damask:yyyyy
```
The repo name (`xxxxx`) should be set to somewhere you have access to (for example your personal github user). If you do not have the right credentials you will get an error along the lines of `denied: permission_denied: The requested installation does not exist.` when pushing the image, so you will not be able to access it.

The tag (`yyyyy`) is by default `latest`. If you do not want the latest tag, untick the relevant checkbox.

You can also specify an additional custom tag. This is optional, you can leave it blank.

After confirming your inputs, a successful action should take 5-8 min to run.

### Changing default values for the inputs

You can change the default values for the `source` and `target` of your image by modifying the github action in `.github/workflows/build-push.yml` (lines 11 and 16, respectively).

## Getting and sharing your image

The home page of your fork should now be linked to the package, and you should be able to pull the image with
```
docker pull ghcr.io/xxxxx/damask:yyyyy
```