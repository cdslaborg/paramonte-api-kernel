<div align="center">

<a href="https://cdslaborg.github.io/paramonte-kernel-doc/html/" target="_blank">
    <img alt="paramonte-kernel-doc" src="https://cdslaborg.github.io/paramonte-kernel-doc/html/logo.png" width="80%">
</a>

The ParaMonte Kernel API Documentation
======================================

This project contains the [Application Programming Interface documentation](https://cdslaborg.github.io/paramonte-kernel-doc/html/) of the [ParaMonte kernel library](https://github.com/cdslaborg/paramonte).  
For full documentation visit the [ParaMonte library's documentation website](https://www.cdslab.org/paramonte/).  

</div>

### Instructions to regenerate the documentation  

+   Install [Doxygen](https://www.doxygen.nl/download.html) on your system.  
+   To regenerate the ParaMonte documentation from source,  
    +   Create a fork of the [ParaMonte project](https://github.com/cdslaborg/paramonte/)
        on your personal GitHub account and clone the forked ParaMonte repository on your system.  
    +   Create a fork of the [ParaMonte kernel documentation project](https://github.com/cdslaborg/paramonte-kernel-doc/) on your personal
        GitHub account and clone it inside the [src folder](https://github.com/cdslaborg/paramonte/tree/main/src) of the ParaMonte repository.  
    +   When cloning is done, you should see a new subfolder `/paramonte-kernel-doc` in the `/src` folder of your local copy of ParaMonte Project.  
    +   Make any adjustments/updates as needed to the source of the documentation in the source files in `/src/kernel` subfolder.  
    +   Open a Bash terminal inside `/src/paramonte-kernel-doc` and checkout the `gh-pages` branch of the documentation project,  
        ```bash
        git checkout gh-pages
        ```  
    +   Rebuild the new `ParaMonte::Kernel` documentation by calling the following script on the Bash command-line,  
        ```bash
        ./build.sh
        ```  
    +   Inspect the message log of Doxygen printed in the Bash terminal for any potential documentation errors.
    +   Inspect the generated documentation by navigating to the `/src/paramonte-kernel-doc/html` folder and
        opening the `index.html` via a web browser. Make sure all new changes look fine in the browser.
    +   If everything looks good, then stage, commit, and push the new documentation to your fork of
        the `ParaMonte::Kernel` documentation repository on GitHub.  
        ```bash
        git add --all
        git commit -m"latest documentation build"
        git push --all
        ```  
    +   Open a pull request (PR) on the [ParaMonte documentation repository](https://github.com/cdslaborg/paramonte-kernel-doc/pulls)
        to merge your new changes with the repository.  

+   To generate new header, footer, or css stylesheet, 
    follow the [Doxygen instructions here](https://www.doxygen.nl/manual/config.html#cfg_html_header). 
    The regeneration command is the following:  
    ```bash
    doxygen -w html new_header.html new_footer.html new_stylesheet.css config.txt
    ```  
