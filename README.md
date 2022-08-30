# DDR-FPGA
Dance Dance Revolution FPGA implimentation


# Description
This project was solely intented to run on the Digilent Basys-3 dev board with Vivado software. 

The main file is ddr_main.v, all other files contains modules used. ddr_nes.v is modified from https://github.com/jconenna/Yoshis-Nightmare. ddr_cons.xdc is the constraints folder used for the Basys-3 dev board. 


# How To Use
The game will automatically start once the Basys3 is programmed. The LEDs will light up from right to left, traveling in a line one at a time at a set speed. The rightmost 7-segment display will have one side (up, down, right, left) lit up to show the next direction, while the two leftmost 7-segment displays will show the player score. With VGA plugged in (optional), a directional arrow will be displayed (up, down, right, left), and a blue square will appear at a set interval.


The goal is to press the correct direction on the controller d-pad as shown on the displays, at the same time as when the left-most LED is lit and the blue square appears on the screen. Doing it at the correct time will result in the score incrementing by one. The max score is 99, and it will reset to 00 once it hits 100. The blue square appears slightly before the actual input time in order to account for human reaction time (since you don’t have the traveling LED’s to show the speed visually).


There are 4 different difficulties based on the 2 rightmost switches, set to 0-3. 0 has about 1 second between each move, 1 has 0.75s, 2 is 0.5s, and 3 is 0.25s. There is a bug where the clocks can go out of sync when going from a higher difficulty to a lower difficulty, but we did not have time to implement a proper fix. A temporary fix is to set the difficulty and then reprogram the Basys3, which will start with the difficulty to whatever is currently set.
