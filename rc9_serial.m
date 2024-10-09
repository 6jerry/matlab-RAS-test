classdef rc9_serial < handle
 


    properties(Constant)

        FRAME_HEAD_0 = uint8(hex2dec('FC'));
        FRAME_HEAD_1 = uint8(hex2dec('FB'));
        FRAME_END_0 = uint8(hex2dec('FD'));
        FRAME_END_1 = uint8(hex2dec('FE'));
        MAX_DATA_LENGTH = int8(64);

    end

   properties (Access=public)

        state = 'WAITING_FOR_HEADER_0';
         rxIndex =0;
         rx_byte =uint8(0);
    
        rx_frame=struct('data_lenth',uint8(0),'head',uint8([]),'end'...
            ,uint8([]),'id',uint8(0),'crc_calculated',uint16(0),'temp_buff',uint8([]),...
            'msg_get',single([]),'crc_code',uint8([]),'msg_buff',uint8([]));

        tx_frame=struct('data_lenth',uint8(0),'head',uint8([]),'end'...
            ,uint8([]),'id',uint8(0),'crc_calculated',uint16(0),'temp_buff',uint8([]),...
            'msg_get',single([]),'crc_code',uint8([]),'send_buff',uint8([]));

        serial_obj;
        
    end


    methods

        
        function connect(obj,com_)

             try
                obj.serial_obj= serialport(char(com_), 115200);
                 disp("connect success"+" "+string(com_));
                 configureCallback( obj.serial_obj, "byte", 1, @obj.serialCallback);
             catch
                 disp("connect error"+" "+string(com_));
             end

         end
         function disconnect(obj)
            if ~isempty(obj.serial_obj) && isvalid(obj.serial_obj)
                configureCallback(obj.serial_obj, "off"); % 关闭回调函数
                delete(obj.serial_obj); % 删除串口对象
                obj.serial_obj = [];
                disp("Serial connection closed successfully.");
            else
                disp("No active serial connection to close.");
            end
         end

        function handle_data(obj)

            switch obj.state
                case 'WAITING_FOR_HEADER_0'
                    if obj.rx_byte == obj.FRAME_HEAD_0
                        obj.state = 'WAITING_FOR_HEADER_1';
                        obj.rx_frame.head(1)=obj.rx_byte;
                    else
                        disp("head0 error "+num2str(obj.rx_byte));
                    end 
                case 'WAITING_FOR_HEADER_1'
                    if obj.rx_byte==obj.FRAME_HEAD_1
                        obj.state='WAITING_FOR_ID';
                        obj.rx_frame.head(2)=obj.rx_byte;
                    else
                         obj.state='WAITING_FOR_HEADER_0';
                         disp("head1 error "+num2str(obj.rx_byte));
                    end
                case 'WAITING_FOR_ID'
                    obj.rx_frame.id=obj.rx_byte;
                    obj.state='WAITING_FOR_LENGTH';
                case 'WAITING_FOR_LENGTH'
                    obj.rx_frame.data_lenth=obj.rx_byte;
                    obj.state='WAITING_FOR_DATA';
                    obj.rxIndex=0;
                case 'WAITING_FOR_DATA'
                     obj.rx_frame.temp_buff(obj.rxIndex + 1) = obj.rx_byte;
                    obj.rxIndex = obj.rxIndex + 1;
                    if obj.rxIndex >= obj.rx_frame.data_lenth
                        obj.state = 'WAITING_FOR_CRC_0';
                    end
                case 'WAITING_FOR_CRC_0'
                    obj.rx_frame.crc_code(1)=obj.rx_byte;
                    obj.state='WAITING_FOR_CRC_1';
                case 'WAITING_FOR_CRC_1'
                    obj.rx_frame.crc_code(2)=obj.rx_byte;
                    obj.state='WAITING_FOR_END_0';
                case 'WAITING_FOR_END_0'
                     if obj.rx_byte == obj.FRAME_END_0
                         obj.rx_frame.end(1)=obj.rx_byte;
                        obj.state = 'WAITING_FOR_END_1';
                     else
                         disp("end0 error "+num2str(obj.rx_byte));
                        obj.state = 'WAITING_FOR_HEADER_0';
                     end
                case 'WAITING_FOR_END_1'
                    if obj.rx_byte == obj.FRAME_END_1
                        obj.rx_frame.end(2)=obj.rx_byte;
                        obj.rx_frame.msg_buff=obj.rx_frame.temp_buff;
                        obj.rx_frame.msg_get=typecast(obj.rx_frame.msg_buff,'single');
                        disp(obj.rx_frame.msg_get);
                        obj.state = 'WAITING_FOR_HEADER_0';
                    else
                        disp("end1 error "+num2str(obj.rx_byte));
                        obj.state = 'WAITING_FOR_HEADER_0';
                    end
            end

        

        end
        function serialCallback(obj, src, ~)
            obj.rx_byte = read(src, 1, "uint8"); 
            obj.handle_data();
        end

        function serialsend(obj,datas,dataid)
            obj.tx_frame.id=dataid;
            obj.tx_frame.temp_buff=typecast(datas,'uint8');
            obj.tx_frame.data_lenth=length(obj.tx_frame.temp_buff);

            obj.tx_frame.send_buff(1)=obj.FRAME_HEAD_0;
            obj.tx_frame.send_buff(2)=obj.FRAME_HEAD_1;
            obj.tx_frame.send_buff(3)=obj.tx_frame.id;
            obj.tx_frame.send_buff(4)= obj.tx_frame.data_lenth;
            obj.tx_frame.send_buff(5:4 + obj.tx_frame.data_lenth)=obj.tx_frame.temp_buff;
            obj.tx_frame.send_buff(5 + obj.tx_frame.data_lenth) = uint8(0);
            obj.tx_frame.send_buff(6 + obj.tx_frame.data_lenth) = uint8(0);
            obj.tx_frame.send_buff(7 + obj.tx_frame.data_lenth) = obj.FRAME_END_0;
            obj.tx_frame.send_buff(8 + obj.tx_frame.data_lenth) = obj.FRAME_END_1;

            write(obj.serial_obj, obj.tx_frame.send_buff, 'uint8');


        end
        function delete(obj)
            obj.disconnect();
        end

        function float_datas=get_float_data(obj)
            float_datas=obj.rx_frame.msg_get;
        end




    end
    













end