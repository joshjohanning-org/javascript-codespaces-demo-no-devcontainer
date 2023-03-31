# GitHub Codespaces

Blazing fast cloud developer environments

In this lab, you'll work with GitHub Codespaces and a next.js app (don't worry you don't need to be proficient in Javascript or next.js to complete this workshop labs)

> **Note** If you are stuck in a given exercise that involves code changes, we have provided you with solutions in a branch (one per exercise)

### Exercise 1 - Look at the failed CI workflow

1. Click on the `Actions` tab and notice that the CI (called `Build and Test`) has failed.

1. Click on the failed run to see it's details.

1. See the logs of the job that failed

1. Try to understand why it has failed

    <details>
        <summary>Tip</summary>
        <ul>The linting failed. It flagged 4 things that should be fixed</ul>
    </details>

### Exercise 2 - Create a Codespace

Let's create a codespace and see how it has been configured.

1. On **your** repo's home page, click the green **<> Code** button.

1. Select the **Codespaces** tab.

1. Click **Create codespace on main**.

1. Wait for your codespace to start. This could take a few minutes.

1. When it opens, you may see a popup that says "**The extension 'Github Actions' wants to sign in using GitHub**", click on `Allow`, a new tab/window will open click on '**Continue**' (no need for extra authorizations in case they are visible).

1. Examine the user experience (Visual Studio Code) without clicking on the interface. In the Terminal window in the middle of the screen you'll see messages as your codespace finishes spinning up.

1. Click on the bottom left of the screen on the cog icon and notice that `Synch Settings is Off (1)` if you are a VS Code user, feel free to enable it to get your settings synchronized.

1. Open a terminal and run the command `devcontainer-info` to see the information about the container that is running your codespace. If you are curious you can click on the link to see what the image that we are using contains.

1. Open the [devcontainer.json](../.devcontainer/devcontainer.json) file (in the `.devcontainer` folder) and see the configuration that has been used to create our codespace. Read the comments. We have customized the codespace using this file to give the best developer experience for this workshop.

1. Click on the `extensions` icon on the side bar and see that we have installed a bunch of extensions for a nicer development experience.

1. You are now ready to go the next exercise.

