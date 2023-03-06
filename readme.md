# TrustZone for the Nucleo-L552ZE-Q in VS Code
This is a demonstration of starting the GTZC_TZSC_MPCBB_TrustZone example for the Nucleo-L552ZE-Q and importing it into VS Code. I'm going to show two ways to do this, an Easy Way and a Complete way. This repo contains the files for the Complete way.

While this is for a specific STM32 Sample, you can view this as two ways to approach getting a multiproject STM32 sample into VS Code. The Easy Way just imports the individual projects, then with minor modifications sets them up for build and debug. The Complete way creates a new CMake project for both of the STM32 projects converted for VS Code.

For the [Easy Way](#the-easy-way), follow the steps for generating the example in CubeMX, then skip to the end. 

The Complete way goes further and shows you how to modify these projects so that there is a top level CMake project that contains both. This requires more changes, but they aren't that involved. The benefit of this approach is that you can view the source code for both projects at once and easily set breakpoints anywhere in the source. 

Note that I am not using a VS Code workspace for this project. The reason is that while I could add each project subfolder to the workspace we still would miss seeing other files in the root. In addition to that a VS Code workspace is not vcpkg aware yet, so the build environment needed is not automatically configured.

This project is about how to get this example into VS Code, it doesn't cover much about what the application here does. Please see the [readme.txt](readme.txt) in the root of this project for that information. I short though, this sample is designed to fault. Basically the firmware on the nonsecure side blinks LED1 three times then accesses secure memory. This is an access violation so it triggers a fault on the secure side that calls back to a function on the nonsecure side that then turns on a red led on the board.

To use this just clone this repo and you can open in VS Code. Make sure you have completed the setup steps, then you can jump ahead to building the firmware.

```
git clone https://github.com/robotdad/GTZC_TZSC_MPCBB_TrustZone-Nucleo-L55.git
cd 
code .
```

# Setup
Have CubeMX, CubeIDE, and VS Code with Embedded Tools VS Code Extension installed.
Make sure you have updated your STLink firmware on your board.

I have included the steps for creating git repos and connecting them to GitHub below. If you are following along with those steps as well you need git and the GitHub cli installed.

# GTZC_TZSC_MPCBB_TrustZone example from CubeMX

In CubeMX go to example selector, search for the Nucleo-L552ZE-Q in the board name, find the GTZC_TZSC_MPCBB_TrustZone example, select it, and start project. This will prompt you for a location for the project, pick a location and open with CubeMX.

Go to the Project Manager tab, select STM32CubeIDE as the toolchain with Generate Under Root selected, now generate the code. Ignore the warnings that pop up.

One of the warnings is about generating under the root will corrupt other existing projects. That is because this is a sample that has preconfigured projects for STM32IDE, MDK, and IAR. Those project files are all generated under subfolders for each IDE, the source code for the applications are under other directories in the parent folder. While this is fine, were we to import the STM32 projects as initially configured in VS Code we would not be able to see the source code in the file explorer. Instead we would have to open the CMake view then we could see the source contributing to each project. So this is a better way to generate source when using VS Code at the expense of these other preconfigured projects.

I am starting the commit history for this repo from the initial project generation described above so you can examine all changes if you want to see what was done in detail.

Navigate to where you saved your generated project and setup a git repo.
```
git init -b main
git add . && git commit -m "initial commit"
gh repo create
```

Follow the prompts for creating the repo on GitHub. You will want to add a remote, defaults are fine.

## Configuring the board
There is a [readme.txt](readme.txt) in the root project folder that describes how to configure the board. You will need to have the STM32CubeProgrammer installed to configure the option bytes to enable TrustZone. Note that some of the option bytes are not visible until TrustZone is enabled. So start by launching STM32CubeProgrammer and connecting your board. You will find this by selecting OB in the menu for Option Bytes. TZEN is under the User Configuration section. Set TZEN=1 by selecting the checkbox. Make sure DBANK=1 with that checkbox selected as well. Now press Apply. After the option bytes are set you will see some new categories.

Under Secure Area 1, set SECWM1_PSTRT value = 0x0  and SECWM1_PEND value = 0x7F meaning all 128 pages of Bank1 set as secure.

Under Secure Area 2, set SECWM2_PSTRT value = 0x1 and SECWM2_PEND value = 0x0 meaning no page of Bank2 set as secure, hence Bank2 non-secure.

Now press Apply. Disconnect the board in STM32Programmer.

Now you are ready to flash the firmware to the board and debug.

# The Complete Way with CMake and VS Code
At the end of these steps we will have a CMake project in the root of the generated example folder that can build both Secure and NonSecure projects.

## Delete unused project folders
From the above explanation there are some project folders within our tree that will not work. Remove the following directories from the root of the generated project.
* EWARM
* MDK-ARM
* STM32CubeIDE

## Project structure
Looking at what we have now you will see there is a .project file that is used by STM32IDE for the solution. VS Code does not have a way to import that file. Instead we need to import the individual projects here that are under the NonSecure folder.

## Import the NonSecure ST Project
Open VS Code, in the command palette (Ctrl + Shift + P) use Create project from ST Project. This will launch the file browser, navigate to the root of this generated project, then into the NonSecure folder, and select the .cproject. If prompted to trust the authors, agree. You will be prompted to choose a configuration, select debug.

The result of the above actions is that a CMake project will be generated, default tasks will be created for the project for use in VS Code and VS, and a vcpkg-configuration file will be created and activated. The vcpkg step configures the environment so that CMake, Ninja, and the ST compilers from the STM32IDE are all on path and ready to use.

However, the .cproject for the NonSecure project also refers to the Secure project in the parent folder. As a result the same conversion steps above have been applied to the Secure project. You can't see this as we are only in the NonSecure project right now.

## Open the root project folder
Close the NonSecure folder in VS Code, then open the parent folder where the example was generated. You may get some prompts to select CMake files from subfolders, disregard that for now while we set things up.

You should now create a .gitignore file. Minimally make sure to exclude the build folder by adding the line "build/" to the file. You can also copy a [complete .gitignore from here](https://raw.githubusercontent.com/robotdad/GTZC_TZSC_MPCBB_TrustZone-Nucleo-L55/main/.gitignore). When done commit the file. 

Now the only changes listed in the git sidebar should be the generated artifacts from the import and the workspace file you created. 

## Modify the NonSecure toolchain file
Notice files were generated for both the NonSecure and Secure projects even though we only imported the NonSecure one. This is because the NonSecure STM32IDE project was configured to build the Secure one as well. Some of the artifacts from the secure build are used in the NonSecure project at link time. 

As we are configuring our own parent CMake project we want to trigger the Secure project build from there, not a subproject. The reason why is that as generated the build files will be under the project folders, but with a parent CMake project we want the build artifacts there at a common level. It makes things much easier to reason about and reference when needed.

Expand the subfolder NonSecure/cmake and open st-project.cmake. Delete the first three functions that build the Secure project. Now find the function target_link_options around line 60. Remove "\\Secure" from the final two lines there. With our modifications that file will be generated under the build directory from the root of the project.

## Create the root CMake Project
To configure our CMake project at the root we can start by copying some of the generated artifacts to the root. Copy the following folder and files from either the NonSecure or Secure project to the parent folder
* .vs
* .vscode
* cmake
    * delete the st-project.cmake file, that is only used from the projects in the subfolders.
* CMakePresets.json
* vcpkg-configuration.json

Now create a CMakeLists.txt in the root with the following content.
```
cmake_minimum_required(VERSION 3.20)

project("GTZC_TZSC_MPCBB_TrustZone-Nucleo-L55" C CXX ASM)

add_subdirectory(Secure)
add_subdirectory(NonSecure)
```

Note that it is important that the Secure project is built first, the NonSecure one depends on artifacts from the Secure one. Close the folder now so our changes can be picked up when reopening it.

## Building the firmware
Open the root project folder in VS Code now that the above changes have been made.

Select the root CMakeLists.txt file in the file explorer and from the context menu select Clean Reconfigure All Projects. This ensures we have generated the build files using the proper compilers that are now on the path. From the context menu for CMakeLists.txt you can now select Build All Projects. This should build your firmware under the build directory. 

## Debugging

### Configure launch.json
Select the debug icon in the Activity bar. Now select the gear icon to configure it.

Note that the miDebuggerPath and debugServerPath are configured using environment variables provided by the Embedded Tools extension that use ST's gdb and gdbserver executables provided by STM32IDE.

As this example has two pieces of firmware, one running in secure and one running non-secure, we need to load both onto the device. If you look at the postRemoteCommands section that is where the gdb commands are specified for loading the firmware. Modify this section as follows:
```
        {
          "text": "load build/debug/build/NonSecure/GTZC_TZSC_MPCBB_TrustZone_NonSecure.elf"
        },
        {
          "text": "load build/debug/build/Secure/GTZC_TZSC_MPCBB_TrustZone_Secure.elf"
        },
        {
          "text": "add-symbol-file build/debug/build/NonSecure/GTZC_TZSC_MPCBB_TrustZone_NonSecure.elf"
        }
```
What this is doing is telling the debugger to load the secure and nonsecure firmware to the device. We also need to load the symbols for the NonSecure project explicitly as we need to set the launch target to be the Secure project. You can specify that with the program option explicitly, or at launch select the Secure target. I've chosen to explicitly reference it as it is the only selection that makes sense for this project.

### Set breakpoints and launch
In the NonSecure project open Src/main.c. Set a breakpoint on the first HAL_GPIO_TogglePin in the main function. In the Secure project open Src/main.c and set a breakpoint on Hal_Init in the main function.

Now go back to the debug pane and select to run the Launch (NonSecure) option.

One initial launch you should see a break in the Reset_Handler of the secure firmware as we have stopAtConnect set to True. You can set that to false to not break there. 

Select continue in the debug toolbar. We'll now hit the breakpoint in the secure main on the Hal_Init. There isn't much to look at here, it basically initializes the board then starts the nonsecure firmware. Press continue to get to the next breakpoint.

### Examine peripheral registers
When you hit a break point at HAL_GPIO_TogglePin open the peripheral view from the command palette, select Focus on peripheral view. Expand the view that opens in the debug pane. Now, to understand what is being used on the hardware right select LED1_GPIO_Port and select Peek, Peek Definition. You will see this is GPIOC.  Do the same thing for LED1_Pin, or select Alt F12, and notice it is GPIO Pin 7.

Find the GPIOC section in the peripheral view. The pins are under the ODR section. You can step over the HAL_GPIO_TogglePin call and either watch the value for ODR change, or expand it to see the specific pin value update.

### Seeing the TrustZone fault
This sample is designed to fault. Basically the firmware on the nonsecure side blinks LED1 three times then accesses secure memory. This is an access violation so it triggers a fault.

If you look at the beginning of main in the NonSecure firmware you will see the functions registered to be called from the secure side if a fault is detected. You can go to definition of SecureFault_Callback and see that it calls Error_Handler. You can set a breakpoint here.

In the secure project you can find SecureFault_Handler, press Ctrl+T and enter that, select the definition in Secure\src\stm32l5xx_it.c. This function gets called on the fault on the secure side and has a pointer back to the function on the NonSecure side. Place a breakpoint on the if statement.

Let the application run. You should hit the breakpoint on the secure side. Let it run from there and then you will hit the break on the nonSecure side. You can step here into the error handler where the red led is turned on. The program is done at this point.

## Optional Cleanup
The changes made to the converted projects are extensive enough they cannot be opened as individual projects anymore. You should always open the root folder of this project now. As such some of the generated files aren't needed anymore. They don't have to be removed, but it helps make things clearer if you do.

Delete these folders and files under the NonSecure and Secure projects.
* .vs/
* .vscode/
* build/
* CMakePresets.json
* vcpkg-configuration.json
* cmake/gcc-arm-none-eabi.cmake

# The Easy Way
Please note that these steps are only if you generated the example as described above yourself. These steps will not work with this repo.

In the Easy Way the result is you can start debugging from either the NonSecure or Secure project, but you have to open each in their own VS Code instance. It requires some minor changes to the launch.config as running the example requires output from both projects. It has the limitation that you can only set breakpoints in source for the project you launched from. While debugging you can set breakpoints on functions from the other project.

The primary benefit to this approach is you can get a STM32 sample into VS Code more quickly. You may only want to use the Complete way above if you are planning to use it as a basis for your own project.

## Import the NonSecure ST Project
Open VS Code, in the command palette (Ctrl + Shift + P) use Create project from ST Project. This will launch the file browser, navigate to the root of this generated project, then into the NonSecure folder, and select the .cproject. If prompted to trust the authors, agree. You will be prompted to choose a configuration, select debug.

The result of the above actions is that a CMake project will be generated, default tasks will be created for the project for use in VS Code and VS, and a vcpkg-configuration file will be created and activated. The vcpkg step configures the environment so that CMake, Ninja, and the ST compilers from the STM32IDE are all on path and ready to use.

However, the .cproject for the NonSecure project also refers to the Secure project in the parent folder. As a result the same conversion steps above have been applied to the Secure project. You can't see this as we are only in the NonSecure project right now.

## Build the project
Select the  CMakeLists.txt file in the file explorer and from the context menu select Clean Reconfigure All Projects. This ensures we have generated the build files using the proper compilers that are now on the path. From the context menu for CMakeLists.txt you can now select Build All Projects. This should build your firmware under the build directory. It has also built the binaries in the Secure project under the parent of this project folder.

## Debugging
There are some limitations with this approach, most notably that you are referencing files outside of your current project that you need to make sure are built. You also cannot set breakpoints in source files of the project you don't have open. During debugging you can set function breakpoints on the other project as it is loaded on the device under debug.

### Configure launch.json
Select the debug icon in the Activity bar. Now select the gear icon to configure it.

Note that the miDebuggerPath and debugServerPath are configured using environment variables provided by the Embedded Tools extension that use ST's gdb and gdbserver executables provided by STM32IDE.

Change the program paramater to point to the firmware from the Secure project as that is the entry point and is responsible for loading the NonSecure project.
```
"program": "../Secure/build/debug/build/GTZC_TZSC_MPCBB_TrustZone_Secure.elf",
```

As this example has two pieces of firmware, one running in secure and one running non-secure, we need to load both onto the device. If you look at the postRemoteCommands section that is where the gdb commands are specified for loading the firmware. We also need to add symbols explicitly for the firmware that is not loaded with the program argument. Modify this section as follows:
```
        {
          "text": "load build/debug/build/GTZC_TZSC_MPCBB_TrustZone_NonSecure.elf"
        },
        {
          "text": "load ../Secure/build/debug/build/GTZC_TZSC_MPCBB_TrustZone_Secure.elf"
        },
        {
          "text": "add-symbol-file build/debug/build/GTZC_TZSC_MPCBB_TrustZone_NonSecure.elf"
        }
```
What this is doing is telling the debugger to load the secure and nonsecure firmware to the device. We also need to load the symbols for the NonSecure project explicitly as we need to set the launch target to be the Secure project. You can specify that with the program option explicitly, or at launch select the Secure target. I've chosen to explicitly reference it as it is the only selection that makes sense for this project.

## Using the Secure project
Adjust the steps above to launch from the Secure project. Note that the Secure project does not build the NonSecure project.