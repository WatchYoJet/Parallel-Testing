<h1 align="center"> Parallel Testing </h1>

<h4 align="center"> 
	Under construction...
</h4> 

<hr>

<p align="center">
  <a href="#requirements">Requirements</a> &#xa0; | &#xa0;
  <a href="#starting">Starting</a> &#xa0; | &#xa0;
  <a href="#configuration">Configuration</a> &#xa0; | &#xa0;
  <a href="#usage">Usage</a> &#xa0; | &#xa0;
  <a href="#known-bugs">Known Bugs</a> &#xa0; | &#xa0;
  <a href="#license">License</a> &#xa0;
</p>

<br>


## Requirements ##
-> [Git](https://git-scm.com)\
-> [GNU-Parallel](https://www.gnu.org/software/parallel/)

## Starting ##

```bash
# Install dependencies
$ sudo apt update
$ sudo apt install parallel

# Clone this project
$ git clone https://github.com/WatchYoJet/Parallel-Testing.git
...
```

After this, you need to set-up the <a href="#configuration">configuration</a> &#xa0;

## Configuration ##

```bash
$ vim config.default #You can also use code instead of vim to make it easy
```
This is an example of a configuration for a WSL machine:
```bash
PROJECT_PATH=/mnt/c/Users/pedro/Downloads #The path for your project files
EXE_NAME=CompiledProject #This is the name of the binary that you want 
FILE_NAME= #Optional, this is for specific projects, I'm working on it
PROCESSOR=1 #Faster means less stable
```
The `PROCESSOR` variable ranges from 1 to:
```bash
$ nproc
```

## Usage ##

You can run the following commands:

```bash
#Compiles the program on your path
$ make
#Compiles and runs your program so you dont have to leave the directory
$ make run 
#Prints all the commands (Still working on it)
$ make h
#Runs the Testing with the "Valgrind" option (Still working on it)
$ make v
#Runs the Testing with the "Lizard" option (Still working on it)
$ make l #To use this, you need to install Lizard
#Runs the Testing
$ make testing
#Cleans the binary, .myout files and .diff files 
$ make clean
```
## Known Bugs ##

-> `make v`- Not running with Valgrind\
-> `make l`- Not running with Lizard (even if it checks for installation)

## License ##

This project is under license from MIT. For more details, see the [LICENSE](LICENSE) file.

<a href="#top">Back to top</a>
