module BankTicketMachineFSM (
    input clk,
    input rst_n,
    input [2:0] service_ButtonPress, //001: general serivces;010:loan services;100:coustemer service
    input [3:0] officer_ButtonPress,   //0001:officer 1; 0010:officer 2; 0100:officer 3;1000:officer 4
    output reg [6:0] Tickernum,  //Display the next ticket number
    output reg [1:0] Desknum,   //Display the bank officer’s desk number
    output reg [15:0] ticket_WaitingCustomers,  //The ticket shows the number of waiting customers
    output reg [2:0] ticket_ServiceType //Each type of service will dispense a ticket starting with different number
    );

// State definitions
parameter IDLE = 3'b001;
parameter SERVICE = 3'b010;  //request service
parameter DISPLAY = 3'b100;  //display tickernum and desknum

//Service State Parameters
parameter General_Serivces = 3'b001;
parameter Loan_Services = 3'b010;
parameter Coustemer_Service = 3'b100;

//Officer State Parameters
parameter Officer1 = 4'b0001;
parameter Officer2 = 4'b0010;
parameter Officer3 = 4'b0100;
parameter Officer4 = 4'b1000;

reg [2:0] service_ButtonPress_reg;
reg [3:0] officer_ButtonPress_reg;

reg [15:0] queuingNumber[2:0]; // Queuing numbers for each service type
reg [2:0] state, nextState; // FSM states

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        service_ButtonPress_reg <= 'b0;
        officer_ButtonPress_reg <= 'b0;
    end
    else begin
        service_ButtonPress_reg <= service_ButtonPress;
        officer_ButtonPress_reg <= officer_ButtonPress;
    end
end

//FSM
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE; // Initialize state to IDLE
    end 
    else begin
        state <= nextState; // Transition to next state
    end
end

always @(*)begin
    if(!rst_n)begin
        nextState <= IDLE;
    end
    else begin
        if(service_ButtonPress!=3'b000)begin
            nextState <= SERVICE;
        end
        else if (officer_ButtonPress!=4'b0000) begin
            nextState <= DISPLAY;
        end
        else begin
            nextState <= IDLE;
        end
    end
end

always@(posedge clk or negedge rst_n)begin
    if (!rst_n) begin
        Tickernum <= 'b0;
        Desknum <= 'b0;
        ticket_WaitingCustomers <= 'b0;
        ticket_ServiceType <= 'b0;
        queuingNumber[0] <= 'b0; // Initial queuing number for general services
        queuingNumber[1] <= 'b0; // Initial queuing number for loan services
        queuingNumber[2] <= 'b0; // Initial queuing number for customer services
    end
    else begin
        case(state)
        IDLE:begin
            Tickernum <= Tickernum;
            Desknum <= Desknum;
            ticket_WaitingCustomers <= ticket_WaitingCustomers;
            ticket_ServiceType <= ticket_ServiceType;
            queuingNumber[0] <= queuingNumber[0]; // Initial queuing number for general services
            queuingNumber[1] <= queuingNumber[1]; // Initial queuing number for loan services
            queuingNumber[2] <= queuingNumber[2]; // Initial queuing number for customer services
        end
        SERVICE:begin
            case(service_ButtonPress_reg)
                General_Serivces:begin
                    queuingNumber[0] <= queuingNumber[0] + 1'b1;
                    ticket_WaitingCustomers <= queuingNumber[0];
                    ticket_ServiceType <= General_Serivces;
                end
                Loan_Services:begin
                    queuingNumber[1] <= queuingNumber[1] + 1'b1;
                    ticket_WaitingCustomers <= queuingNumber[1];
                    ticket_ServiceType <= Loan_Services;
                end
                Coustemer_Service:begin
                    queuingNumber[2] <= queuingNumber[2] + 1'b1;
                    ticket_WaitingCustomers <= queuingNumber[2];
                    ticket_ServiceType <= Coustemer_Service;
                end
                default:begin
                    ticket_WaitingCustomers <= ticket_WaitingCustomers;
                    ticket_ServiceType <= ticket_ServiceType;
                end
            endcase
        end
        DISPLAY:begin
            case(officer_ButtonPress_reg)
                Officer1:begin
                    Desknum <= 2'd0;
                    if(queuingNumber[0]>0)begin
                        queuingNumber[0]<=queuingNumber[0]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[1]>0)begin
                        queuingNumber[1]<=queuingNumber[1]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[2]>0)begin
                        queuingNumber[2]<=queuingNumber[2]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else begin
                        Tickernum <= Tickernum;
                    end
                end
                Officer2:begin
                    Desknum <= 2'd1;
                    if(queuingNumber[1]>0)begin
                        queuingNumber[1]<=queuingNumber[1]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[2]>0)begin
                        queuingNumber[2]<=queuingNumber[2]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[2]>0)begin
                        queuingNumber[0]<=queuingNumber[0]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else begin
                        Tickernum <= Tickernum;
                    end
                end
                Officer3:begin
                    Desknum <= 2'd2;
                    if(queuingNumber[2]>0)begin
                        queuingNumber[2]<=queuingNumber[2]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[0]>0)begin
                        queuingNumber[0]<=queuingNumber[0]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[1]>0)begin
                        queuingNumber[1]<=queuingNumber[1]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else begin
                        Tickernum <= Tickernum;
                    end
                end
                Officer4:begin
                    if(queuingNumber[0]>0)begin
                        queuingNumber[0]<=queuingNumber[0]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[2]>0)begin
                        queuingNumber[2]<=queuingNumber[2]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else if(queuingNumber[2]>0)begin
                        queuingNumber[1]<=queuingNumber[1]-1'b1;
                        Tickernum <= Tickernum + 1'b1;
                    end
                    else begin
                        Tickernum <= Tickernum;
                    end
                end
                default:begin
                    Tickernum <= Tickernum;
                    Desknum <= Desknum;
                end
            endcase
        end
        endcase
    end
end

endmodule
