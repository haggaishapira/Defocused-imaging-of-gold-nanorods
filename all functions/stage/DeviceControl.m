classdef DeviceControl
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
 
    properties 

      IsComEnabled = false;
      ForceStopThread = false;
      SerialObj;
      XTotalTravel;
      YTotalTravel;
      SpeedMin =0;
      SpeedMax =12800;
    end
   
    properties (Constant)
        ResolutionX = 0.3125;
        ResolutionY = 0.3125;
        
        DEVICE = 100;
        DEVICE_ACK = 200;
        MOVE = 19;
        SPEED = 34;
        OK = 10;
        DIRPLUS = 125;
        DIRMINUS = 175;
        DIRMINUS_NOTCHECK = 135;
        READ = 163;
        READ_ACK = 164;
        ACCELERATION = 20;
        DECELARATION = 30;
        TRIGIN = 187;
        TRIGOUT = 192;
        TRIG_ACK = 191;
        STOP = 104;
        STOP_ACK = 105;

        

    end
    
    methods 
        
        function Obj = ConfigSerialport(Obj,COMport)
           
            try
                objs = instrfind('Port',COMport);
                if ~isempty(objs)    
                    fclose(objs);
                end

                Obj.SerialObj = serial(COMport);
                Obj.SerialObj.BaudRate = 19200;
                Obj.SerialObj.Parity = 'none';
                Obj.SerialObj.StopBits =1;    
                Obj.SerialObj.Timeout = 1;
                Obj.SerialObj.DataBits = 8;
                fopen(Obj.SerialObj);
                Obj.IsComEnabled = true;
           catch
                Obj.IsComEnabled = false;
 
           end
                     
        end

        function [Status] = Connect(Obj)

            Status = false;
            fwrite(Obj.SerialObj,Obj.DEVICE,'uchar');
            
            for c = 1:10
                data = fread(Obj.SerialObj,1,'uchar');
                if data == Obj.DEVICE_ACK
                    Status =true;
                    break;
                end
            end
        end
        
        function [Status] = ReadAck(Obj,data)
             try
                while(1)
                    in = fread(Obj.SerialObj,1,'uchar');
                    if(in == data)
                       Status = true;
                       break;
                    elseif Obj.ForceStopThread
                       break;
                    end
                end     
             catch
                Status = false;
             end
        end
        
        function [in,status] = ReadPortWhile(Obj)
        
            while(1)
                try    
                  in = fread(Obj.SerialObj,1,'uchar');
                  status = true;
                  break;
                catch
                  in=0;
                  status =false;
                end
            end     
        end
        
        function [Status] = WritePort(Obj,data)
              Count =0;
              while Count<10
                 try
                    fwrite(Obj.SerialObj,data,'uchar');
                    Count =10;
                    Status = true;
                 catch
                     Status = false;
                     Count = Count+1;
                    
                 end
              end
        end

        function [Status,Xsteps,Ysteps] = Move(Obj,DataX,DataY, DataAcce,DataDece,HomeLimitCheck)
            global IsStopthread;
            IsStopthread = false;
            
           % while(1)
           %     if IsStopthread
           %      break;
           %     end
           %     pause(0.1);
           % end
         
            Obj.ForceStopThread = false;
            
            Obj.WritePort(Obj.MOVE);
            Obj.ReadAck(Obj.OK);
          
            
            %X Axis 
            %Byte2
            MovX = abs(DataX)/Obj.ResolutionX;
            Byte2 = floor(MovX/65536);
            Obj.WritePort(Byte2);
            Obj.ReadAck(Obj.OK);
            %Byte1
            Byte1 = floor(rem(MovX,65536)/256);
            Obj.WritePort(Byte1);
            Obj.ReadAck(Obj.OK);
            %Byte0
            Byte0 = floor(rem(rem(MovX,65536),256));
            Obj.WritePort(Byte0);
            Obj.ReadAck(Obj.OK);
            
            if DataX<0
                if HomeLimitCheck==1
                  Obj.WritePort(Obj.DIRMINUS);
                else
                  Obj.WritePort(Obj.DIRMINUS_NOTCHECK);
                end
            else
               Obj.WritePort(Obj.DIRPLUS);
            end
            
            Obj.ReadAck(Obj.OK);
            
            %Y Axis      
            %Byte2
            MovY = abs(DataY)/Obj.ResolutionY;
            Byte2 = floor(MovY/65536);
            Obj.WritePort(Byte2);
            Obj.ReadAck(Obj.OK);
            %Byte1
            Byte1 = floor(rem(MovY,65536)/256);
            Obj.WritePort(Byte1);
            Obj.ReadAck(Obj.OK);
            %Byte0
            Byte0 = floor(rem(rem(MovY,65536),256));
            Obj.WritePort(Byte0);
            Obj.ReadAck(Obj.OK);
            
            if DataY<0
                if HomeLimitCheck==1
                  Obj.WritePort(Obj.DIRMINUS);
                else
                  Obj.WritePort(Obj.DIRMINUS_NOTCHECK);
                end
            else
                Obj.WritePort(Obj.DIRPLUS);
            end
            Obj.ReadAck(Obj.OK);
            
   
            %acceleration
            if DataAcce
             Obj.WritePort(Obj.ACCELERATION);
            else
             Obj.WritePort(0);
            end

            Obj.ReadAck(Obj.OK);
            
             %decceleration
            if DataDece
             Obj.WritePort(Obj.DECELARATION);
            else
             Obj.WritePort(0);
            end
            
            Obj.ReadAck(Obj.OK);
            
      
            while(1) 
             data= fread(Obj.SerialObj,1,'uchar'); 
            if data == 40
               Status = 'X Far Limit'; 
               break;
            elseif data == 41
               Status = 'X Home Limit'; 
               break;
            elseif data == 42
               Status = 'Y Far Limit'; 
               break;
            elseif data == 43
               Status = 'Y Home Limit';
               break;
            elseif data == 170
               Status = 'Movement Completed'; 
               break;
            end
            
            if IsStopthread
               Obj.WritePort(Obj.STOP);
               Obj.ReadAck(Obj.STOP_ACK);
               Status = 'Movement Stopped';
               break;
             end
             pause(0.1);
            end
              
     
            
            Obj.WritePort(Obj.READ);
            Obj.ReadAck(Obj.READ_ACK);
            
            %byte0
            Obj.WritePort(Obj.OK);
            Byte0=ReadPortWhile(Obj);
            
            %byte1
            Obj.WritePort(Obj.OK);
            Byte1=ReadPortWhile(Obj);
            
            %byte2
            Obj.WritePort(Obj.OK);
            Byte2=ReadPortWhile(Obj);
            
            Xsteps = (Byte2 * 65536) + (Byte1 * 256) + Byte0;
            
        
            if data == 41 % Home Limit
                Xsteps =0;
            elseif data == 170 %completed 
               Xsteps = DataX;
            else
               Xsteps = Xsteps*Obj.ResolutionX;
            end
                
            
             %byte0
            Obj.WritePort(Obj.OK);
            Byte0=ReadPortWhile(Obj);
            
            %byte1
            Obj.WritePort(Obj.OK);
            Byte1=ReadPortWhile(Obj);
            
            %byte2
            Obj.WritePort(Obj.OK);
            Byte2=ReadPortWhile(Obj);
            
            Ysteps = (Byte2 * 65536) + (Byte1 * 256) + Byte0;
  
            
            if data == 43 % Y Home Limit
                Ysteps =0;
            elseif data == 170 %completed 
               Ysteps = DataY;
            else
               Ysteps = Ysteps*Obj.ResolutionY;
            end
            
          
        end
        
        function [Status] = Speed(Obj,speed,spd,incr,stps)

      
            Obj.ForceStopThread = false;
            
    
            Obj.WritePort(Obj.SPEED);
            Obj.ReadAck(Obj.OK);

            %speed
            %Byte1
            Byte1 = floor(speed/256);
            Obj.WritePort(Byte1);
            Obj.ReadAck(Obj.OK);
            %Byte0
            Byte0 = floor(rem(speed,256));
            Obj.WritePort(Byte0);
            Obj.ReadAck(Obj.OK);

            %SPD
            %Byte1
            Byte1 = floor(spd/256);
            Obj.WritePort(Byte1);
            Obj.ReadAck(Obj.OK);
            %Byte0
            Byte0 = floor(rem(spd,256));
            Obj.WritePort(Byte0);
            Obj.ReadAck(Obj.OK);

            %INCR
            %Byte1
            Byte1 = floor(incr/256);
            Obj.WritePort(Byte1);
            Obj.ReadAck(Obj.OK);
            %Byte0
            Byte0 = floor(rem(incr,256));
            Obj.WritePort(Byte0);
            Obj.ReadAck(Obj.OK);

            %STPS
            %Byte1
            Byte1 = floor(stps/256);
            
            Obj.WritePort(Byte1);
            Obj.ReadAck(Obj.OK);
            %Byte0
            Byte0 = floor(rem(stps,256));
            Obj.WritePort(Byte0);
            Obj.ReadAck(Obj.OK);

            Status = true;
        end
        
        function [Status] = TrigIN(Obj)
            
            Obj.ForceStopThread = false;
            
            Obj.WritePort(Obj.TRIGIN);
            Obj.ReadAck(Obj.TRIG_ACK);
            
            Status = true;
        end
          
        function [Status] = TrigOUT(Obj)

            Obj.ForceStopThread = false;
            
            Obj.WritePort(Obj.TRIGOUT);
            Obj.ReadAck(Obj.TRIG_ACK);
            
            Status = true;
        end
        
          function [Status] = StopTrue(Obj)
            global IsStopthread;
            IsStopthread = true;
            Status = IsStopthread;
        end
        
    end
    
end

