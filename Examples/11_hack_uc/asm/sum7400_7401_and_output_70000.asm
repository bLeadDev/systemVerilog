// Add the inputs IREG0+IREG1 and output to OREG0
(LOOP)  //Infinite loop
@29696  //A=0x7400
D=M     //D=M(0x7400) --> IREG0
@29697  //A=0x7401 --> IREG1
D=D+M   //Add IREG0x7400 + IREG0x7401
@28672  //A=0x7000 --> OREG0
M=D     //Put the result to OREG0
@LOOP
0;JMP