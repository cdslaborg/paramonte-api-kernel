<div align="center">

<a href="https://cdslaborg.github.io/paramonte-kernel-doc/html/" target="_blank">
    <img alt="paramonte-kernel-doc" src="https://cdslaborg.github.io/paramonte-kernel-doc/html/logo.png" width="80%">
</a>

<h1>
    The ParaMonte Kernel API Documentation
</h1>

> **This repository is now archived permanently and will not be updated**.  
> All ParaMonte library documentation source files are now located in the new [paramonted](https://github.com/cdslaborg/paramonted) repository.

This project contains the 
<a href="https://cdslaborg.github.io/paramonte-kernel-doc/html/" target="_blank">
    Application Programming Interface documentation
</a>
of the 
<a href="https://github.com/cdslaborg/paramonte" target="_blank">
    ParaMonte kernel library
</a>
.
<br>
For full documentation visit the
<a href="https://www.cdslab.org/paramonte/" target="_blank">
    ParaMonte library's documentation website
</a>
.

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
    +   Open a Bash terminal inside `/src/paramonte-kernel-doc` and make sure you are on the `main` branch of the documentation project,  
    +   Rebuild the new `ParaMonte::Kernel` documentation by calling the following script on the Bash command-line,  
        ```bash
        ./build.sh
        ```  
    +   Inspect the message warning log of Doxygen in the output file `READ_THESE_BUILD_WARNINGS.txt` for any potential documentation errors.
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
