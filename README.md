# FPGA-Handwritten-Digit-Recognition

This project implements an FPGA-based handwritten digit recognition system by using three peripherals: Bluetooth, MP3 and VGA display for communication interaction, as well as a simple convolutional neural network implemented in Verilog.

This project is digital logic course design. Because of the limited course knowledge, this project has some potential problems that most people may not notice during the reproduction. If you directly use the files given in this project, you may have the following two problems:
1. Due to limited resources on the FPGA board, you cannot successfully synthesize.
2. Your system can pass the pre-simulation, but the results may not be as expected during the post-simulation stage.

For the first one above, the solution is to restrict the use of some types of computing units through vivado's OOC compilation mode. 
For the second, you can solve it by adding timing constraints or dividing the original clock. 

The specific reasons for these problems may not be fully understood until you take a computer organization course. If you have any questions during the reproduction or improvement process, please contact me.


