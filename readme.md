1、题目描述
在Quartus软件上使用Verilog HDL为银行售票机设计一个数字系统，规格如下:

1. 为至少3种不同类型的银行服务出具票据。也就是说，每一种服务都会发放一张以不同数字或字母开头的票。
2. 考虑至少有4名银行职员值班。
3. 银行职员按下一个按钮来获取下一个排队号码。
4. 在7段显示器上显示下一个票号和银行职员的柜台号码。
5. 票上显示等候的顾客人数。
6. 利用有限状态机(FSM)设计银行票务机。您的设计可能需要算术电路、组合电路、寄存器和计数器。
7. 用流程图展示你设计的系统。
8. 使用ModelSim软件验证设计的功能。
## 1、设计思路
这个模块是一个银行取号机的有限状态机（FSM），它接收时钟信号和复位信号，并根据客户按下的服务按钮和工作人员按下的按钮来控制取号和显示功能。
根据不同的服务类型和工作人员，它会分配不同的取号票号码和显示工作人员的柜台号码。模块中定义了多个状态和参数，包括IDLE（空闲）、SERVICE（请求服务）、DISPLAY（显示）等状态，以及General_Serivces（普通服务）、Loan_Services（贷款服务）和Coustemer_Service（客户服务）等服务类型参数，还有Officer1、Officer2、Officer3、Officer4等工作人员编号参数。
模块内部通过时钟和复位信号控制状态转换，并根据不同的状态执行相应的操作，包括初始化取号机信息、处理客户按下服务按钮的情况、处理工作人员按下按钮的情况等。

## 2、模块端口信号

1. **输入时钟信号 clk**：用于驱动有限状态机的时钟信号。
2. **输入复位信号 rst_n**：复位信号，当为低电平时对模块进行复位操作。
3. **输入客户服务按钮信号 service_ButtonPress**：表示客户请求服务的按钮信号，根据不同的值分别对应不同的服务类型（普通服务、贷款服务、客户服务）。
4. **输入工作人员按钮信号 officer_ButtonPress**：表示工作人员按下的按钮信号，根据不同的值分别对应不同的工作人员编号。
5. **输出取号票号码 Tickernum**：显示下一个可用的取号票号码。
6. **输出银行柜台号码 Desknum**：显示银行工作人员的柜台号码。
7. **输出等候客户取号数 ticket_WaitingCustomers**：显示目前等待的客户数量。
8. **输出取号票类型 ticket_ServiceType**：每种服务类型将分配不同类型的取号票号码。

