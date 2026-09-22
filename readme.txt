Please Implement the Submodules one by one, check with the screenshot given in the tb screenshot, and then initiate the modules to the top-level module. 

You may follow the Instruction - IP Core.pdf to learn instancing RAM and MMCM in Vivado 

You may refer to the Instruction - Design Steps.pdf to build the processor step-by-step 

The demoModule includes the demo code for submodules. 
> These codes are provided to help students who are not familiar with Verilog. If you are familiar with HDL, please feel free to design on your own. 
> The demo codes' port definition and structure are slightly different from the book and instruction. You do not need to follow the specific port or code structure design, feel free to realize the design in your own way 

tb including the test bench to verify your submodules and top level. 
> It is suggested to verify every module correctly before you integrate them on the top level (makes your debugging life much easier). 
> screenshot includes the “correct” simulation result to help your design verification. 

constrs contains the XDC file to define time (frequency) constraints for implementation. You only need it during the synthesis and implementation phases。
> period in time.xdc defines the clock cycle period in a nanosecond. 

├── ECE505 Project RISC-V Processor - Common Questions.pdf 
├── ECE505 Project RISC-V Processor - Instruction - Design Step.pdf 
├── ECE505 Project RISC-V Processor - Instruction - IP Cores.pdf 
├── README.pdf 
├── constrs 
│ └── time.xdc 
├── demoModule 
└── tb 
├── IP 
│ ├── tb_clkWizard.v 
│ └── tb_ram.v 
├── screenshot 
├── tb_ALU.v 
├── tb_alu_control.v 
├── tb_control_unit.v 
├── tb_imm_gen.v 
├── tb_reg_file.v 
├── tb_reg_rom.v 
└── tb_top.v 
