# GitHub Actions

Automate the build and deployment of your project with GitHub Actions.

> **Note** If you are stuck in a given exercise that involves code changes, we have provided you with solutions in a branch (one per exercise)

## Exercise 1 - Provisioning Azure infrastructure to deploy the application to.

We will provision an [Azure Static Web App](https://learn.microsoft.com/en-us/azure/static-web-apps/overview). 

Azure Static Web Apps are perfect to deploy Nextjs applications with support for a Single-Page Application (SPA) interface with a backend API.

### Infrastructure as Code Configuration using Azure Resource Manager

To deploy your web app, you need some infrastructure. You’re going to add an [Azure Resource Manager (ARM) template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) which describes what you want to create in Azure.

> You're going to execute what you need from Azure using a JSON-based configuration file known as an Azure Resource Manager template or just *ARM template*. You can then have your workflow push the ARM template to Azure,  where the Azure fabric will create the infrastructure you need.

We have placed the ARM template in the `InfrastructureAsCode/` folder of your repository. This template will create a static web app in Azure. You don't need to make any changes to this file, but just inspect the template to see what it's doing. Defining infrastructure as code is an industry best practice. Other options for defining infrastructure as code include [Terraform](https://www.terraform.io/), [CloudFormation](https://aws.amazon.com/cloudformation/), and [Pulumi](https://www.pulumi.com/).

We are going to provision two separate web apps. One for dev and another for production (even though Static Web Apps support [preview environments](https://learn.microsoft.com/en-us/azure/static-web-apps/preview-environments), we will skip them for simplicity).

1.	Click the **Actions** tab on the repo toolbar.

1.	Click the **new workflow** button (top left)

1.  Click on `set up a workflow yourself` (top)
  
1.  Replace `main.yml` filename with an appropriate filename (eg: `provision.yml`)

  > **Tip** If you press Control + Space (before typing `name`), you'll get a list of all possible attributes for a given context. Go ahead, give it a try, press Control + Space in the editor and see what happens.

1.  Enter a `name` (or press control-Space and select `name` from the dropdown) attribute for your workflow, for example `Provision Infrastructure`

    ```YAML
    name: Provision Infrastructure
    ```

1.  Enter a `on` attribute for your workflow, with the value `workflow_dispatch`. This means that this workflow can be [triggered manually](https://github.blog/changelog/2020-07-06-github-actions-manual-triggers-with-workflow_dispatch/) on the UI. You could also add an `inputs` in case you wanted to collect any user inputs from the UI.

    ```YAML
    on:
      workflow_dispatch:
    ```

1.  Set the permissions on the workflow by adding `permissions` element to the _top level_ of the file. It should have two elements as children `contents: read` so we can clone the repo and `id-token: write` so we can use [OIDC](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers).

    ```YAML
    permissions: 
      contents: read
      id-token: write
    ```
    
1.  Add a `jobs` section and inside it, a `provision` job. 

    ```YAML
    jobs:
      provision:
    ```

1.  Add a `runs-on: ubuntu-latest` attribute to the `provision` job. This means that the job will run on a [GitHub-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners) with latest version of Ubuntu.

    ```YAML
        runs-on: ubuntu-latest
    ```

    > If you want to know what software is installed on GitHub Hosted runners you can later take a look at the [runner-images](https://github.com/actions/runner-images) repo.

1.  Add a `steps` section to the `provision` job. This is where you'll add the steps that will be executed as part of the job.

    ```YAML
        steps:
    ```

1.  Add a step to clone the repository so we can use the ARM template to provision the infrastructure. 

    ```YAML
        - name: Checkout
          uses: actions/checkout@v3
    ```

1.  Add a step to login to Azure. (don't forget to replace the `FILL PLACEHOLDER` with values)

    ```YAML
        - name: Login to Azure
          uses: azure/login@v1
          with:
            client-id: FILL PLACEHOLDER
            tenant-id: FILL PLACEHOLDER
            subscription-id: FILL PLACEHOLDER
    ```

    > You can get the OIDC login values (it's already pre formatted so you can copy and paste) from your issues in the lab repo. The title of the issue is [Data for your labs](../../../issues/3), the issue includes a snippet you can just copy & paste (make sure it's indented though).

    > **Tip** You don't need need to get the info from the repository, you can see issues in codespaces. Click on the GitHub icon in the sidebar and see issues assigned to you.
    > Or if you prefer the command line, you can also run `gh issue list` on the terminal and then `gh issue view 3`

1.  Add a step to execute the ARM template using the [azure/arm-deploy](https://github.com/azure/arm-deploy) action to create the dev environment.

    ```YAML
        - name: Deploy ARM Template for Dev Environment
          uses: azure/arm-deploy@v1
          with:
            resourceGroupName: rg-${{ github.event.repository.name }}-${{ github.event.repository.id }}
            template: InfrastructureAsCode/azuredeploy.json 
            parameters: name=ghu22-swa-dev-${{ github.event.repository.id }}
    ```

    > Notice we are fetching the Azure subscription id from the secrets using an expression (expressions are defined with `${{ }}`) we are also using the `github` context to fetch the repository id and and the name from the event payload.
    > We could also get this value that we used previously for `azure/login`. Or even better, place these values on enviroment variables to avoid repetition of values. See [Environment Variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables).

1.  Add a second step to execute the ARM template using the [azure/arm-deploy](https://github.com/azure/arm-deploy) action to create the production environment enviroment. **Don't copy and past the previous step. Notice the parameters value is different, the resource group name doesn't say `dev`**

    ```YAML
        - name: Deploy ARM Template for Production Environment
          uses: azure/arm-deploy@v1
          with:
            resourceGroupName: rg-${{ github.event.repository.name }}-${{ github.event.repository.id }}
            template: InfrastructureAsCode/azuredeploy.json 
            parameters: name=ghu22-swa-${{ github.event.repository.id }}
    ```
    > **Note** Alternatively we could place these steps in separate jobs to create the dev and production environments in parallel or we could place the two environments in the same ARM template so creation of two environments would be transparent to the user.

1.  Commit the file to the `main` branch.

1.  You should now have a workflow with a content similar to this:

    ```YAML
    name: Provision Infrastructure

    on: workflow_dispatch

    jobs:
      provision:
        runs-on: ubuntu-latest

        permissions: 
          contents: read
          id-token: write

        steps:
        - name: Checkout
          uses: actions/checkout@v3

        - name: Login to Azure
          uses: azure/login@v1
          with:
            client-id: FILL
            tenant-id: FILL
            subscription-id: FILL

        - name: Deploy ARM Template for Dev Environment
          uses: azure/arm-deploy@v1
          with:
            resourceGroupName:  rg-${{ github.event.repository.name }}-${{ github.event.repository.id }}
            template: InfrastructureAsCode/azuredeploy.json
            parameters: name=ghu22-swa-dev-${{ github.event.repository.id }}

        - name: Deploy ARM Template for Production Environment
          uses: azure/arm-deploy@v1
          with:
            resourceGroupName:  rg-${{ github.event.repository.name }}-${{ github.event.repository.id }}
            template: InfrastructureAsCode/azuredeploy.json
            parameters: name=ghu22-swa-${{ github.event.repository.id }}
    ```

1.	Now click the **Start commit** button. Add a message like **Provision Infra using actions**.
1.	Click **Commit new file** straight to the main branch.
1.	Click the **Actions** link on the toolbar.
1.	Click the name for your new workflow (the name you defined previously).
1.  Click the **Run workflow** button (top right in blue bar)
1.  Click the **Run workflow** green button
1.  You can now proceed to the next exercise while the workflow runs (or wait for it to finish if you want to see the logs)

> What have you learned?
> - Creating a [workflow](https://docs.github.com/en/actions/quickstart), [events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows), using actions
> - Using [expressions](https://docs.github.com/en/actions/learn-github-actions/expressions)
> - Accessing GitHub [context](https://docs.github.com/en/actions/learn-github-actions/expressions) data on workflows.
> - What an [ARM template](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) is

> Did you know?
> - You can interact with GitHub directly from codespaces using the [VSCode GH extension](https://vscode.github.com/). Installed by default on Codespaces, you can see/create issues, create PRs, manage PR reviews, among other things.
> - GitHub supports [OpenID connect](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-cloud-providers) to authenticate against cloud services so you can do secure password-less connections?

> :bulb: branch with the solution for this exercise: **solution-lab2-exercise1** (it doesn't run as is. It required that you fill OIDC values with the provided values in your issue)

## Exercise 2 - Actions for build, test and Deploy.

### Edit the workflow file

In the first lab, you have seen the `Build and Test` workflow, now it's the time to enrich it with the app deployment to Azure.

1.  Using a web browser, access your lab repo that you used for Codespaces.

1.  Open the codespace and navigate to the `.github/workflows` folder.

1. Make sure to `Sync` or `git pull` the changes we made from outside the Codespace! (you can do this from the terminal or from the VSCode status bard. Click on the `Sync` icon; bottom left after the `main` branch name).

   > More info at [Git Status Bar Actions](https://code.visualstudio.com/docs/sourcecontrol/overview#_git-status-bar-actions)

1.  Edit the `build_and_test.yml` file.

1.  Change the `name` to `Build, Test and Deploy`. This will just affect the UI of the workflow, to have a friendlier and something that reflects the new functionality.

1.  Rename the file to `build_test_deploy.yml`.

1.  Let's add a deployment job called `deploy_dev` (and also a name), after the `build` job. (in the `jobs` section at the same indentation level as `build`).
    
    > **Tip** Collapse the `build` job to make it easier to find the right place to add the `deploy_dev` job.

    ```yaml
    jobs:
      build:
        ... (omitted)
      deploy_dev:
        name: Deploy to Dev
    ```

We have prepared two different ways to deploy the application for educational purposes:

A.  Using action directly on your job, this will require creating a secret with the Azure credentials and configure the action to build and deploy the application.

B.  Using [reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows). We have prepared a reusable workflow for you, all you need to do is the call it with the appropriate parameters. A reusable workflow has the benefit of using a standardized way to deploy; defined at the organization level, it also has added security benefits and a central way to change the process which wil be automatically reflected on all workflows that use it.

Proceed to Exercise _2.A_ or _2.B_ depending on the scenario you want to implement.

We recommend Scenario B, but you can always do both. :)

### Exercise 2.A - Deploy using actions
 
1.  Open a terminal and run the command `az staticwebapp secrets list --name ghu22-swa-dev-$(gh api repos/$GITHUB_REPOSITORY --jq .id) --resource-group rg-$RepositoryName-$(gh api repos/$GITHUB_REPOSITORY --jq .id)`
    > Notice how we are leveraging the [GitHub CLI](https://cli.github.com/) (the call to `gh api....`) to get the repository id. This is a great way to get information from the repository without having to parse the JSON response.
    > You may be wondering how you are able to call an Azure CLI command without being asked for credentials. How were we able make calls to Azure without authentication? Can you find how?

1.  Go to the repo settings (in the repository, not Codespaces), expand `Secrets` on the left menu, click on `Actions` and add a repository secret called `AZURE_STATIC_WEB_APPS_API_TOKEN` with the value of the `apiKey` (no quotes) from the previous command.

    > **Tip** You can create secrets directly from Codespaces by clicking on the `GitHub Actions` extension (the extension icon is a circled arrow) and then clicking on the `+` icon on the top right of the Secrets section.

    > Wouldn't it be great if the secret creation was automated? we thought so as well, so we added a script `.github/scripts/add-web-app-static-secret.sh` to automate this. Later on, you may want to call the script in the provisioning workflow we created on `Exercise 1` (hint: it may require extra permissions to create the secret and we may have added a bug intentionally). Take a look at the file to see how we can use [Github CLI](https://cli.github.com) to automate processes with GitHub.

1.  Continue editing the workflow file

1.	Add a `runs-on: ubuntu-latest` line (inside the `deploy_dev` job).

1.  Add a `needs: build` line to the `deploy_dev` job. This means that the `deploy_dev` job will only run if the `build` job was successful.

1.  Add a `steps` section to the `deploy_dev` job.

1.  Add a step to clone the repository 

    ```YAML
        - name: Checkout
          uses: actions/checkout@v3
    ```

1.  Now let's add the [Azure/static-web-apps-deploy](https://github.com/Azure/static-web-apps-deploy) action after checkout. This action both builds and deploys the nextjs application.

    ```yaml
        - name: Deploy to Azure Static Web Apps
          uses: azure/static-web-apps-deploy@v1
          id: builddeploy
          with:
            azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
            repo_token: ${{ secrets.GITHUB_TOKEN }}
            action: "upload"
            app_location: "/"
            api_location: "/api"
    ```

1.  Let's add this step as well so we have the URL the deployed app in the workflow UI

    ```yaml
        - name: Show the deployed app url
          run: echo "::notice title=Deployed App Url (dev)::${{ steps.builddeploy.outputs.static_web_app_url }}"
    ```

    > This is using a [workflow command](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions) to add an annotation. Also notice that we are using the `outputs` from the previous step, outputs is a mechanism to pass data between steps.

1.  This should be the job you added
    ```yaml
      deploy_dev:
      name: Deploy to Dev
      runs-on: ubuntu-latest
      needs: build

      steps:
        - name: Checkout
          uses: actions/checkout@v3

        - name: Deploy to Azure Static Web Apps
          uses: azure/static-web-apps-deploy@v1
          id: builddeploy
          with:
            azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
            repo_token: ${{ secrets.GITHUB_TOKEN }}
            action: "upload"
            app_location: "/"
            api_location: "/api"
    ```

1.  We are now ready to commit. Click on the `git` icon in the sidebar. Select the `build_test_deploy.yml` (both the file and the deletion since we did a rename) file and click the **Stage changes** button. (the plus sign).

1.  Add a message like **Add deploy job dev**

1.	Now let's commit and push the changes. Click on the down arrow  of **Commit** green button (this will pull a dropdown), click on "Commit & Push"

1.	Navigate to the repo (the easy way is to switch to the previously open tab with the repo) and Click the **Actions** link on the toolbar. The workflow should now be running (notice the name has been changed from `Build and Test` to `Build, Test and Deploy`). Click on the run to see the details, wait a few minutes until it's finished. Click on the `⌂ Summary` to view the URL where the app was deployed in the `Annotations` section.

1.  Copy the URL and open it in a new tab, you should see the application running.

1.  Append `/api/status` to the app URL and you should see the API response:

    ```json
    {"status":"ok","version":"1.0.0"}
    ```

> What have you learned?
> - Using [secrets](https://docs.github.com/en/actions/reference/encrypted-secrets) to store sensitive data.
> - Using default environment variables. See [Default environment variables for your codespace](https://docs.github.com/en/codespaces/developing-in-codespaces/default-environment-variables-for-your-codespace)
> - Using [GitHub CLI](https://cli.github.com) to make calls to [GitHub API](https://docs.github.com/en/developers/overview/about-githubs-apis)
> - How to use [job summaries](https://github.blog/2022-05-09-supercharging-github-actions-with-job-summaries/)

> Did you know?
> - Besides regular GitHub CLI commands, you can call any GitHub API using the `api` command? try running `gh api /user` for example.
> - You can find over 15000 actions in the GitHub [marketplace](https://github.com/marketplace)?

Congratulations you have now finished lab 2, you can now explore the resources we have provided or continue with [optional exercises](lab2-optional.md)

> :bulb: branch with the solution for this exercise: **solution-lab2-exercise2A** 

### Exercise 2.B - Deploy using a reusable workflow

1.  Add a `needs: build` line to the `deploy_dev` job.

1.  Set the permissions on the **workflow** or `deploy_dev` job by adding `permissions` element to the top level of the file. It should have two elements as children `contents: read` so we can clone the repo and `id-token: write` so we can use OIDC

    ```YAML
    permissions: 
      contents: read
      id-token: write
    ```

1.  Add a `uses: octocloudlabs/common-workflows/.github/workflows/deploy_static_webapp.yml@v1` to call the reusable workflow.

1.  Add a `with` to the `uses` with the following parameters:
    - `client-id`
    - `tenant-id`
    - `subscription-id`
    - `name` - The name of your static web app. Use `ghu22-swa-dev-${{ github.event.repository.id }}` like you did on the provision workflow.

    The values for these parameters are available at an issue that we created on the repository with the title [Data for your labs](../../../issues/3)

    > **Tip** You don't need need to get the info from the repository, you can see issues in Codespaces. Click on the GitHub icon in the sidebar and see issues assigned to you.
    > You can also use the CLI, by typing `gh issue list` and then `gh issue view 3`.

    > If you are wondering why we use no secrets, it's not because deploy is wide open :), but because the reusable is using OpenID Connect to authenticate in Azure, so there is no need to store credentials, it's a credential-less authentication method.

    > **Note**  You can ignore the squiggly lines you might be seeing on the reusable workflow reference job id (`deploy_dev`) and `with` reference.

2.  This should be your job:

    ```YAML
      deploy_dev:
        name: Deploy to dev
        needs: build
        permissions: 
          contents: read
          id-token: write
        uses: octocloudlabs/common-workflows/.github/workflows/deploy_static_webapp.yml@v1
        with:
          client-id: FILL PLACEHOLDER
          tenant-id: FILL PLACEHOLDER
          subscription-id: FILL PLACEHOLDER
          name: ghu22-swa-dev-${{ github.event.repository.id }}
      ```

3.  > **Note** if you haven't fixed the linting errors on the previous lab, comment the linting step on the build job.

4.  Click **Commit** and commit the changes you have made (don't forget to push it as well)

1.	Click the **Actions** link on the toolbar (on the repository). The workflow should now be running. Click on the run to see the details, wait a few minutes until it's finished. Click on the `⌂ Summary` to view the URL where the app was deployed in the `Annotations` section or in the job summary (we wanted to give you several ways how a WF can show data to users)

1.  Copy the URL and open it in a new tab, you should see the application running.

1.  Append `/api/status` to the app URL and you should see the API response:
      
      ```json
      {"status":"ok","version":"1.0.0"}
      ```

> What have you learned?
> - Using [reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

Congratulations you have now finished lab 2, you can now explore the resources we have provided or continue with [optional exercises](lab2-optional.md)