## 3、Modelsim仿真波形图
顶层模块仿真波形图
![image.png](https://cdn.nlark.com/yuque/0/2024/png/46194192/1721793939621-27ecc7ea-a057-4ba4-830e-bcab109aeb0b.png#averageHue=%23272626&clientId=ua73ee0f2-0219-4&from=paste&height=134&id=u4c1f535f&originHeight=201&originWidth=1496&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=25840&status=done&style=none&taskId=u076d0138-8b86-4d42-b3cf-1cf17ed280c&title=&width=997.3333333333334)
内部信号仿真波形图
![image.png](https://cdn.nlark.com/yuque/0/2024/png/46194192/1721794053880-0f2d0ca7-4fd2-4a0a-9ecf-f203cba2b7cd.png#averageHue=%23262625&clientId=ua73ee0f2-0219-4&from=paste&height=182&id=u880386c1&originHeight=273&originWidth=1538&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=36318&status=done&style=none&taskId=ub1004e56-14cb-4abd-ae1e-e26602c75b8&title=&width=1025.3333333333333)

## 4、FSM跳转过程
![image.png](https://cdn.nlark.com/yuque/0/2024/png/46194192/1721794534086-041b91c4-8a1d-43dd-8110-64c775e37790.png#averageHue=%23f0eeed&clientId=ua73ee0f2-0219-4&from=paste&height=631&id=ud6841420&originHeight=946&originWidth=1661&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=101164&status=done&style=none&taskId=u24a3c286-f556-4004-8652-8cd912baf9a&title=&width=1107.3333333333333)
## 5、流程图
![image.png](https://cdn.nlark.com/yuque/0/2024/png/46194192/1721794914024-205952db-dab6-4b81-b0de-2b1b113a3234.png#averageHue=%23d7e0f1&clientId=ua73ee0f2-0219-4&from=paste&height=382&id=udc182b26&originHeight=573&originWidth=465&originalType=binary&ratio=1.5&rotation=0&showTitle=false&size=18477&status=done&style=none&taskId=u9b93b519-bece-4426-80d1-55b8f5327bc&title=&width=310)
## 6、Quartus代码
```verilog
module BankTicketMachineFSM (
    input clk,
    input rst_n,
    input [2:0] service_ButtonPress, //001: general serivces;010:loan services;100:coustemer service
    input [3:0] officer_ButtonPress,   //0001:officer 1; 0010:officer 2; 0100:officer 3;1000:officer 4
    output reg [6:0] Tickernum,  //Display the next ticket number
    output reg [1:0] Desknum,   //Display the bank officer’s desk number
    output reg [15:0] ticket_WaitingCustomers,  //The ticket shows the number of waiting customers
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

```
## 7、Modelsim仿真代码
```verilog
module tb_BankTicketMachineFSM;

    // Inputs
    reg clk;
    reg rst_n;
    reg [2:0] service_ButtonPress;
    reg [3:0] officer_ButtonPress;

    // Outputs
    wire [6:0] Tickernum;
    wire [1:0] Desknum;
    wire [15:0] ticket_WaitingCustomers;
    wire [2:0] ticket_ServiceType;

    // Instantiate the module under test
    BankTicketMachineFSM dut (
        .clk(clk),
        .rst_n(rst_n),
        .service_ButtonPress(service_ButtonPress),
        .officer_ButtonPress(officer_ButtonPress),
        .Tickernum(Tickernum),
        .Desknum(Desknum),
        .ticket_WaitingCustomers(ticket_WaitingCustomers),
        .ticket_ServiceType(ticket_ServiceType)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        clk = 0;
        rst_n = 0;
        service_ButtonPress = 0;
        officer_ButtonPress = 0;
        #10 rst_n = 1;
    end

    // Stimulus
    initial begin
        // First state is IDLE
        // No button press, so outputs should remain at their initial values
        // Wait for some time
        #20;
        // Press general services button
        service_ButtonPress = 3'b001;
        #20;
        // Press general services button again
        service_ButtonPress = 3'b001;
        #20;
        // Press general services button again
        service_ButtonPress = 3'b001;
        #20;
        // Press general services button again
        service_ButtonPress = 3'b001;
        #20;
        // Press loan services button 
        service_ButtonPress = 3'b010;
        #20;
        // Press loan services button again
        service_ButtonPress = 3'b010;
        #20;
        // Press coustemer service button
        service_ButtonPress = 3'b100;
        #20;
        // Press coustemer service button again
        service_ButtonPress = 3'b100;

        // Wait for some time
        #20;
        service_ButtonPress = 3'b000;

        // Press officer 1 button
        officer_ButtonPress = 4'b0001;

        // Wait for some time
        #20;

        // Press officer 1 button
        officer_ButtonPress = 4'b0001;

        // Wait for some time
        #20;

        // Press officer 2 button
        officer_ButtonPress = 4'b0010;

        // Wait for some time
        #20;

        // Press officer 2 button
        officer_ButtonPress = 4'b0010;

        // Wait for some time
        #20;

        // Press officer 3 button
        officer_ButtonPress = 4'b0100;

        // Wait for some time
        #20;

        // Press officer 4 button
        officer_ButtonPress = 4'b1000;

        // Wait for some time
        #20;

        // Press no button
        officer_ButtonPress = 4'b0000;

        // Wait for some time
        #20;

    end

endmodule
```