> What have you learned?
> - How to [create a Codespace](https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace?tool=webui) ready to start working in no time without any additional setup
> - You can customize the developer experience by having a standardized development environment by creating a [devcontainer.json](../.devcontainer/devcontainer.json) file. You can personalize to your liking using [Dotfiles](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account) and many more things. For more information read [introduction to dev container](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/introduction-to-dev-containers)
> - You can [synchronize your settings](https://code.visualstudio.com/docs/editor/settings-sync) to tailor your experience to your needs and that will follow from codespace to codespace and the desktop version of VS Code as well.

> Did you know?
> - If you prefer to use VSCode Desktop to edit code, but still run everything on the cloud you can open the code on your machine by selecting the option ´Open in VS Code Desktop` available on the menu (top left of the screen the 3 horizontal lines icon).
> - You can open a codespace directly from the command line by running `gh codespace create` with the [github CLI](https://cli.github.com) tool? The same command line even allows you to SSH into your codespace.
> - The [Github Actions](https://marketplace.visualstudio.com/items?itemName=cschleiden.vscode-github-actions) extension allow you to interact with actions (see runs, trigger workflows, manage secrets,...) without leaving Visual Studio Code.

### Exercise 3 - Fix the CI failure

1. In exercise 1, you saw that the CI workflow failed, it's not that the code doesn't work but the linter flagged some things that need to be fixed.

1. Open [octodex.js](../lib/octodex.js) file in VS Code (stored in the `lib` folder)

    > Tip: Control+P, is the shortcut for `Quick Open`. It's very convenient to open a file without using the mouse to locate the file in the explorer window.

1. Fix the linting issue

    <details>
      <summary>Hint</summary>
      <ul>
        look at the bottom left of VS Code status bar and you will the errors counter or look at the <strong>PROBLEMS</strong> tab)
      </ul>
      </details>

1. Select linting errors one by one and fix them (Hint: the eslint extension can do all the work for you. If you click on the problem detail, it will show a lightbulb that you can click and choose the appropriate fix or just hover it and click `quick fix`)

1. Commit the code changes to `octodex.js` with a message (see below on ways to improve your message)
    > We have created some issues for you to track :bug: bugs. You can take a look at them by : navigating to `Issues` on your repository or even better click on GitHub icon on the sidebar to see the issues right there from your codespace (you can also run the `gh issue list` on the terminal). Look for the issue with the title `Fix linting errors` if you include in your commit message `Fixes #XX` where XX (in this case it should be `1`) is the number of the issue you are fixing, GitHub will:
      - Close the issue for you automatically.
      - Link the commit to the issue (you can see it on the issue timeline as `<USER> closes this as completed...`).
    > **Tip** You don't even need to look for the issue. Once you type `#` in the commit message window, a dropdown will appear with your issues (don't click in it though. It will put the full title on the commit message, which works as a reference but doesn't closes it.)

1. Push your changes - you can do it from the command line (`git push`) or from the `Source Control` tab by clicking `Sync Changes`.

1. At this point, feel free to play around, run lint on the terminal, and even make "basic" code changes if you like (don't break it you'll use it later.) When ready, continue on.

1. You can switch to the repository tab or close your Codespaces tab (the codespace will be automatically stopped after 30 minutes of inactivity).
    > **Tip**: If you closed the repository browser tab you can click on the three lines icon on the top left of the screen to open the repository tab browser again by clicking on `Go To Repository`.

1. You can go back to the `actions` tab in the repository and check that the CI Workflow is no longer failing (or running at best).
    > You can also see it on codespaces by clicking on the [GitHub Actions extension](https://marketplace.visualstudio.com/items?itemName=cschleiden.vscode-github-actions) icon. A circled arrow icon on the sidebar below the Octocat.

> What have you learned?
> - We can use any [VS Code extensions](https://code.visualstudio.com/docs/editor/extension-marketplace) to help the development process. (there are plenty from the Marketplace)
> - You can reference and automatically close issue(s) they are referencing with some [keywords](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)

> :bulb: branch with the solution for this exercise: **solution-lab1-exercise3**

### Exercise 4 - Fix the bug

Let's run the application and fix the bug.

1. Re-open the codespace (if you closed it) by going back to the repository home, clicking on the `Code` tab, and clicking on the existing codespace.

1. You are now ready to run the app at the terminal prompt.

1. Open a new Terminal prompt. You can either: 
    - Click on the `+` icon on the top of the bottom-right window near the `^` and `X` icon, OR
    - Open the command palette (`⇧⌘P` on macOS, `ctrl+shift+p` on Windows) type `terminal` and select `Terminal: Create New Terminal`)

1. Next type `npm run dev` and press return. This should launch a web server with the application so you can browse it (you could this right from Code UI as well)

1. When the toast (window) pops up and says **Open in browser** (or **Preview in Editor** to use the simple browser). 
    - You can also:
      - click on link ' https://localhost:3000´ in the output window
      - Click on the antenna icon on the status bar at the bottom
      - Click on the `PORTS` tabs, if the panel is open (if not you can always open with the `View: Focus into panel`)

1. You should see the octodex web site running from your codespace!

1. Oh No! There is a :bug: bug! The images are not showing up. Let's fix it.

1. Find the line that sets the url for the images. (Hint: it's in the `octodex.js` file where we just fixed the linting issues (a couple of lines below))

1. Place a break point on the line that sets the url for the images. (Hint: you can do this by clicking on the left side of the line number)
    <details>
    <summary>Tip</summary>
    <ul>
      This is the line you are looking for:<br/>
      result.image = image[1];
    </ul>
    </details>

1. Press control-C on the terminal to stop the server we started previously with `npm run dev` (If you don't do this, a new server might be started on another port. Look at the terminal for hints)

1. Click on "Run and Debug Icon" 

    <details>
    <summary>Hint</summary>
    <ul>the triangle icon with a bug in it and click on the green triangle on top to start the debugger.
    <ul>
    </details>

1. Navigate to your site - the toast (window) should pop up with your forwarded port (preferably select the preview in editor button). Click on it. The site will spin, and you should note that your codespaces tab now has a red dot indicating that it has hit the breakpoint. If it has stopped on a line we haven't set the debugger click on Continue in the debugger toolbar on top.

1. When the breakpoint is hit, hover the variable that holds the image and see what it is.

1. Fix the code so that the images show up (**hint:** fix the index of the `image` array).
    <details>
    <summary>Tip</summary>
    <ul>
      image is an array, index 0 holds an html img tag while index 1 hold the URL. Change the index from 1 to 0 like this<br/>
      result.image = image[0];
    </ul>
    </details>

1. Save the changes, remove the breakpoint and select continue (click on the first blue icon in the debugger controller bar (a triangle with a bar))

1. Refresh the browser tab with the application (or the simple browser in the editor if you went that route) and check that the images are now showing up.

1. Awesome! You fixed the bug with the broken images! Commit and push the code changes. (**Hint:** You can add `Fixes #2` to your commit message to close out your second issue!) :shipit:

> What have you learned?
> - Code running on codespace that exposes a web server is (privately) accessible from the browser
> - You can debug code running on a codespace

> Did you know?
> - By default the exposed ports are only available to you, but you can make them available to your entire org or the world in general by making it public. See more on [Forwarding ports in your codespace](https://docs.github.com/en/codespaces/developing-in-codespaces/forwarding-ports-in-your-codespace)
> - You can connect your codespaces to access resources on private networks. See more on [Connecting to a private network](https://docs.github.com/en/codespaces/developing-in-codespaces/connecting-to-a-private-network)
> - You can preview your application inside codespaces with [Codespaces Simple Browser](https://github.blog/changelog/2022-10-20-introducing-the-codespaces-simple-browser/) without the need to open a new browser tab?


This is pretty darn cool. Move on to the [next lab](lab2.md) or do the [optional exercises](lab1-optional.md) if you feel you have time (or probably revisit them at the end of the labs).

> :bulb: branch with the solution for this exercise: **solution-lab1-exercise4**

### Resources:
- [About Codespaces - GitHub Docs](https://docs.github.com/en/codespaces)
- [Quickstart for GitHub Codespaces](https://docs.github.com/en/codespaces/getting-started/quickstart)
- [Deep Dive into Codespaces](https://docs.github.com/en/codespaces/getting-started/deep-dive)
- [Managing encrypted secrets for your codespaces](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-encrypted-secrets-for-your-codespaces)
- [Codespaces: Configure Dev Container Configuration Features](https://docs.microsoft.com/en-us/visualstudio/online/reference/configuring#configure-dev-container-configuration-features)
- [Codespaces: Rebuild Container](https://docs.microsoft.com/en-us/visualstudio/online/reference/configuring#rebuild-container)
