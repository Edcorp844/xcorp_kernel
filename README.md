# xcorp_kernel
This is an open source hybrid kernel that was created by Frost Edson under the bachelors degree research in kampala International university in Uganda in 2023. It remains open source unitl further notice..Feel free to use it fro research work and study purposes.

clone the project with this command.
``` $ git clone "https://github.com/Edcorp844/xcorp_kernel.git" ```

Go into the project directory.
```$ cd xcorp_kernel```

Give execute file permisions to the shell scripts that will help install tools, run and debug with the fololowing command.
```$ chmod +x debug.sh fat.sh run.sh tools.sh``` 

Run tools to install the tools necessary to build the projects.
```$ ./tools.sh```
This will install the tools.
# NOTE: This was developed on ubuntu so the comands in the file might need to be editted if you're using another platform with a different package manager.

Run make to build the projects.
This assumes you already have gcc or clang installed
```$ make```

You can then run the kernel with `$ ./run.sh` command
