classdef fileSplitter < handle
% fileSplitter is a class that reads data from a data acqusition object and
% saves it to a file. It plots chunks of data to a figure for real time
%viewing of the data. Figure is designed to look like a Tektronix scope 
% screen because it is cool. Or just intuitive to me.
% Aleks Zosuls Boston University 2016

    properties
    maxFileSize    
    end
   properties (SetAccess = private)
       fileName
       fid
       runningFileSize
       fStat
   end
   
   methods
       function FS = fileSplitter(maxFileSize)
           FS.runningFileSize = 0;
           FS.maxFileSize = maxFileSize;
            %init properties
       end
       
       function newFile(FS)
           timeFormat='yyyy-mm-dd-HH-MM-SS';
           timeStamp = datestr(fix(clock),timeFormat);
           FS.fileName = ['magSurvey-',timeStamp,'.dat']; 
           FS.fid = fopen(FS.fileName, 'w');
       end
       
       function close(FS)
            FS.fStat = fclose(FS.fid);
           %delete(FS.fid)
       end
       
       function accumulateData(FS, event)
           cat = event.Data;
           FS.runningFileSize = FS.runningFileSize + size(cat,1);
           if (FS.runningFileSize > FS.maxFileSize)
               FS.runningFileSize = 0;
               FS.close;
               FS.newFile();     
           end
           fprintf(FS.fid,'%6.4f\t %6.4f\t %6.4f\r\n', [cat(:,1)'; cat(:,2)'; cat(:,3)']);
           figure(88)
           cla
           h = gca;
           h.Color = 'black';
           plot(cat(:,1),'y')
           hold on
           plot(cat(:,2),'b')
           plot(cat(:,3),'m')
       end
           
       function delete(FS)
           try
               FS.fStat = fclose(FS.fid);
           catch
           end
        end
           
   end
end