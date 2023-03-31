### Exercise 5 (optional) - Configure a prebuild

Let's add a prebuild step to make the start of our codespace even faster.

1. Open the browser on your repository and click on `settings` on the top bar.
1. Click on `Codespaces` on the left menu.
1. Click on `Set up prebuild button`
1. Select the `main` branch 
1. Select the prebuild trigger you find most appropriate (you can always change it later, but for now let's use `On configuration change`)
1. Click on `Reduce prebuild available to only specific regions`
1. Click on the `Create` button.
1. Once the `See output` button is available click on it to be familiar with the prebuild process.
1. This will take a while, you **don't need** to wait for it to finish.
1. You are now ready to proceed to the next lab.

> What have you learned?
> - How to automatically pre build codespaces for faster startup. Learn more about prebuild in [Prebuilding your codespaces](https://docs.github.com/en/codespaces/prebuilding-your-codespaces)
> - How to speed up the startup of your codespace by prebuilding it

> Did you know?
> You can choose in which region the codespace is created? If you don't specify or force a region GitHub will select the region closest to you.
> You can specify the _size_ of your Codespace by specifying it on the `devcontainer.json` file.
> You can configure at the organization level policies for Codespaces. Thinks like which [machine types](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-access-to-machine-types), [base images](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/restricting-the-base-image-for-codespaces) can be used? (among other things).
