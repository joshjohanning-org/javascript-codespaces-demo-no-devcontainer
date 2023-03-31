# Lab 2

## Exercise 3 (optional) - Deploy to production environment

On exercise 2 we deployed the application to the development environment, now we are going to deploy it to the production environment.

As with exercise 2, we are going to give you different paths to proceed, you can choose the one that you prefer, it is now a good opportunity to try the other
way. 

Suggestion: If you did 2.A now you do 3.B and vice versa (so you get to experience both!).

### Exercise 3.A - Deploy to environments using actions

1.  Continue working in your codespace (if you closed it, open it again).

1.  Open a terminal and run the command `az staticwebapp secrets list --name ghu22-swa-$(gh api repos/$GITHUB_REPOSITORY --jq .id) --resource-group rg-$RepositoryName-$(gh api repos/$GITHUB_REPOSITORY --jq .id)`
    > Notice how we are leveraging the [GitHub CLI](https://cli.github.com/) to get the repository id. This is a great way to get information from the repository without having to parse the JSON response.

1.  Go to the repo settings (in your repository browser tab and not on Codespaces), click on `Environments` on the left menu, click on `New Environment`, add `Production` in the text box and click `Configure Environment`. 

1.  Scroll down and click on `Add Secret`, enter  `AZURE_STATIC_WEB_APPS_API_TOKEN` as the secret name with the value of the `apiKey` from the command you executed previously.

    > **Tip** You can create secrets directly from Codespaces by clicking on the `GitHub Actions` extension (the extension icon is a circled arrow) and then clicking on the `+` icon on the top right of the Secrets section.

    > Wouldn't it be great if the secret creation was automated? we thought so as well, so we added a script `.github/scripts/add-web-app-static-secret.sh` to automate this. Later on, you may want to call the script in the provisioning workflow we created on `Exercise 1` (hint: it may require extra permissions to create the secret and we may have added a bug intentionally). Take a look at the file to see how we can use [GitHub CLI](https://cli.github.com) to automate processes with GitHub.

1.  Edit the workflow file you edited on Exercise 2 (`build_test_deploy.yml`) and add a `deploy` job, after the `deploy_dev`.

1.	Add a `runs-on: ubuntu-latest` line (inside the `deploy` job).

1.  Add a `needs: deploy_dev` line to the `deploy` job. This means that the `deploy` job will only run if the `deploy_dev` job was successful.

1.  Add a `Environment` line to the `deploy` job. This means that we are targeting the deploy environment, if we reference the secret that we just created it will use the value of the environment secret and not the secret with the same name defined at the repository level (if you have chosen exercise `2.A`). It will also add to the UI the URL of the deployed application

    ```yaml
        environment: 
          name: Production
          url:  ${{ steps.builddeploy.outputs.static_web_app_url }}
    ```

1.  Add a `steps` section to the `deploy` job.

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
      run: echo "::notice title=Deployed App Url (prod)::${{ steps.builddeploy.outputs.static_web_app_url }}"
    ```

    > This is using a [workflow command](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions)

1.  We are now ready to commit. Click on the `git` icon. Select the `build_test_deploy.yml` file and click the **Stage changes** button. (the plus sign).

1.  Add a message like **Add production deploy job**

1.	Now let's commit and push the changes. Click on the down arrow of **Commit** green button (this will pull a dropdown), click on "Commit & Push"

1.	Navigate to the repo (the easy way is to open the tab with the repo) and Click the **Actions** link on the toolbar. The workflow should now be running. Click on the run to see the details, wait a few minutes until it's finished. Click on the `⌂ Summary` to view the URL where the app was deployed in the `Annotations` section.

1.  Copy the URL and open it in a new tab, you should see the application running.

1.  Append `/api/status` to the app URL and you should see the API response:

    ```json
    {"status":"ok","version":"1.0.0"}
    ```

1.  So what is difference from what we did before? Let's check, because we are not done yet.

1.  Navigate to your repository and click on the `Code` Tab.

1.  Notice on the right side of the screen, you have a sidebar that says `Environments (1)` (it shows `Production` with an `active` tag).

1.  Click on `Environments` and the deployments page will open. The Deployments page shows the status of the deployments to the different environments, this allows you to track which versions have been deployed to each of the environments (in this case we only have one environment, but you can have as many as you want).)

1.  Since we set the environment URL in the workflow as well, if you click on the `View Deployment` button you will be taken to the deployed application.

1.  But we are not happy yet, when the workflow is executed, three jobs run in sequence `Build`, `Deploy Dev` and `Deploy`. You may not want to deploy to production immediately after deploying to dev, so let's edit the environment. Click on the repo `Settings`, then `Environments` and click on `Production`.

1.  Enable the `Required Reviewers` checkbox and add yourself as a reviewer. This means that you will have to approve the deployment to production. (`Build` and `Deploy_Dev` will run unattended). Click on `Save Protection Rules`

1.  With this setting users will not be able to deploy to production by changing the workflow (since the secret is associated with the environment) unless you approve it.

1.  But it still means they can try to trick you to approve a deployment by deploying directly from a feature branch. Let's prevent that. Look for `Deployment branches` section and click on the `All branches` dropdown, click on `Selected Branches` and then click on `Add deployment branch rule` and enter `main` as the branch name. Click on `Add rule`.

1.  With these two settings, deployments to production will only be possible if you approve it and only from the `main` branch.

1.  Trigger the workflow by changing a file if you want to see reviewing in action. Also take the opportunity to see that in the workflow run UI you now have the URL of the application visible in the Job _box_.

> What have you learned?
> - Using [Environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
> - Configuring [reviewing deployments](https://docs.github.com/en/actions/managing-workflow-runs/reviewing-deployments)
> - Using [deployment branches](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#deployment-branches) rules to prevent deployments from non main branch.
> - How to use [job summaries](https://github.blog/2022-05-09-supercharging-github-actions-with-job-summaries/)

### Exercise 3.B - Deploy to environments using a reusable workflow

1.  Continue working in your codespace (if you closed it, open it again).

1.  Edit the workflow file you edited on Exercise 2 (`build_test_deploy.yml`) and add a `deploy` job, after the `deploy_dev`.

1.  Add a `needs: deploy_dev` line to the `deploy` job.

1.  Add a `uses: octocloudlabs/common-workflows/.github/workflows/deploy_static_webapp.yml@v1` to call the reusable workflow.

1.  Add a `with` to the `uses`with the following parameters (get the value for the first 3 parameters in an issue with the title `Data for your labs`
    - `client-id`
    - `tenant-id`
    - `subscription-id`
    - `name` - The name of your static web app. Use `ghu22-swa-${{ github.event.repository.id }}` like you did on the provision workflow.
    - `environment` - The environment name, use `Production` as the value (this parameter is optional, that is why we haven't passed on exercise 2B)

    The values for these parameters are available at an issue that we created on the repository with the title `Data for your labs`

      > **Tip** You don't need to get the info from the repository, you can see issues in codespaces. Click on the GitHub icon in the sidebar and see issues assigned to you.

      > If you are wondering why we use no secrets, it's because the reusable is using OpenID Connect to authenticate with Azure, so there is no need to store credentials, it's a credential-less authentication method.

2.  This should be your job:
    
    ```yaml
      deploy:
        needs: build
        permissions: 
            contents: read
            id-token: write

        deploy_app:
            uses: octocloudlabs/common-workflows/.github/workflows/deploy_static_webapp.yml@v1
            with:
                client-id: FILL PLACEHOLDER
                tenant-id: FILL PLACEHOLDER
                subscription-id: FILL PLACEHOLDER
                name: ghu22-swa-${{ github.event.repository.id }}
                environment: Production
    ```

    > Since we are using the same service principal as before (a bad practice) this would a good opportunity to place the values for (`client-in`,`tenant-id`,...) on environment variables to avoid repetition. See [Environment Variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables).

3.  Take a look at how environment is implemented in the [reusable workflow](https://github.com/octocloudlabs/common-workflows/blob/main/.github/workflows/deploy_static_webapp.yml). It's using the `environment` parameter to set the environment name (and the URL as well)

4.  Click **Commit** and commit the changes you have made (don't forget to push it as well)

1.	Click the **Actions** link on the toolbar. The workflow should now be running. Click on the run to see the details, wait a few minutes until it's finished. Click on the `⌂ Summary` to view the URL where the app was deployed in the `Annotations` section or in the job summary or on the `deploy` job itself.

1.  Copy the URL and open it in a new tab, you should see the application running.

1.  Append `/api/status` to the app URL and you should see the API response:
      
      ```json
      {"status":"ok","version":"1.0.0"}
      ```
1.  So what is difference from what we did before? Let's check, because we are not done yet.

1.  Navigate to your repository and click on the `Code` Tab.

1.  Notice on the right side of the screen, you have a sidebar that says `Environments (1)` (it shows `Production` with an `active` tag).

1.  Click on `Environments` and the deployments page will open. The Deployments page shows the status of the deployments to the different environments, this allows you to track which versions have been deployed to each of the environments (in this case we only have one environment, but you can have as many as you want).)

1.  Since we set the environment URL in the workflow as well, if you click on the `View Deployment` button you will be taken to the deployed application.

1.  But we are not happy yet, when the workflow executed, three jobs run in sequence `Build`, `Deploy Dev` and `Deploy`. You may not want to deploy to production immediately, so let's edit the environment. Click on the repo `Settings`, then `Environments` and click on `Production`.

1.  Enable the `Required Reviewers` checkbox and add yourself as a reviewer. This means that you will have to approve the deployment to production before it is deployed. (but `Build` and `Deploy_Dev` will run unattended). Click on `Save Protection Rules`

1.  With this setting users will not be able to deploy to production by changing the workflow (since the secret is associated with the environment) unless you approve it.

1.  But it still means they can try to trick you to approve a deployment by deploy directly from a feature branch. Let's prevent that. See where `Deployment branches` is and click on the `All branches` dropdown, click on `Selected Branches` and then click on `Add deployment branch rule` and enter `main` as the branch name. Click on `Add rule`.

1.  With these two settings, deployments to production will only be possible if you approve it and only from the `main` branch.

1.  Trigger the workflow by changing a file if you want to see reviewing in action. Also take the opportunity to see that in the workflow run UI you now have the URL of the application visible in the Job _box_.

> What have you learned?
> - Using [reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
> What have you learned?
> - Using [Environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
> - Configuring [reviewing deployments](https://docs.github.com/en/actions/managing-workflow-runs/reviewing-deployments)
> - Using [deployment branches](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#deployment-branches) rules to prevent deployments from non main branch.
