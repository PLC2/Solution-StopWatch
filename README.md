# StopWatch

This is the project solution used in PLC2's 5-days class [**Professional VHDL**](https://www.plc2.com/en/training/detail/professional-vhdl).
It develops step by step a stop watch running on a **Digilent Nexys4 DDR** board
(new name *Nexys A7*).

[![Digilent NexysA7][Nexys4DDR]][Nexys4DDR]  
Source: [Digilent](digilentinc.com)



## Requirements

### Hardware
* Digilent Nexys4 DDR / Nexys A7 board
* Micro-USB cable

### Software
* Vivado 2021.2 or later (released Oct. 2021)



## User Interface

### Buttons

| Button                     | Function     |
| -------------------------- | ------------ |
| Button reset (`CPU RESET`) | reset        |
| Button up (`BTNU`)         | start / stop |
| Button left (`BTNL`)       | unused       |
| Button center (`BTNC`)     | unused       |
| Button right (`BTNR`)      | unused       |
| Button down (`BTND`)       | unused       |

### 7-Segment Display

| 7 (left most) | 6          | 5          | 4          | 3          | 2          | 1          | 0 (right most) |
| :-----------: | :--------: | :--------: | :--------: | :--------: | :--------: | :--------: | :------------: |
| unused        | unused     | 10 min     | 1 min      | 10 sec     | 1 sec      | 1/10 sec   | 1/100 sec      |


## Project Structure

The Vivado project file contains a multi-project setup. There are 3 top-level
designs using 3 synthesis runs und 3 implementation runs. Of cause, 3 constraint
sets have been defined too.

[![Multi-project setup][MultiProjectSetup]][MultiProjectSetup]

| Design Hierarchy                                      | Constraint Sets                                      | Testbenches                                |
| ----------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------ |
| [![Design Hierarchy][DesignHierachy]][DesignHierachy] | [![Constraint Sets][ConstraintSets]][ConstraintSets] | [![Testbenches][Testbenches]][Testbenches] |


# License

Licensed under [MIT License](LICENSE.md).

---------------
SPDX-License-Identifier: MIT


[Nexys4DDR]: doc/images/Digilent-NexysA7.jpg
[MultiProjectSetup]: doc/images/MultiProject.png
[DesignHierachy]: doc/images/Hierarchy.png
[ConstraintSets]: doc/images/ConstraintFiles.png
[Testbenches]: doc/images/Testbenches.png
