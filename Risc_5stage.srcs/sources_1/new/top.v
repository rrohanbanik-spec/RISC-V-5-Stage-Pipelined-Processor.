`timescale 1ns / 1ps

module top(
    input clk, reset
);

// ==========================================================================
// WIRE DECLARATIONS (THE INTERNAL BUSES)
// ==========================================================================

// --- FETCH (IF) WIRES ---
wire [31:0] IF_pc_current, IF_pc_next, IF_pc_plus4, IF_instr;
wire PCWrite; 

// --- DECODE (ID) WIRES ---
wire [31:0] ID_pc_plus4, ID_instr;
wire [31:0] ID_rd1, ID_rd2, ID_imm;
wire [4:0] ID_rs1, ID_rs2, ID_rd;
wire ID_RegWrite, ID_MemtoReg, ID_MemWrite, ID_MemRead, ID_Branch, ID_ALUSrc;
wire [1:0] ID_ALUOp;
wire IF_ID_Write, Control_Mux_Sel; 

// --- EXECUTE (EX) WIRES ---
wire [31:0] EX_pc_plus4, EX_rd1, EX_rd2, EX_imm, EX_alu_result, EX_target;
wire [4:0] EX_rs1, EX_rs2, EX_rd;
wire [2:0] EX_funct3;
wire EX_funct7, EX_zero, EX_RegWrite, EX_MemtoReg, EX_MemWrite, EX_MemRead, EX_Branch, EX_ALUSrc;
wire [1:0] EX_ALUOp;
wire [3:0] EX_ALU_Control;
wire [1:0] ForwardA, ForwardB; 
wire [31:0] EX_muxA_out, EX_muxB_out; 

// --- MEMORY (MEM) WIRES ---
wire [31:0] MEM_target, MEM_alu_result, MEM_rd2, MEM_mem_data;
wire [4:0] MEM_rd;
wire MEM_RegWrite, MEM_MemtoReg, MEM_MemWrite, MEM_MemRead, MEM_Branch, MEM_zero;
wire PCSrc; 

// --- WRITEBACK (WB) WIRES ---
wire [31:0] WB_alu_result, WB_mem_data, WB_final_data;
wire [4:0] WB_rd;
wire WB_RegWrite, WB_MemtoReg;


// ==========================================================================
// PHASE 1 - INSTRUCTION FETCH (IF) STAGE
// ==========================================================================

Program_Counter pc_unit(
    .clk(clk), 
    .reset(reset), 
    .en(PCWrite), 
    .pc_next(IF_pc_next), 
    .pc_out(IF_pc_current)
);

Instruction_Mem imem(
    .addr(IF_pc_current), 
    .instr(IF_instr)
);

PCplus4 pc4(
    .from_pc(IF_pc_current), 
    .plus4_out(IF_pc_plus4)
);

mux pc_mux(
    .a(IF_pc_plus4), 
    .b(MEM_target), 
    .sel(PCSrc), 
    .y(IF_pc_next)
);

IF_ID_Reg if_id(
    .clk(clk), 
    .reset(reset || PCSrc), 
    .en(IF_ID_Write),       
    .PC_plus4_in(IF_pc_plus4), 
    .instruction_in(IF_instr),
    .PC_plus4_out(ID_pc_plus4), 
    .instruction_out(ID_instr)
);


// ==========================================================================
// PHASE 2 - INSTRUCTION DECODE (ID) STAGE
// ==========================================================================

assign ID_rs1 = ID_instr[19:15];
assign ID_rs2 = ID_instr[24:20];
assign ID_rd  = ID_instr[11:7];

Hazard_Detection_Unit hazard_unit (
    .IF_ID_Rs1(ID_rs1),
    .IF_ID_Rs2(ID_rs2),
    .ID_EX_Rd(EX_rd),
    .ID_EX_MemRead(EX_MemRead),
    .PCWrite(PCWrite),
    .IF_ID_Write(IF_ID_Write),
    .Control_Mux_Sel(Control_Mux_Sel)
);

Control_Unit control (
    .opcode(ID_instr[6:0]),
    .RegWrite(ID_RegWrite),
    .MemtoReg(ID_MemtoReg),
    .MemWrite(ID_MemWrite),
    .MemRead(ID_MemRead),
    .Branch(ID_Branch),
    .ALUSrc(ID_ALUSrc),
    .ALUOp(ID_ALUOp)
);

wire mux_RegWrite = Control_Mux_Sel ? 1'b0 : ID_RegWrite;
wire mux_MemtoReg = Control_Mux_Sel ? 1'b0 : ID_MemtoReg;
wire mux_MemWrite = Control_Mux_Sel ? 1'b0 : ID_MemWrite;
wire mux_MemRead  = Control_Mux_Sel ? 1'b0 : ID_MemRead;
wire mux_Branch   = Control_Mux_Sel ? 1'b0 : ID_Branch;
wire mux_ALUSrc   = Control_Mux_Sel ? 1'b0 : ID_ALUSrc;
wire [1:0] mux_ALUOp = Control_Mux_Sel ? 2'b00 : ID_ALUOp;

Reg_File register_file (
    .clk(clk),
    .reset(reset),
    .rg_rd_en1(1'b1), 
    .rg_rd_en2(1'b1),
    .rg_rd_addr1(ID_rs1),
    .rg_rd_addr2(ID_rs2),
    .rg_wrt_en(WB_RegWrite),      
    .rg_wrt_addr(WB_rd),          
    .rg_wrt_data(WB_final_data),  
    .rg_rd_data1(ID_rd1),
    .rg_rd_data2(ID_rd2)
);

ImmGen imm_generator (
    .instruction(ID_instr),
    .imm_ext(ID_imm)
);

ID_EX_Reg id_ex (
    .clk(clk),
    .reset(reset),
    
    .RegWrite_in(mux_RegWrite), 
    .MemtoReg_in(mux_MemtoReg), 
    .MemWrite_in(mux_MemWrite), 
    .MemRead_in(mux_MemRead), 
    .Branch_in(mux_Branch), 
    .ALUSrc_in(mux_ALUSrc),
    .ALUOp_in(mux_ALUOp),
    
    .PC_plus4_in(ID_pc_plus4), 
    .Rd1_in(ID_rd1), 
    .Rd2_in(ID_rd2), 
    .ImmExt_in(ID_imm),
    .funct3_in(ID_instr[14:12]),
    .funct7_in(ID_instr[30]),
    .Rs1_in(ID_rs1), 
    .Rs2_in(ID_rs2), 
    .Rd_in(ID_rd),

    .RegWrite_out(EX_RegWrite), 
    .MemtoReg_out(EX_MemtoReg), 
    .MemWrite_out(EX_MemWrite), 
    .MemRead_out(EX_MemRead), 
    .Branch_out(EX_Branch), 
    .ALUSrc_out(EX_ALUSrc),
    .ALUOp_out(EX_ALUOp),
    
    .PC_plus4_out(EX_pc_plus4), 
    .Rd1_out(EX_rd1), 
    .Rd2_out(EX_rd2), 
    .ImmExt_out(EX_imm),
    .funct3_out(EX_funct3),
    .funct7_out(EX_funct7),
    .Rs1_out(EX_rs1), 
    .Rs2_out(EX_rs2), 
    .Rd_out(EX_rd)
);


// ==========================================================================
// PHASE 3 - EXECUTE (EX) STAGE
// ==========================================================================

Forwarding_Unit forward_unit (
    .ID_EX_Rs1(EX_rs1),
    .ID_EX_Rs2(EX_rs2),
    .EX_MEM_Rd(MEM_rd),
    .MEM_WB_Rd(WB_rd),
    .EX_MEM_RegWrite(MEM_RegWrite),
    .MEM_WB_RegWrite(WB_RegWrite),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

assign EX_muxA_out = (ForwardA == 2'b10) ? MEM_alu_result :
                     (ForwardA == 2'b01) ? WB_final_data  :
                                           EX_rd1;

assign EX_muxB_out = (ForwardB == 2'b10) ? MEM_alu_result :
                     (ForwardB == 2'b01) ? WB_final_data  :
                                           EX_rd2;

wire [31:0] EX_alu_operand2 = EX_ALUSrc ? EX_imm : EX_muxB_out;

ALU_Control alu_ctrl (
    .ALUOp(EX_ALUOp),
    .funct3(EX_funct3),
    .funct7(EX_funct7),
    .ALU_Selection(EX_ALU_Control)
);

ALU_unit alu (
    .a(EX_muxA_out),
    .b(EX_alu_operand2),
    .alu_control(EX_ALU_Control),
    .result(EX_alu_result),
    .zero(EX_zero)
);

assign EX_target = EX_pc_plus4 + EX_imm;

EX_MEM_Reg ex_mem (
    .clk(clk),
    .reset(reset),
    
    .RegWrite_in(EX_RegWrite),
    .MemtoReg_in(EX_MemtoReg),
    .MemWrite_in(EX_MemWrite),
    .MemRead_in(EX_MemRead),
    .Branch_in(EX_Branch),
    
    .Zero_in(EX_zero),
    .Reg_target_in(EX_target),
    .ALU_result_in(EX_alu_result),
    .Rd2_in(EX_muxB_out), 
    .Rd_in(EX_rd),

    .RegWrite_out(MEM_RegWrite),
    .MemtoReg_out(MEM_MemtoReg),
    .MemWrite_out(MEM_MemWrite),
    .MemRead_out(MEM_MemRead),
    .Branch_out(MEM_Branch),
    
    .Zero_out(MEM_zero),
    .Reg_target_out(MEM_target),
    .ALU_result_out(MEM_alu_result),
    .Rd2_out(MEM_rd2),
    .Rd_out(MEM_rd)
);


// ==========================================================================
// PHASE 4 - MEMORY (MEM) STAGE
// ==========================================================================

assign PCSrc = MEM_Branch && MEM_zero;

Data_Memory data_mem (
    .clk(clk),
    .reset(reset),
    .mem_access_en(MEM_MemRead || MEM_MemWrite),
    .mem_wrt_en(MEM_MemWrite),
    .mem_addr(MEM_alu_result),
    .mem_wrt_data(MEM_rd2),
    .mem_rd_data(MEM_mem_data)
);

MEM_WB_Reg mem_wb (
    .clk(clk),
    .reset(reset),
    
    .RegWrite_in(MEM_RegWrite),
    .MemtoReg_in(MEM_MemtoReg),
    
    .ALU_result_in(MEM_alu_result),
    .Data_Memory_read_data_in(MEM_mem_data),
    .Rd_in(MEM_rd),

    .RegWrite_out(WB_RegWrite),
    .MemtoReg_out(WB_MemtoReg),
    
    .ALU_result_out(WB_alu_result),
    .Data_Memory_read_data_out(WB_mem_data),
    .Rd_out(WB_rd)
);


// ==========================================================================
// PHASE 5 - WRITE-BACK (WB) STAGE
// ==========================================================================

assign WB_final_data = WB_MemtoReg ? WB_mem_data : WB_alu_result;

endmodule