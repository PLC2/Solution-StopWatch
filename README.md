# StopWatch

This is the project solution used in PLC2's 5-days class **Professional VHDL**.
It develops step by step a stop watch running on a **Digilent Nexys4 DDR** board
(new name *Nexys A7*).

[![Digilent NexysA7][Nexys4DDR]][Nexys4DDR]  
Source: [Digilent](digilentinc.com)

## Requirements

### Hardware
* Digilent Nexys4 DDR / Nexys A7 board
* Micro-USB cable

### Software
* Vivado 2019.2 or later (releases Nov. 2019)

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

| Digit                      | Value     |
| -------------------------- | ------------ |
| 1 (right most)             | 1/100 sec    |
| 2                          | 1/10 sec     |
| 3                          | 1 sec        |
| 4                          | 10 sec       |
| 5                          | 1 min        |
| 6                          | 10 min       |
| 7                          | unused       |
| 8 (left most)              | unused       |

## Project Structure

The Vivado project file contains a multi-project setup. There are 3 top-level
designs using 3 synthesis runs und 3 implementation runs. Of cause, 3 constraint
sets have been defined too.

[![Multi-project setup][MultiProjectSetup]][MultiProjectSetup]

### Design Hierarchy

[![Design Hierarchy][DesignHierachy]][DesignHierachy]

### Constraint Sets

[![Constraint Sets][ConstraintSets]][ConstraintSets]

### Testbenches

[![Testbenches][Testbenches]][Testbenches]

# License

MIT License


[Nexys4DDR]: doc/images/Digilent-NexysA7.jpg
[MultiProjectSetup]: doc/images/MultiProject.png
[DesignHierachy]: doc/images/Hierarchy.png
[ConstraintSets]: doc/images/ConstraintFiles.png
[Testbenches]: doc/images/Testbenches.png
