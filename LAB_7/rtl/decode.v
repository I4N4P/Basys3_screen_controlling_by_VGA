module decode (
    input  wire [3:0] OPcode,
    input  wire       en,
    
    /* [0] - update Carry and Overflow flags; 
     * [1] - update Neg and  Zero flags;
     *  ADD, SUB - update all flags; 
     * AND, OR - update only Neg and Zero
     *  */
    output reg  [1:0] UpdateFlags,
     
    output reg  [1:0] ALUControl,
    output reg  [1:0] RegFileControl
);

//------------------------------------------------------------------------------
// put your code here
localparam 
ADD = 3'b000, // add two registers
SUB = 3'b001, // branch if input 0 is true
AND = 3'b010, // branch if input 1 is true
OR  = 3'b011, // branch any; if either of inputs is true
LDA = 3'b100,
LDB = 3'b101,
NOP = 3'b111 // always branch
;

always @*
    if(!en)
        UpdateFlags = 2'b00;
    else
        if(OPcode[3]) // branch
            UpdateFlags = 2'b00;
        else begin    // execute
            case(OPcode[2:0])
                AND, OR:  UpdateFlags = 2'b10;
                ADD, SUB: UpdateFlags = 2'b11;
                NOP:      UpdateFlags = 2'b00;
                default:  UpdateFlags = 2'b00;
            endcase
        end

always @*
    if(!en)
        ALUControl = 2'b00;
    else
        if(OPcode[3]) // branch
            ALUControl = 2'b00;
        else begin    // execute
            case(OPcode[2:0])
                ADD:  ALUControl = 2'b00;
                SUB:  ALUControl = 2'b01;
                AND:  ALUControl = 2'b10;
                OR :  ALUControl = 2'b11;
                default:  ALUControl = 2'b00;
            endcase
        end



//------------------------------------------------------------------------------
always @*
    if(!en)
        RegFileControl = 2'b00;
    else
        if(OPcode[3]) // branch
            RegFileControl = 2'b00;
        else begin    // execute
            case(OPcode[2:0])
                ADD, SUB, AND, OR: RegFileControl = 2'b01;
                LDA: RegFileControl               = 2'b11;
                LDB: RegFileControl               = 2'b10;
                NOP: RegFileControl               = 2'b00;
                default: RegFileControl           = 2'b00;
            endcase
        end

endmodule
