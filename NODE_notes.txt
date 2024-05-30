FLASK REACT TUT-----------------------------------------
https://blog.miguelgrinberg.com/post/how-to-create-a-react--flask-project


npx create-react-app <app name>
or 
npm init react-app <app name> 


YARN install---------------------------------------------
https://www.digitalocean.com/community/tutorials/how-to-install-and-use-the-yarn-package-manager-for-node-js
        install globally
                -       npm install --global yarn
        Error Note: "The nearest package directory <directory_name> doesn't seem to be part of the project 
                - The error happens when you have a yarn.lock (or package.json) file higher up in the filetree, 
                  at that point Yarn thinks you're in a workspace you haven't declared and throws.

        Installing all of a Project’s Dependencies
                To download and install all the dependencies in an existing Yarn-based project, use the install subcommand:
                -       yarn install 
        
        Adding a New Dependency to a Project
                Use the add subcommand to add new dependencies to a project:
                -    yarn add <package-name>   


Test our REACT elements----------------------------------
https://babeljs.io/repl/#?browsers=defaults%2C%20not%20ie%2011%2C%20not%20ie_mob%2011&build=&builtIns=false&corejs=3.21&spec=false&loose=false&code_lz=DwCwjAfCCmA2sHsAEB3BAnWATYB6cEQA&debug=false&forceAllTransforms=false&modules=false&shippedProposals=false&circleciRepo=&evaluate=false&fileSize=false&timeTravel=false&sourceType=module&lineWrap=true&presets=env%2Creact%2Ctypescript&prettier=true&targets=&version=7.24.4&externalPlugins=&assumptions=%7B%7D 


MAKE A REACT PROJECT-------------------------------------
npm create vite@<version>


INSTALL PACKAGES-----------------------------------------
npm install 
or
npm i <packagename>@<version>


UNINSTALL PACKAGES---------------------------------------
npm uninstall <package_name>



RUN WEB SERVER-------------------------------------------
npm run dev


ES7+ React/Redux/React-Native snippets-------------------
- install ES7+ from vscode extensions
- type "rafce" when making components


INSTALL NODE JS IN UBUNTU--------------------------------
https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04

- sudo apt update
- sudo apt install nodejs
- sudo apt install npm

    IF using NVM (Node Version Manager)
    -   install the nvm script throught their github
            -   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    -   source ~/.bashrc
    -   choose the version you want
            -   nvm list-remote
    -   nvm install <version>
    -   use the latest available 8.0.x release
            ex: nvm use 8.0

    -   if already installed you can choose from the installed versions by
            -   nvm list

removing Node.js
- sudo apt remove nodejs
or
- sudo apt purge nodejs



==========================================================================
Datatables w/ react
https://www.youtube.com/watch?v=ZCKj0SJRTB8&ab_channel=GaurAssociates
https://medium.com/@zbzzn/integrating-react-and-datatables-not-as-hard-as-advertised-f3364f395dfa


==========================================================================
Routing
https://www.youtube.com/watch?v=6kCTFXUEnJ0&ab_channel=StudytonightwithAbhishek
https://www.geeksforgeeks.org/how-to-redirect-to-another-page-in-reactjs/
https://stackblitz.com/github/remix-run/react-router/tree/main/examples/basic?file=src%2FApp.tsx


==========================================================================
PACKAGES
npm i bootstrap                               
npm install primereact                  -       https://github.com/primefaces/primereact
npm i react-data-table-component        -       https://react-data-table-component.netlify.app/?path=/docs/getting-started-installation--docs
npm i react-router-dom                  -       https://www.npmjs.com/package/react-router-dom


Router
npm i axios                             -       https://www.npmjs.com/package/axios
                                        -       Axios/Fetch configuration pro & con
                                                https://blog.logrocket.com/axios-vs-fetch-best-http-requests/




